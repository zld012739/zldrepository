//caution do not edit this file manually it is a template in tenjin format
`define  Buff_size 32
////////////////////////////////////////////
module top(clk,rst_n,rs232_rx, BusA,BusB,BusC,BusD,BusE, led);

///////////////////////////////////////////
input clk;	// 50MHz
input rst_n;	//reset, neg edge.
input rs232_rx;	// RS232 rec
//output rs232_tx;	//	RS232 transfer
/////////////////////////////////////////

inout [17:2] BusA;
inout [40:29] BusB;
inout [52:50] BusC;
inout [64:64] BusD;
inout [97:83] BusE;


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
    
wire sm_sck;
wire sm_mosi;
wire sm_miso;
wire sm_cs_n;
wire spi_receive_status;
          
wire ss_sck_b2b;
wire ss_mosi_b2b;
wire ss_miso_b2b;
wire ss_ssel_b2b;
wire spi_slave_result_b2b;
          



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

reg linkFDC;
reg linkGLO;
reg linkFLP;
reg linkUSH;

reg enable_uart7bit;
reg[2:0] uart_speed_set_7bit;
reg tx_start_f_7bit;
    reg linkFSP;
reg linkUST;

reg[2:0] uart_speed_set;
reg tx_start_f;
    reg linkSIO;

reg spi_tx_en;
reg spi_rx_en;
reg spi_rst;
reg mode_select;
    reg linkCMP;
reg linkFCP;
reg linkPMS;
reg linkUART;
reg linkSHL;
reg linkSPS;

reg spi_slave_rst_b2b;
    reg linkPMH;
reg linkEWM;
reg linkTRG;
reg linkFRS;
reg linkFIC;
reg linkFOC;
reg linkTSI;
reg linkGII;
reg linkPWT;
reg linkFPT;


assign BusD[64] =  linkFDC ? BusA[15] : 1'bz;
assign BusA[8] =  linkGLO ? BusA[5] : 1'bz;
assign BusA[15] =  linkGLO ? BusA[5] : 1'bz;
assign BusA[8] =  linkFLP ? BusA[2] : 1'bz;
assign BusA[15] =  linkFLP ? BusA[2] : 1'bz;
assign BusA[17] =  linkUSH ? compara_error : 1'bz;
assign rs232_rx7to7 =  linkUSH ? BusC[52] : 1'bz;
assign BusC[50] =  linkUSH ? rs232_tx7to7 : 1'bz;
assign BusA[8] =  linkFSP ? BusA[5] : 1'bz;
assign BusA[15] =  linkFSP ? BusA[5] : 1'bz;
assign BusA[17] =  linkUST ? compara_error : 1'bz;
assign rs232_rx8to8 =  linkUST ? BusE[97] : 1'bz;
assign BusE[95] =  linkUST ? rs232_tx8to8 : 1'bz;
assign BusE[83] =  linkSIO ? sm_cs_n : 1'bz;
assign sm_miso =  linkSIO ? BusE[85] : 1'bz;
assign BusE[87] =  linkSIO ? sm_mosi : 1'bz;
assign BusE[91] =  linkSIO ? sm_sck : 1'bz;
assign BusC[50] =  linkSIO ? spi_receive_status : 1'bz;
assign BusB[40] =  linkCMP ? BusA[16] : 1'bz;
assign BusA[17] =  linkCMP ? BusA[3] : 1'bz;
assign BusA[8] =  linkFCP ? BusA[3] : 1'bz;
assign BusA[15] =  linkFCP ? BusA[3] : 1'bz;
assign BusA[4] =  linkPMS ? BusA[16] : 1'bz;
assign BusA[17] =  linkSHL ? BusA[3] : 1'bz;
assign BusC[50] =  linkSPS ? spi_slave_result_b2b : 1'bz;
assign BusE[87] =  linkSPS ? ss_miso_b2b : 1'bz;
assign ss_mosi_b2b =  linkSPS ? BusE[85] : 1'bz;
assign ss_sck_b2b =  linkSPS ? BusE[91] : 1'bz;
assign ss_ssel_b2b =  linkSPS ? BusE[83] : 1'bz;
assign BusA[4] =  linkPMH ? BusA[16] : 1'bz;
assign BusA[4] =  linkEWM ? BusA[16] : 1'bz;
assign BusA[8] =  linkTRG ? BusA[5] : 1'bz;
assign BusA[15] =  linkTRG ? BusA[5] : 1'bz;
assign BusB[34] =  linkFRS ? BusE[91] : 1'bz;
assign BusB[29] =  linkFRS ? BusE[83] : 1'bz;
assign BusB[33] =  linkFRS ? BusE[85] : 1'bz;
assign BusE[87] =  linkFRS ? BusB[30] : 1'bz;
assign BusE[89] =  linkFIC ? BusA[16] : 1'bz;
assign BusA[8] =  linkFOC ? BusC[51] : 1'bz;
assign BusA[15] =  linkFOC ? BusC[51] : 1'bz;
assign BusA[8] =  linkTSI ? BusA[3] : 1'bz;
assign BusA[15] =  linkTSI ? BusA[3] : 1'bz;
assign BusA[4] =  linkGII ? BusA[16] : 1'bz;
assign BusE[95] =  linkPWT ? BusA[15] : 1'bz;
assign BusA[8] =  linkFPT ? BusA[3] : 1'bz;
assign BusA[15] =  linkFPT ? BusA[3] : 1'bz;


 
uart_top7to7		uart_top7to7(
						.clk(clk),
						.rst_n(tx_start_f_7bit),
						.rs232_rx(rs232_rx7to7),
						.rs232_tx(rs232_tx7to7),
						.data_ok(compara_error_uart7bit),
						.uart_ctl(uart_speed_set_7bit)
						); 
     
uart_instance		uart_instance1(
						.clk(clk),
						.rst_n(tx_start_f),
						.rs232_rx(rs232_rx8to8),
						.rs232_tx(rs232_tx8to8),
						.data_ok(compara_error),
						.uart_ctl(uart_speed_set)
						); 
    
spi_ctrl      spi_ctrl_instance(
							.clk(clk),
							.rst_n(spi_rst),
							.sck(sm_sck),
							.mosi(sm_mosi),
							.miso(sm_miso),
							.cs_n(sm_cs_n),
							.spi_tx_en(spi_tx_en),
							.spi_rx_en(spi_rx_en),
							.mode_select(mode_select),
							.receive_status(spi_receive_status)
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
    
spi_slave_b2b		spi_slave_b2b_instance(
							.clk(clk),
							.sck(ss_sck_b2b),
							.mosi(ss_mosi_b2b),
							.miso(ss_miso_b2b),
							.ssel(ss_ssel_b2b),
							.rst_n(spi_slave_rst_b2b),
							.recived_status(spi_slave_result_b2b)
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
			linkFDC <= 1'b0;
			linkGLO <= 1'b0;
			linkFLP <= 1'b0;
			linkUSH <= 1'b0;
			linkFSP <= 1'b0;
			linkUST <= 1'b0;
			linkSIO <= 1'b0;
			linkCMP <= 1'b0;
			linkFCP <= 1'b0;
			linkPMS <= 1'b0;
			linkSHL <= 1'b0;
			linkSPS <= 1'b0;
			linkPMH <= 1'b0;
			linkEWM <= 1'b0;
			linkTRG <= 1'b0;
			linkFRS <= 1'b0;
			linkFIC <= 1'b0;
			linkFOC <= 1'b0;
			linkTSI <= 1'b0;
			linkGII <= 1'b0;
			linkPWT <= 1'b0;
			linkFPT <= 1'b0;

    ///////////////////////////////////////////////
    led <= 1'b0; // for debug led
    linkBIM <= 1'b1;
  end
  else
  begin
    case(Rx_cmd)
    ///////////////////add case here/////////////
      			
      {F,D, C}: //{C,M,D}
      begin
        linkFDC <= 1'b1;

        led <= 1'b1;
      end
      			
      {G,L, O}: //{C,M,D}
      begin
        linkGLO <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,L, P}: //{C,M,D}
      begin
        linkFLP <= 1'b1;

        led <= 1'b1;
      end
      
      {U,S, H}: //{C,M,D}
      begin
        linkUSH <= 1'b1;
			 
          uart_speed_set_7bit <= 3'd4;
          tx_start_f_7bit <= 1'b1;
      

        led <= 1'b1;
      end
      			
      {F,S, P}: //{C,M,D}
      begin
        linkFSP <= 1'b1;

        led <= 1'b1;
      end
      
      {U,S, T}: //{C,M,D}
      begin
        linkUST <= 1'b1;
			 
          uart_speed_set <= 3'd4;
          tx_start_f <= 1'b1;
      

        led <= 1'b1;
      end
      
      {S,I, O}: //{C,M,D}
      begin
        linkSIO <= 1'b1;
			 
        spi_rst <= 1'b1;
        spi_tx_en <= 1'b1;
        spi_rx_en <= 1'b1;
        mode_select <= 1'b0;
        

        led <= 1'b1;
      end
      			
      {C,M, P}: //{C,M,D}
      begin
        linkCMP <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,C, P}: //{C,M,D}
      begin
        linkFCP <= 1'b1;

        led <= 1'b1;
      end
      			
      {P,M, S}: //{C,M,D}
      begin
        linkPMS <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,H, L}: //{C,M,D}
      begin
        linkSHL <= 1'b1;

        led <= 1'b1;
      end
      
      {S,P, S}: //{C,M,D}
      begin
        linkSPS <= 1'b1;
			 
        spi_slave_rst_b2b <= 1'b1;
        

        led <= 1'b1;
      end
      			
      {P,M, H}: //{C,M,D}
      begin
        linkPMH <= 1'b1;

        led <= 1'b1;
      end
      			
      {E,W, M}: //{C,M,D}
      begin
        linkEWM <= 1'b1;

        led <= 1'b1;
      end
      			
      {T,R, G}: //{C,M,D}
      begin
        linkTRG <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,R, S}: //{C,M,D}
      begin
        linkFRS <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,I, C}: //{C,M,D}
      begin
        linkFIC <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,O, C}: //{C,M,D}
      begin
        linkFOC <= 1'b1;

        led <= 1'b1;
      end
      			
      {T,S, I}: //{C,M,D}
      begin
        linkTSI <= 1'b1;

        led <= 1'b1;
      end
      			
      {G,I, I}: //{C,M,D}
      begin
        linkGII <= 1'b1;

        led <= 1'b1;
      end
      			
      {P,W, T}: //{C,M,D}
      begin
        linkPWT <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,P, T}: //{C,M,D}
      begin
        linkFPT <= 1'b1;

        led <= 1'b1;
      end
      
    /////////////////////////////////////////////

      {R,S,T}: //RESET
         begin
           			linkFDC <= 1'b0;
			linkGLO <= 1'b0;
			linkFLP <= 1'b0;
			
    enable_uart7bit <= 1'b0;
    uart_speed_set_7bit<=3'd4;
    tx_start_f_7bit <= 1'b0;
    
			linkUSH <= 1'b0;
			linkFSP <= 1'b0;
			
    uart_speed_set<=3'd4;
    tx_start_f <= 1'b0;
    
			linkUST <= 1'b0;
			
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select <= 1'b0;
        
			linkSIO <= 1'b0;
			linkCMP <= 1'b0;
			linkFCP <= 1'b0;
			linkPMS <= 1'b0;
			linkSHL <= 1'b0;
			
        spi_slave_rst_b2b <= 1'b0;
        
			linkSPS <= 1'b0;
			linkPMH <= 1'b0;
			linkEWM <= 1'b0;
			linkTRG <= 1'b0;
			linkFRS <= 1'b0;
			linkFIC <= 1'b0;
			linkFOC <= 1'b0;
			linkTSI <= 1'b0;
			linkGII <= 1'b0;
			linkPWT <= 1'b0;
			linkFPT <= 1'b0;

            led <= 1'b0;
            linkBIM <= 1'b1;
        end

         default:
         begin
          			linkFDC <= 1'b0;
			linkGLO <= 1'b0;
			linkFLP <= 1'b0;
			
    enable_uart7bit <= 1'b0;
    uart_speed_set_7bit<=3'd4;
    enable_uart7bit <= 1'b0;
    
			linkUSH <= 1'b0;
			linkFSP <= 1'b0;
			
    uart_speed_set<=3'd4;
    tx_start_f <= 1'b0;
    
			linkUST <= 1'b0;
			
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select <= 1'b0;
        
			linkSIO <= 1'b0;
			linkCMP <= 1'b0;
			linkFCP <= 1'b0;
			linkPMS <= 1'b0;
			linkSHL <= 1'b0;
			
        spi_slave_rst_b2b <= 1'b0;
        
			linkSPS <= 1'b0;
			linkPMH <= 1'b0;
			linkEWM <= 1'b0;
			linkTRG <= 1'b0;
			linkFRS <= 1'b0;
			linkFIC <= 1'b0;
			linkFOC <= 1'b0;
			linkTSI <= 1'b0;
			linkGII <= 1'b0;
			linkPWT <= 1'b0;
			linkFPT <= 1'b0;

          led <= 1'b0;
          linkBIM <= 1'b1;
      end
    endcase
  end
end


/////////////////////////////////////////////////////////////

endmodule
