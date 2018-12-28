//caution do not edit this file manually it is a template in tenjin format
`define  Buff_size 32
////////////////////////////////////////////
module top(clk,rst_n,rs232_rx, BusA,BusB,BusC, led);

///////////////////////////////////////////
input clk;	// 50MHz
input rst_n;	//reset, neg edge.
input rs232_rx;	// RS232 rec
//output rs232_tx;	//	RS232 transfer
/////////////////////////////////////////

inout [21:2] BusA;
inout [42:42] BusB;
inout [91:54] BusC;


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

 
wire pwm_input;
wire tx_start;	
wire[7:0] tx_data;
wire rs232_tx;
          



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

reg linkSBS;
reg linkCTP;
reg linkPMS;
reg linkUART;
reg linkSCT;
reg linkPPI;
reg linkGLO;
 
reg enable;
reg capture_rst;
reg capture_tx_rst;
    reg linkSMS;
reg linkSSP;
reg linkFRS;
reg linkSPI;
reg linkPMA;
reg linkSDC;
reg linkCPP;
reg linkCTM;
reg linkSBM;
reg linkCMP;
reg linkPDN;


assign BusC[54] =  linkPDN ? 0 : 1;
assign BusC[91] =  linkSBS ? BusA[21] : 1'bz;
assign BusC[83] =  linkSBS ? BusA[20] : 1'bz;
assign BusA[18] =  linkSBS ? BusC[87] : 1'bz;
assign BusC[85] =  linkSBS ? BusA[19] : 1'bz;
assign BusA[15] =  linkCTP ? BusA[2] : 1'bz;
assign BusA[8] =  linkCTP ? BusA[2] : 1'bz;
assign BusC[84] =  linkPMS ? BusA[16] : 1'bz;
assign BusA[15] =  linkSCT ? BusC[81] : 1'bz;
assign BusA[8] =  linkSCT ? BusC[81] : 1'bz;
assign BusC[76] =  linkPPI ? BusA[16] : 1'bz;
assign BusC[84] =  linkPPI ? BusA[16] : 1'bz;
assign pwm_input =  linkGLO ? BusC[86] : 1'bz;
assign BusA[7] =  linkGLO ? rs232_tx : 1'bz;
assign BusA[15] =  linkSMS ? BusC[81] : 1'bz;
assign BusA[8] =  linkSMS ? BusC[81] : 1'bz;
assign BusC[76] =  linkSMS ? BusA[16] : 1'bz;
assign BusA[15] =  linkSSP ? BusC[81] : 1'bz;
assign BusA[8] =  linkSSP ? BusC[81] : 1'bz;
assign BusC[71] =  linkFRS ? BusC[67] : 1'bz;
assign BusC[86] =  linkFRS ? BusC[81] : 1'bz;
assign BusC[61] =  linkFRS ? BusC[58] : 1'bz;
assign BusC[56] =  linkFRS ? BusC[57] : 1'bz;
assign BusC[71] =  linkSPI ? BusC[67] : 1'bz;
assign BusC[86] =  linkSPI ? BusC[81] : 1'bz;
assign BusC[61] =  linkSPI ? BusC[58] : 1'bz;
assign BusC[56] =  linkSPI ? BusC[57] : 1'bz;
assign BusC[76] =  linkPMA ? BusA[16] : 1'bz;
assign BusC[84] =  linkPMA ? BusA[16] : 1'bz;
assign BusA[15] =  linkSDC ? BusC[85] : 1'bz;
assign BusA[8] =  linkSDC ? BusC[85] : 1'bz;
assign BusA[17] =  linkCPP ? BusA[2] : 1'bz;
assign BusC[91] =  linkCPP ? BusA[16] : 1'bz;
assign BusA[15] =  linkCTM ? BusB[42] : 1'bz;
assign BusA[8] =  linkCTM ? BusB[42] : 1'bz;
assign BusA[21] =  linkSBM ? BusC[91] : 1'bz;
assign BusA[20] =  linkSBM ? BusC[83] : 1'bz;
assign BusC[87] =  linkSBM ? BusA[18] : 1'bz;
assign BusA[19] =  linkSBM ? BusC[85] : 1'bz;
assign BusC[62] =  linkCMP ? BusA[16] : 1'bz;


 
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
     
pwm_capture		 pwm_capture_instance(
							.pwm_input(pwm_input),
							.clk(clk),
							.rst_n(capture_rst),
							.enable(enable),
						   .tx_start(tx_start),
							.tx_data(tx_data),
							.tx_complete(tx_complete),
							.capture_tx_rst(capture_tx_rst),
							.bps_start_t(bps_start_t)
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
			linkSBS <= 1'b0;
			linkCTP <= 1'b0;
			linkPMS <= 1'b0;
			linkSCT <= 1'b0;
			linkPPI <= 1'b0;
			linkGLO <= 1'b0;
			linkSMS <= 1'b0;
			linkSSP <= 1'b0;
			linkFRS <= 1'b0;
			linkSPI <= 1'b0;
			linkPMA <= 1'b0;
			linkSDC <= 1'b0;
			linkCPP <= 1'b0;
			linkCTM <= 1'b0;
			linkSBM <= 1'b0;
			linkCMP <= 1'b0;
			linkPDN <= 1'b0;

    ///////////////////////////////////////////////
    led <= 1'b0; // for debug led
    linkBIM <= 1'b1;
  end
  else
  begin
    case(Rx_cmd)
    ///////////////////add case here/////////////
      			
      {S,B, S}: //{C,M,D}
      begin
        linkSBS <= 1'b1;

        led <= 1'b1;
      end
      			
      {C,T, P}: //{C,M,D}
      begin
        linkCTP <= 1'b1;

        led <= 1'b1;
      end
      			
      {P,M, S}: //{C,M,D}
      begin
        linkPMS <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,C, T}: //{C,M,D}
      begin
        linkSCT <= 1'b1;

        led <= 1'b1;
      end
      			
      {P,P, I}: //{C,M,D}
      begin
        linkPPI <= 1'b1;

        led <= 1'b1;
      end
      
      {G,L, O}: //{C,M,D}
      begin
        linkGLO <= 1'b1; 
	enable <= 1'b1;
    capture_rst <= 1'b1;
    capture_tx_rst <= 1'b1;
	

        led <= 1'b1;
      end
      			
      {S,M, S}: //{C,M,D}
      begin
        linkSMS <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,S, P}: //{C,M,D}
      begin
        linkSSP <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,R, S}: //{C,M,D}
      begin
        linkFRS <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,P, I}: //{C,M,D}
      begin
        linkSPI <= 1'b1;

        led <= 1'b1;
      end
      			
      {P,M, A}: //{C,M,D}
      begin
        linkPMA <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,D, C}: //{C,M,D}
      begin
        linkSDC <= 1'b1;

        led <= 1'b1;
      end
      			
      {C,P, P}: //{C,M,D}
      begin
        linkCPP <= 1'b1;

        led <= 1'b1;
      end
      			
      {C,T, M}: //{C,M,D}
      begin
        linkCTM <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,B, M}: //{C,M,D}
      begin
        linkSBM <= 1'b1;

        led <= 1'b1;
      end
      			
      {C,M, P}: //{C,M,D}
      begin
        linkCMP <= 1'b1;

        led <= 1'b1;
      end
		
	   {P,U, P}: //{C,M,D}
      begin
        linkPDN <= 1'b0;
		  led <= 1'b0;
		end
	   {P,D, N}: //{C,M,D}
      begin
        linkPDN <= 1'b1;  
		  led <= 1'b1;       end
    /////////////////////////////////////////////

      {R,S,T}: //RESET
         begin
           			linkSBS <= 1'b0;
			linkCTP <= 1'b0;
			linkPMS <= 1'b0;
			linkSCT <= 1'b0;
			linkPPI <= 1'b0;
			
    enable <= 1'b0;
    capture_rst <= 1'b0;
    capture_tx_rst <= 1'b0;
    
			linkGLO <= 1'b0;
			linkSMS <= 1'b0;
			linkSSP <= 1'b0;
			linkFRS <= 1'b0;
			linkSPI <= 1'b0;
			linkPMA <= 1'b0;
			linkSDC <= 1'b0;
			linkCPP <= 1'b0;
			linkCTM <= 1'b0;
			linkSBM <= 1'b0;
			linkCMP <= 1'b0;
         linkCMP <= 1'b0;
            led <= 1'b0;
            linkBIM <= 1'b1;
        end

         default:
         begin
          			linkSBS <= 1'b0;
			linkCTP <= 1'b0;
			linkPMS <= 1'b0;
			linkSCT <= 1'b0;
			linkPPI <= 1'b0;
			
    enable <= 1'b0;
    capture_rst <= 1'b0;
    capture_tx_rst <= 1'b0;
    
			linkGLO <= 1'b0;
			linkSMS <= 1'b0;
			linkSSP <= 1'b0;
			linkFRS <= 1'b0;
			linkSPI <= 1'b0;
			linkPMA <= 1'b0;
			linkSDC <= 1'b0;
			linkCPP <= 1'b0;
			linkCTM <= 1'b0;
			linkSBM <= 1'b0;
			linkCMP <= 1'b0;

          led <= 1'b0;
          linkBIM <= 1'b1;
      end
    endcase
  end
end


/////////////////////////////////////////////////////////////

endmodule
