//caution do not edit this file manually it is a template in tenjin format
`define  Buff_size 32
////////////////////////////////////////////
module top(clk,rst_n,rs232_rx, BusA,BusB, led);

///////////////////////////////////////////
input clk;	// 50MHz
input rst_n;	//reset, neg edge.
input rs232_rx;	// RS232 rec
//output rs232_tx;	//	RS232 transfer
/////////////////////////////////////////

inout [47:38] BusA;
inout [73:56] BusB;


////////////////////////////////////////
output led; // debug led

// state control						
parameter IDLE = 3'b000;
parameter S1 = 3'b001;
parameter WAIT = 3'b010;
parameter SAVE = 3'b100;

// commond reg
parameter A=8'h41 ;
parameter B=8'h42 ;
parameter C=8'h43 ;
parameter D=8'h44 ;
parameter E=8'h45 ;
parameter F=8'h46 ;
parameter G=8'h47 ;
parameter H=8'h48 ;
parameter I=8'h49 ;
parameter J=8'h4a ;
parameter K=8'h4b ;
parameter L=8'h4c ;
parameter M=8'h4d ;
parameter N=8'h4e ;
parameter O=8'h4f ;
parameter P=8'h50 ;
parameter Q=8'h51 ;
parameter R=8'h52 ;
parameter S=8'h53 ;
parameter T=8'h54 ;
parameter U=8'h55 ;
parameter V=8'h56 ;
parameter W=8'h57 ;
parameter X=8'h58 ;
parameter Y=8'h59 ;
parameter Z=8'h5a ;
parameter Z0=8'h30 ;
parameter I1=8'h31 ;
parameter II=8'h32 ;
parameter III=8'h33 ;
parameter IV=8'h34 ;
parameter V5=8'h35 ;
parameter VI=8'h36 ;
parameter VII=8'h37 ;
parameter VIII=8'h38 ;
parameter VIIII=8'h39 ;

//definition of inputs/outputs
wire test;
wire Flag; // signal the uart has data
wire rs232_rx;
wire clk,rst_n;
wire bps_start;	// start receive
wire bps_start_t;	// start tranmit
wire clk_bps;	//  uart bps
wire clk_bps_t;	//  uart bps
wire[7:0] rx_data; // receive data to parser
wire rx_int;       // receive interrupt

wire rx_error;
wire tx_error;

wire rx_complete;
wire tx_complete;
	
wire[7:0] tx_data;
wire rs232_tx;


wire [25:0] out_status;
wire press_done;
wire button_tx_start;
           
wire led_input;
wire led_tx_start;
          



////////////////////////////////////////////////////////////////////////////////////////////////
//debug led
reg led;
reg cmd_red;																			
// settings for log register
reg [`Buff_size-1:0] Buff_temp;
reg [`Buff_size-9:0] Rx_cmd;											
reg [2:0] Current, Next;		
reg Flag_temp;
//build in module enable
reg linkBIM;
reg capture_rst;
reg linkBVS;

reg  button_rst_n;
reg  button_hold_rst;
    reg linkBDT;
reg linkBST;
reg linkBLS;
reg linkBSS;
reg linkBSM;
reg linkCAI;
 
reg led_capture_rst; 
    reg linkUART;
reg linkBSA;
reg linkCAC;
reg linkBSC;
reg linkBHT;
reg linkBSB;
reg linkBSI;


assign BusB[64] =  linkBVS ? out_status[18] : 1'bz;
assign BusB[73] =  linkBVS ? rs232_tx : 1'bz;
assign BusB[57] =  linkBDT ? out_status[19] : 1'bz;
assign BusB[73] =  linkBDT ? rs232_tx : 1'bz;
assign BusB[57] =  linkBST ? out_status[19] : 1'bz;
assign BusB[73] =  linkBST ? rs232_tx : 1'bz;
assign BusB[64] =  linkBLS ? out_status[18] : 1'bz;
assign BusB[73] =  linkBLS ? rs232_tx : 1'bz;
assign BusB[64] =  linkBSS ? out_status[18] : 1'bz;
assign BusB[73] =  linkBSS ? rs232_tx : 1'bz;
assign BusA[47] =  linkBSM ? out_status[12] : 1'bz;
assign BusB[73] =  linkBSM ? rs232_tx : 1'bz;
assign led_input =  linkCAI ? BusB[58] : 1'bz;
assign BusB[73] =  linkCAI ? rs232_tx : 1'bz;
assign BusA[38] =  linkBSA ? out_status[0] : 1'bz;
assign BusB[73] =  linkBSA ? rs232_tx : 1'bz;
assign led_input =  linkCAC ? BusB[56] : 1'bz;
assign BusB[73] =  linkCAC ? rs232_tx : 1'bz;
assign BusB[67] =  linkBSC ? out_status[2] : 1'bz;
assign BusB[73] =  linkBSC ? rs232_tx : 1'bz;
assign BusB[57] =  linkBHT ? out_status[19] : 1'bz;
assign BusB[73] =  linkBHT ? rs232_tx : 1'bz;
assign BusA[41] =  linkBSB ? out_status[1] : 1'bz;
assign BusB[73] =  linkBSB ? rs232_tx : 1'bz;
assign BusB[57] =  linkBSI ? out_status[8] : 1'bz;
assign BusB[67] =  linkBSI ? 1'b0 : 1'bz;
assign BusB[73] =  linkBSI ? rs232_tx : 1'bz;



button_hold		button_hold_instance(
							.rst(button_rst_n),
							.clk(clk),
							.out_status(out_status),
							.pin_select(Rx_cmd[15:0]),
							.press_done(press_done)
                            );

press_done_tx 	press_done_tx_instance(
							.clk(clk),
							.rst_n(button_hold_rst),
							.tx_start(button_tx_start),
							.press_done(press_done),
							.tx_data(tx_data)
							);
         
led_capture		 led_capture_instance(
							.led_input(led_input),
							.clk(clk),
							.rst_n(led_capture_rst),
							.tx_start(led_tx_start),
							.tx_data(tx_data)
							);
         
speed_select    speed_select( .clk(clk),  //baudrate selection
                      .rst_n(rst_n),
                      .rx_enable(bps_start),
                      .tx_enable(bps_start_t),
                      .buad_clk_rx(clk_bps),
                      .buad_clk_tx(clk_bps_t)
                      );

my_uart_rx      my_uart_rx(   .rst_n(rst_n), 
                      .baud_clk(clk_bps), 
                      .uart_rx(rs232_rx), 
                      .rx_data(rx_data),
                      .rx_enable(bps_start), 
                      .rx_complete(rx_complete), 
                      .rx_error(rx_error)
                      );
                      
my_uart_tx      my_uart_tx(   .rst_n(capture_rst), 
                      .baud_clk(clk_bps_t), 
                      .tx_start(led_tx_start & button_tx_start), 
                      .tx_data(tx_data), 
                      .tx_enable(bps_start_t), 
                      .tx_complete(tx_complete), 
                      .uart_tx(rs232_tx)
                      );
    

/////////////////////////////////////////////////////////////////////////////////////////////////////

reg flag_reg;
always @ (negedge bps_start or negedge rst_n)
begin
	if (!rst_n)
		flag_reg <= 1'b0;
	else if (!bps_start)
		flag_reg <= ~flag_reg;
end
assign Flag = flag_reg;

always @ (posedge clk or negedge rst_n)
begin
	if (!rst_n)
		Current <= IDLE;
	else
		Current <= Next;
end

// the state machine for receive data bytes
always @ (*)
begin
	Next = IDLE;
	case (Current)
		IDLE:
			if (rx_data == 8'h24) //$
				Next = S1;
			else
				Next = IDLE;
		S1:
			if (Flag_temp != Flag)
			begin
				if (rx_data != 8'h0d) //\n
					Next = S1;
				else
					Next = SAVE;
			end
			else
				Next = WAIT;
		WAIT:
			if (Flag_temp!=Flag)
			begin
				if (rx_data != 8'h0d)
					Next = S1;
				else
					Next = SAVE;
			end
			else
				Next = WAIT;
		default: Next = IDLE;
	endcase
end

always @ (posedge clk or negedge rst_n)
begin 
	if (!rst_n)
	begin
		Flag_temp <= 1'b0;
	end
	else
	begin
		Flag_temp <= Flag;
	end
end

always @ (posedge clk or negedge rst_n)
begin 
	if(!rst_n)
	begin
		Buff_temp <= `Buff_size'b0;
		Rx_cmd <= `Buff_size'b0;
		cmd_red <= 1'b0;
	end
	else
	begin
		case (Current)	
			IDLE:  
			begin
				Buff_temp <= `Buff_size'b0;
			end
			S1:
			begin
				cmd_red <= 1'b1;
				Buff_temp <= {{Buff_temp[`Buff_size - 9 : 0]}, rx_data};
			end 
			WAIT:
			begin
				Buff_temp <= Buff_temp;
			end 
			SAVE:
			begin
				Rx_cmd  <= Buff_temp[`Buff_size - 9 : 0];
				Buff_temp <= `Buff_size'b0;
				cmd_red <= 1'b0;
			end
			default: 
			begin
			end
		endcase		
	end	
end

always @ (posedge clk or negedge rst_n)
begin
  if(!rst_n)
  begin
    //////////////////add link here////////////////
			linkBVS <= 1'b0;
			linkBDT <= 1'b0;
			linkBST <= 1'b0;
			linkBLS <= 1'b0;
			linkBSS <= 1'b0;
			linkBSM <= 1'b0;
			linkCAI <= 1'b0;
			linkBSA <= 1'b0;
			linkCAC <= 1'b0;
			linkBSC <= 1'b0;
			linkBHT <= 1'b0;
			linkBSB <= 1'b0;
			linkBSI <= 1'b0;

    ///////////////////////////////////////////////
    led <= 1'b0; // for debug led
    linkBIM <= 1'b1;
  end
  else if(cmd_red) begin
						
	    button_rst_n <= 1'b0;
	    button_hold_rst <= 1'b0;
        
			linkBVS <= 1'b0;
			linkBDT <= 1'b0;
			linkBST <= 1'b0;
			linkBLS <= 1'b0;
			linkBSS <= 1'b0;
			linkBSM <= 1'b0;
			
    led_capture_rst <= 1'b0;
    
			linkCAI <= 1'b0;
			linkBSA <= 1'b0;
			linkCAC <= 1'b0;
			linkBSC <= 1'b0;
			linkBHT <= 1'b0;
			linkBSB <= 1'b0;
			linkBSI <= 1'b0;

            led <= 1'b0;
            capture_rst <= 1'b0;
  end
  else
  begin
    case(Rx_cmd)
    ///////////////////add case here/////////////
      
      {B,V, S}: //{C,M,D}
      begin
        linkBVS <= 1'b1;
			 
		button_rst_n <= 1'b1;
		capture_rst <= 1'b1;
		button_hold_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
      {B,D, T}: //{C,M,D}
      begin
        linkBDT <= 1'b1;
			 
		button_rst_n <= 1'b1;
		capture_rst <= 1'b1;
		button_hold_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
      {B,S, T}: //{C,M,D}
      begin
        linkBST <= 1'b1;
			 
		button_rst_n <= 1'b1;
		capture_rst <= 1'b1;
		button_hold_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
      {B,L, S}: //{C,M,D}
      begin
        linkBLS <= 1'b1;
			 
		button_rst_n <= 1'b1;
		capture_rst <= 1'b1;
		button_hold_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
      {B,S, S}: //{C,M,D}
      begin
        linkBSS <= 1'b1;
			 
		button_rst_n <= 1'b1;
		capture_rst <= 1'b1;
		button_hold_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
      {B,S, M}: //{C,M,D}
      begin
        linkBSM <= 1'b1;
			 
		button_rst_n <= 1'b1;
		capture_rst <= 1'b1;
		button_hold_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
      {C,A, I}: //{C,M,D}
      begin
        linkCAI <= 1'b1;
			 
    capture_rst <= 1'b1;
    led_capture_rst <= 1'b1;	
	

        led <= 1'b1;
      end
      
      {B,S, A}: //{C,M,D}
      begin
        linkBSA <= 1'b1;
			 
		button_rst_n <= 1'b1;
		capture_rst <= 1'b1;
		button_hold_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
      {C,A, C}: //{C,M,D}
      begin
        linkCAC <= 1'b1;
			 
    capture_rst <= 1'b1;
    led_capture_rst <= 1'b1;	
	

        led <= 1'b1;
      end
      
      {B,S, C}: //{C,M,D}
      begin
        linkBSC <= 1'b1;
			 
		button_rst_n <= 1'b1;
		capture_rst <= 1'b1;
		button_hold_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
      {B,H, T}: //{C,M,D}
      begin
        linkBHT <= 1'b1;
			 
		button_rst_n <= 1'b1;
		capture_rst <= 1'b1;
		button_hold_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
      {B,S, B}: //{C,M,D}
      begin
        linkBSB <= 1'b1;
			 
		button_rst_n <= 1'b1;
		capture_rst <= 1'b1;
		button_hold_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
      {B,S, I}: //{C,M,D}
      begin
        linkBSI <= 1'b1;
			 
		button_rst_n <= 1'b1;
		capture_rst <= 1'b1;
		button_hold_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
    /////////////////////////////////////////////

      {R,S,T}: //RESET
         begin
           			
	    button_rst_n <= 1'b0;
	    button_hold_rst <= 1'b0;
        
			linkBVS <= 1'b0;
			linkBDT <= 1'b0;
			linkBST <= 1'b0;
			linkBLS <= 1'b0;
			linkBSS <= 1'b0;
			linkBSM <= 1'b0;
			
    led_capture_rst <= 1'b0;
    
			linkCAI <= 1'b0;
			linkBSA <= 1'b0;
			linkCAC <= 1'b0;
			linkBSC <= 1'b0;
			linkBHT <= 1'b0;
			linkBSB <= 1'b0;
			linkBSI <= 1'b0;

            led <= 1'b0;
            linkBIM <= 1'b1;
            capture_rst <= 1'b0;
        end

         default:
         begin
          			
	    button_rst_n <= 1'b0;
	    button_hold_rst <= 1'b0;
        
			linkBVS <= 1'b0;
			linkBDT <= 1'b0;
			linkBST <= 1'b0;
			linkBLS <= 1'b0;
			linkBSS <= 1'b0;
			linkBSM <= 1'b0;
			
    led_capture_rst <= 1'b0;
    
			linkCAI <= 1'b0;
			linkBSA <= 1'b0;
			linkCAC <= 1'b0;
			linkBSC <= 1'b0;
			linkBHT <= 1'b0;
			linkBSB <= 1'b0;
			linkBSI <= 1'b0;

          led <= 1'b0;
          linkBIM <= 1'b1;
          capture_rst <= 1'b0;		  
      end
    endcase
  end
end


/////////////////////////////////////////////////////////////

endmodule
