module byte_memory_ff(
    input data,
    input clk,
    input rst,
    output reg Q
);

    initial begin
        Q <=0;
    end
    always @(posedge clk) begin
        if (rst) //Synchronous Reset
            Q <= 1'b0; //Non-blocking "<=Assignment" 
        else 
            Q <= data;
    end
    assign NotQ = ~Q;
    
endmodule


module full_adder(
    input A,B,Cin,
    output Cout, Y
    );
    
    assign Y = A^B^Cin;
    assign Cout = (A&B) | (Cin&(A^B));
    
endmodule    


module ring_counter_1(
    input clk,
    input rst,
    output [2:0] state
);
    
    wire q0, q1, q2;

    byte_memory_T T_one (
        .clk(clk),
        .rst(rst),
        .t(1'b1),
        .Q(q0)
       );
    
    byte_memory_T T_two (
        .rst(rst),
        .t(1'b1),
        .clk(q0),
        .Q(q1)
        );
    
    byte_memory_T T_three (
        .clk(q1),
        .rst(rst),
        .t(1'b1),
        .Q(q2)
        );
            
    assign state[0] = q0;
    assign state[1] = q1;
    assign state[2] = q2;
   
endmodule


module byte_memory_T(
    input t,
    input rst,
    input clk,
    output reg Q
);
    
    wire d_input;
    assign d_input = t ? ~Q: Q;
    initial begin
        Q <=0;
    end
    
    always @(posedge clk) begin
        if (rst) begin
            Q <= 1'b0;
        end 
        else begin
            Q <= d_input;
        end
     end
           
endmodule



module modulo_counter(
    input clk,
    input rst,
    output [2:0] state,
    output out
    );
    
    wire outlogic, at_count, c_reset;
    wire [2:0] next_state;
    wire carry1, carry2, carry3;
    
    assign outlogic = at_count^out;
    assign at_count = (state[2]) & (~state[1]) & (state[0]);
    assign c_reset = at_count | rst;
    
    byte_memory_ff dff_out(
        .Q(out),
        .clk(clk),
        .rst(rst),
        .data(outlogic)
    );
    
    byte_memory_ff dff_one(
        .clk(clk),
        .rst(c_reset),
        .data(next_state[0]),
        .Q(state[0])
       );
       
    byte_memory_ff dff_two(
        .clk(clk),
        .rst(c_reset),
        .data(next_state[1]),
        .Q(state[1])
       );
       
    byte_memory_ff dff_three(
        .clk(clk),
        .rst(c_reset),
        .data(next_state[2]),
        .Q(state[2])
       );
    
    full_adder modulo_one (
        .A(state[0]),
        .B(1'b0),
        .Y(next_state[0]),
        .Cin(1'b1),
        .Cout(carry1)
       );
       
    full_adder modulo_two (
        .A(state[1]),
        .B(1'b0),
        .Y(next_state[1]),
        .Cin(carry1),
        .Cout(carry2)
       );
      
    full_adder modulo_three (
        .A(state[2]),
        .B(1'b0),
        .Y(next_state[2]),
        .Cout(carry3),
        .Cin(carry2)
    );
endmodule



module top(
    input btnU,
    input btnC,
    output [6:0] led
   );

    ring_counter_1 rc(
        .clk(btnC),
        .rst(btnU),
        .state(led[2:0])
       );
       
    modulo_counter mc(
        .clk(btnC),
        .rst(btnU),
        .state(led[5:3]),
        .out(led[6])
       );
endmodule
