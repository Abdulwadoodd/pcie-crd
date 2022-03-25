`timescale 1ns/1ps

module crd #(
    parameter iWIDTH = 10,
    parameter oWIDTH = $clog2(iWIDTH)
    ) ( 
    //output [oWIDTH - 1:0] ones_count,
    output reg err, crd_bit,
    input clk,
    input rst,
    input [iWIDTH - 1:0] data_in
    );
    
    /*      Datapath     */
    reg [iWIDTH-1 : 0] in_fetch;
    reg [oWIDTH-1:0] dum;
    wire oeq5, ogr5;
    reg beg;
    wire [oWIDTH - 1:0] ones_count;

    assign ones_count = dum;
    assign oeq5 = ((ones_count) == (iWIDTH>>1));
    assign ogr5 = ((ones_count) > (iWIDTH>>1));

    integer i;
    always @(posedge clk ) begin
        if(!rst) begin
            in_fetch = data_in;
            beg = 1'b1;
        end
        else begin
            in_fetch = 0;
            beg = 1'b0;
        end
    end
    
    always @(*) begin
        dum = 0;
        for(i=0; i<iWIDTH; i=i+1) begin
            dum = dum + in_fetch[i];
        end
    end

    /*      Melay state Machine        */
    parameter idle = 2'b00;
    parameter pos = 2'b01;
    parameter neg = 2'b10;

    reg [1:0] cs, ns;
    // State registers
    always @(posedge clk ) begin
        if(rst)
            cs <= idle;
        else
            cs <= ns;
    end
    // Output & next state logic
    always @(*) begin 
        casex (cs)
            idle: begin
                    if(rst | beg==0) begin
                        ns = idle;
                        err = 1'bx;
                        crd_bit = 1'bx;
                    end
                    else if(ogr5|oeq5)begin
                        ns = pos;
                        err = 0;
                        crd_bit = 1;
                    end
                    else begin
                        ns = neg;
                        err = 0;
                        crd_bit = 0;
                    end
                end 
            pos: begin
                    if(oeq5)begin
                        ns = pos;
                        err= 0;
                        crd_bit = 1;
                    end
                    if(ogr5) begin
                        ns = pos;
                        err = 1;
                        crd_bit=1;
                    end
                    if(~(oeq5|ogr5))begin
                        ns = neg;
                        err = 0;
                        crd_bit = 0;
                    end
                end
            neg: begin
                    if(oeq5)begin
                        ns = neg;
                        err= 0;
                        crd_bit = 0;
                    end
                    if(~(oeq5|ogr5)) begin
                        ns = neg;
                        err = 1;
                        crd_bit=0;
                    end
                    if(ogr5)begin
                        ns = pos;
                        err = 0;
                        crd_bit = 1;
                    end
                end
                default: begin
                        ns = idle;
                        err = 0;
                        crd_bit=1;
                    end
        endcase    
    end

endmodule