//caution do not edit this file manually it is a template in tenjin format
`define  Buff_size 32
////////////////////////////////////////////
module top(clk,rst_n,rs232_rx, BusA,BusB,BusC,BusD,BusE,BusF, led);

///////////////////////////////////////////
input clk;	// 50MHz
input rst_n;	//reset, neg edge.
input rs232_rx;	// RS232 rec
//output rs232_tx;	//	RS232 transfer
/////////////////////////////////////////

inout [8:2] BusA;
inout [21:15] BusB;
inout [42:29] BusC;
inout [57:48] BusD;
inout [70:64] BusE;
inout [92:76] BusF;


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

 
wire compara_error_uart7bit;
wire compare_ok;
wire rs232_tx7to7;
wire rs232_rx7to7; 
     
wire compara_error;
wire rs232_tx8to8;
wire rs232_rx8to8;  
    



////////////////////////////////////////////////////////////////////////////////////////////////
//debug led
reg led;
																			
// settings for log register
reg [`Buff_size-1:0] Buff_temp;
reg [`Buff_size-9:0] Rx_cmd;											
reg [2:0] Current, Next;		
reg Flag_temp;
//build in module enable
reg linkBIM;

reg linkUSF;
reg linkSMZ;
reg linkTIZ;
reg linkGLO;
reg linkFSM;
reg linkUSH;

reg enable_uart7bit;
reg[2:0] uart_speed_set_7bit;
reg tx_start_f_7bit;
    reg linkFSS;
reg linkSMF;
reg linkTIF;
reg linkCMP;
reg linkUART;
reg linkLSL;
reg linkSPI;
reg linkTPF;
reg linkEWM;
reg linkLPT;
reg linkFWM;
reg linkTPZ;
reg linkGII;
reg linkSSZ;
reg linkUST;

reg[2:0] uart_speed_set;
reg tx_start_f;
    reg linkSSF;


assign BusB[17] =  linkUSF ? BusD[54] : 1'bz;
assign BusB[21] =  linkSMZ ? BusC[29] : 1'bz;
assign BusB[20] =  linkSMZ ? BusC[33] : 1'bz;
assign BusE[64] =  linkSMZ ? BusB[18] : 1'bz;
assign BusB[19] =  linkSMZ ? BusD[57] : 1'bz;
assign BusE[67] =  linkTIZ ? BusB[15] : 1'bz;
assign BusA[8] =  linkGLO ? BusA[3] : 1'bz;
assign BusB[15] =  linkGLO ? BusA[3] : 1'bz;
assign BusF[92] =  linkFSM ? BusC[36] : 1'bz;
assign BusC[42] =  linkFSM ? BusE[70] : 1'bz;
assign BusD[56] =  linkFSM ? BusA[4] : 1'bz;
assign BusC[40] =  linkFSM ? BusE[66] : 1'bz;
assign BusB[17] =  linkUSH ? compara_error : 1'bz;
assign rs232_rx7to7 =  linkUSH ? BusD[52] : 1'bz;
assign BusD[50] =  linkUSH ? rs232_tx7to7 : 1'bz;
assign BusC[36] =  linkFSS ? BusF[92] : 1'bz;
assign BusE[70] =  linkFSS ? BusC[42] : 1'bz;
assign BusD[56] =  linkFSS ? BusA[4] : 1'bz;
assign BusC[40] =  linkFSS ? BusE[66] : 1'bz;
assign BusB[21] =  linkSMF ? BusF[91] : 1'bz;
assign BusB[20] =  linkSMF ? BusF[83] : 1'bz;
assign BusF[87] =  linkSMF ? BusB[18] : 1'bz;
assign BusB[19] =  linkSMF ? BusF[85] : 1'bz;
assign BusF[77] =  linkTIF ? BusB[15] : 1'bz;
assign BusA[4] =  linkCMP ? BusB[16] : 1'bz;
assign BusB[17] =  linkCMP ? BusA[3] : 1'bz;
assign BusD[49] =  linkCMP ? BusB[16] : 1'bz;
assign BusE[64] =  linkLSL ? BusD[48] : 1'bz;
assign BusC[40] =  linkLSL ? BusA[4] : 1'bz;
assign BusC[29] =  linkSPI ? BusF[91] : 1'bz;
assign BusC[33] =  linkSPI ? BusF[83] : 1'bz;
assign BusF[87] =  linkSPI ? BusD[57] : 1'bz;
assign BusE[64] =  linkSPI ? BusF[85] : 1'bz;
assign BusB[15] =  linkTPF ? BusF[77] : 1'bz;
assign BusA[8] =  linkTPF ? BusF[77] : 1'bz;
assign BusA[2] =  linkEWM ? BusB[16] : 1'bz;
assign BusA[8] =  linkLPT ? BusA[3] : 1'bz;
assign BusB[15] =  linkLPT ? BusA[3] : 1'bz;
assign BusB[15] =  linkFWM ? BusC[36] : 1'bz;
assign BusA[8] =  linkFWM ? BusC[36] : 1'bz;
assign BusB[15] =  linkTPZ ? BusE[67] : 1'bz;
assign BusA[8] =  linkTPZ ? BusE[67] : 1'bz;
assign BusA[2] =  linkGII ? BusB[16] : 1'bz;
assign BusC[29] =  linkSSZ ? BusB[21] : 1'bz;
assign BusC[33] =  linkSSZ ? BusB[20] : 1'bz;
assign BusE[64] =  linkSSZ ? BusB[19] : 1'bz;
assign BusB[18] =  linkSSZ ? BusD[57] : 1'bz;
assign BusB[17] =  linkUST ? compara_error : 1'bz;
assign rs232_rx8to8 =  linkUST ? BusF[76] : 1'bz;
assign BusF[78] =  linkUST ? rs232_tx8to8 : 1'bz;
assign BusF[91] =  linkSSF ? BusB[21] : 1'bz;
assign BusF[83] =  linkSSF ? BusB[20] : 1'bz;
assign BusF[87] =  linkSSF ? BusB[19] : 1'bz;
assign BusB[18] =  linkSSF ? BusF[85] : 1'bz;


 
uart_top7to7		uart_top7to7(
						.clk(clk),
						.rst_n(tx_start_f_7bit),
						.rs232_rx(rs232_rx7to7),
						.rs232_tx(rs232_tx7to7),
						.data_ok(compara_error_uart7bit),
						.uart_ctl(uart_speed_set_7bit)
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
                      .tx_start(tx_start), 
                      .tx_data(tx_data), 
                      .tx_enable(bps_start_t), 
                      .tx_complete(tx_complete), 
                      .uart_tx(rs232_tx), 
                      .error(tx_error)
                      );
     
uart_instance		uart_instance1(
						.clk(clk),
						.rst_n(tx_start_f),
						.rs232_rx(rs232_rx8to8),
						.rs232_tx(rs232_tx8to8),
						.data_ok(compara_error),
						.uart_ctl(uart_speed_set)
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
			linkUSF <= 1'b0;
			linkSMZ <= 1'b0;
			linkTIZ <= 1'b0;
			linkGLO <= 1'b0;
			linkFSM <= 1'b0;
			linkUSH <= 1'b0;
			linkFSS <= 1'b0;
			linkSMF <= 1'b0;
			linkTIF <= 1'b0;
			linkCMP <= 1'b0;
			linkLSL <= 1'b0;
			linkSPI <= 1'b0;
			linkTPF <= 1'b0;
			linkEWM <= 1'b0;
			linkLPT <= 1'b0;
			linkFWM <= 1'b0;
			linkTPZ <= 1'b0;
			linkGII <= 1'b0;
			linkSSZ <= 1'b0;
			linkUST <= 1'b0;
			linkSSF <= 1'b0;

    ///////////////////////////////////////////////
    led <= 1'b0; // for debug led
    linkBIM <= 1'b1;
  end
  else
  begin
    case(Rx_cmd)
    ///////////////////add case here/////////////
      			
      {U,S, F}: //{C,M,D}
      begin
        linkUSF <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,M, Z}: //{C,M,D}
      begin
        linkSMZ <= 1'b1;

        led <= 1'b1;
      end
      			
      {T,I, Z}: //{C,M,D}
      begin
        linkTIZ <= 1'b1;

        led <= 1'b1;
      end
      			
      {G,L, O}: //{C,M,D}
      begin
        linkGLO <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,S, M}: //{C,M,D}
      begin
        linkFSM <= 1'b1;

        led <= 1'b1;
      end
      
      {U,S, H}: //{C,M,D}
      begin
        linkUSH <= 1'b1;
			 
          uart_speed_set_7bit <= 3'd4;
          tx_start_f_7bit <= 1'b1;
      

        led <= 1'b1;
      end
      			
      {F,S, S}: //{C,M,D}
      begin
        linkFSS <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,M, F}: //{C,M,D}
      begin
        linkSMF <= 1'b1;

        led <= 1'b1;
      end
      			
      {T,I, F}: //{C,M,D}
      begin
        linkTIF <= 1'b1;

        led <= 1'b1;
      end
      			
      {C,M, P}: //{C,M,D}
      begin
        linkCMP <= 1'b1;

        led <= 1'b1;
      end
      			
      {L,S, L}: //{C,M,D}
      begin
        linkLSL <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,P, I}: //{C,M,D}
      begin
        linkSPI <= 1'b1;

        led <= 1'b1;
      end
      			
      {T,P, F}: //{C,M,D}
      begin
        linkTPF <= 1'b1;

        led <= 1'b1;
      end
      			
      {E,W, M}: //{C,M,D}
      begin
        linkEWM <= 1'b1;

        led <= 1'b1;
      end
      			
      {L,P, T}: //{C,M,D}
      begin
        linkLPT <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,W, M}: //{C,M,D}
      begin
        linkFWM <= 1'b1;

        led <= 1'b1;
      end
      			
      {T,P, Z}: //{C,M,D}
      begin
        linkTPZ <= 1'b1;

        led <= 1'b1;
      end
      			
      {G,I, I}: //{C,M,D}
      begin
        linkGII <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,S, Z}: //{C,M,D}
      begin
        linkSSZ <= 1'b1;

        led <= 1'b1;
      end
      
      {U,S, T}: //{C,M,D}
      begin
        linkUST <= 1'b1;
			 
          uart_speed_set <= 3'd4;
          tx_start_f <= 1'b1;
      

        led <= 1'b1;
      end
      			
      {S,S, F}: //{C,M,D}
      begin
        linkSSF <= 1'b1;

        led <= 1'b1;
      end
      
    /////////////////////////////////////////////

      {R,S,T}: //RESET
         begin
           			linkUSF <= 1'b0;
			linkSMZ <= 1'b0;
			linkTIZ <= 1'b0;
			linkGLO <= 1'b0;
			linkFSM <= 1'b0;
			
    enable_uart7bit <= 1'b0;
    uart_speed_set_7bit<=3'd4;
    tx_start_f_7bit <= 1'b0;
    
			linkUSH <= 1'b0;
			linkFSS <= 1'b0;
			linkSMF <= 1'b0;
			linkTIF <= 1'b0;
			linkCMP <= 1'b0;
			linkLSL <= 1'b0;
			linkSPI <= 1'b0;
			linkTPF <= 1'b0;
			linkEWM <= 1'b0;
			linkLPT <= 1'b0;
			linkFWM <= 1'b0;
			linkTPZ <= 1'b0;
			linkGII <= 1'b0;
			linkSSZ <= 1'b0;
			
    uart_speed_set<=3'd4;
    tx_start_f <= 1'b0;
    
			linkUST <= 1'b0;
			linkSSF <= 1'b0;

            led <= 1'b0;
            linkBIM <= 1'b1;
        end

         default:
         begin
          			linkUSF <= 1'b0;
			linkSMZ <= 1'b0;
			linkTIZ <= 1'b0;
			linkGLO <= 1'b0;
			linkFSM <= 1'b0;
			
    enable_uart7bit <= 1'b0;
    uart_speed_set_7bit<=3'd4;
    enable_uart7bit <= 1'b0;
    
			linkUSH <= 1'b0;
			linkFSS <= 1'b0;
			linkSMF <= 1'b0;
			linkTIF <= 1'b0;
			linkCMP <= 1'b0;
			linkLSL <= 1'b0;
			linkSPI <= 1'b0;
			linkTPF <= 1'b0;
			linkEWM <= 1'b0;
			linkLPT <= 1'b0;
			linkFWM <= 1'b0;
			linkTPZ <= 1'b0;
			linkGII <= 1'b0;
			linkSSZ <= 1'b0;
			
    uart_speed_set<=3'd4;
    tx_start_f <= 1'b0;
    
			linkUST <= 1'b0;
			linkSSF <= 1'b0;

          led <= 1'b0;
          linkBIM <= 1'b1;
      end
    endcase
  end
end


/////////////////////////////////////////////////////////////

endmodule
