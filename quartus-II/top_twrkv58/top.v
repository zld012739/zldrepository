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

inout [17:3] BusA;
inout [50:50] BusB;
inout [62:61] BusC;
inout [82:76] BusD;
inout [99:99] BusE;


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
     
wire pha_out;
wire phb_out;
wire home_out;
wire index_out; 
          
wire sm_sck;
wire sm_mosi;
wire sm_miso;
wire sm_cs_n;
wire spi_receive_status;
          



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
reg linkRES;
reg linkUSL;

reg enable_uart7bit;
reg[2:0] uart_speed_set_7bit;
reg tx_start_f_7bit;
    reg linkFQD;
reg enable_enc;
reg linkUSH;
reg linkFSP;
reg linkCMP;
reg linkFCP;
reg linkUART;
reg linkSHL;
reg linkWDG;
reg linkPMH;
reg linkENC;
reg linkGPI;
reg linkEWM;
reg linkLPT;
reg linkFIC;
reg linkFOC;
reg linkXBR;
reg linkFTM;
reg linkGII;
reg linkFPT;
reg linkMCG;
reg linkSSI;

reg spi_tx_en;
reg spi_rx_en;
reg spi_rst;
reg mode_select;
    reg linkPFT;
reg linkPWM;


assign BusB[50] =  linkFDC ? BusA[15] : 1'bz;
assign BusA[15] =  linkGLO ? BusB[50] : 1'bz;
assign BusA[8] =  linkGLO ? BusB[50] : 1'bz;
assign BusA[3] =  linkRES ? BusA[16] : 1'bz;
assign BusB[50] =  linkUSL ? compara_error_uart7bit : 1'bz;
assign rs232_rx7to7 =  linkUSL ? BusC[61] : 1'bz;
assign BusC[62] =  linkUSL ? rs232_tx7to7 : 1'bz;
assign BusC[61] =  linkFQD ? pha_out : 1'bz;
assign BusC[62] =  linkFQD ? phb_out : 1'bz;
assign BusB[50] =  linkUSH ? compara_error_uart7bit : 1'bz;
assign rs232_rx7to7 =  linkUSH ? BusC[61] : 1'bz;
assign BusC[62] =  linkUSH ? rs232_tx7to7 : 1'bz;
assign BusA[15] =  linkFSP ? BusB[50] : 1'bz;
assign BusA[8] =  linkFSP ? BusB[50] : 1'bz;
assign BusA[5] =  linkCMP ? BusA[16] : 1'bz;
assign BusA[17] =  linkCMP ? BusB[50] : 1'bz;
assign BusA[15] =  linkFCP ? BusB[50] : 1'bz;
assign BusA[8] =  linkFCP ? BusB[50] : 1'bz;
assign BusA[17] =  linkSHL ? BusB[50] : 1'bz;
assign BusA[4] =  linkWDG ? BusA[16] : 1'bz;
assign BusA[4] =  linkPMH ? BusA[16] : 1'bz;
assign BusB[50] =  linkENC ? index_out : 1'bz;
assign BusC[62] =  linkENC ? pha_out : 1'bz;
assign BusC[61] =  linkENC ? phb_out : 1'bz;
assign BusA[4] =  linkGPI ? BusA[16] : 1'bz;
assign BusA[4] =  linkEWM ? BusA[16] : 1'bz;
assign BusA[17] =  linkLPT ? BusB[50] : 1'bz;
assign BusB[50] =  linkFIC ? BusA[15] : 1'bz;
assign BusA[15] =  linkFOC ? BusB[50] : 1'bz;
assign BusA[8] =  linkFOC ? BusB[50] : 1'bz;
assign BusA[4] =  linkXBR ? BusA[16] : 1'bz;
assign BusA[15] =  linkFTM ? BusA[14] : 1'bz;
assign BusA[8] =  linkFTM ? BusA[14] : 1'bz;
assign BusA[17] =  linkGII ? BusB[50] : 1'bz;
assign BusA[14] =  linkGII ? BusA[16] : 1'bz;
assign BusA[15] =  linkFPT ? BusB[50] : 1'bz;
assign BusA[8] =  linkFPT ? BusB[50] : 1'bz;
assign BusA[15] =  linkMCG ? BusB[50] : 1'bz;
assign BusA[8] =  linkMCG ? BusB[50] : 1'bz;
assign BusD[78] =  linkSSI ? sm_cs_n : 1'bz;
assign sm_miso =  linkSSI ? BusD[76] : 1'bz;
assign BusD[77] =  linkSSI ? sm_mosi : 1'bz;
assign BusD[82] =  linkSSI ? sm_sck : 1'bz;
assign BusA[15] =  linkPFT ? BusE[99] : 1'bz;
assign BusA[8] =  linkPFT ? BusE[99] : 1'bz;
assign BusA[15] =  linkPWM ? BusE[99] : 1'bz;
assign BusA[8] =  linkPWM ? BusE[99] : 1'bz;


 
uart_top7to7		uart_top7to7(
						.clk(clk),
						.rst_n(tx_start_f_7bit),
						.rs232_rx(rs232_rx7to7),
						.rs232_tx(rs232_tx7to7),
						.data_ok(compara_error_uart7bit),
						.uart_ctl(uart_speed_set_7bit)
						); 
     
enc  enc( .rst_n(rst_n),
          .freq_clk(clk),
          .enable(enable_enc),
			    .pha(pha_out), 
			    .phb(phb_out), 
			    .home(home_out), 
			    .index(index_out)
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
			linkRES <= 1'b0;
			linkUSL <= 1'b0;
			linkFQD <= 1'b0;
			linkUSH <= 1'b0;
			linkFSP <= 1'b0;
			linkCMP <= 1'b0;
			linkFCP <= 1'b0;
			linkSHL <= 1'b0;
			linkWDG <= 1'b0;
			linkPMH <= 1'b0;
			linkENC <= 1'b0;
			linkGPI <= 1'b0;
			linkEWM <= 1'b0;
			linkLPT <= 1'b0;
			linkFIC <= 1'b0;
			linkFOC <= 1'b0;
			linkXBR <= 1'b0;
			linkFTM <= 1'b0;
			linkGII <= 1'b0;
			linkFPT <= 1'b0;
			linkMCG <= 1'b0;
			linkSSI <= 1'b0;
			linkPFT <= 1'b0;
			linkPWM <= 1'b0;

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
      			
      {R,E, S}: //{C,M,D}
      begin
        linkRES <= 1'b1;

        led <= 1'b1;
      end
      
      {U,S, L}: //{C,M,D}
      begin
        linkUSL <= 1'b1;
			 
          uart_speed_set_7bit <= 3'd0;
          tx_start_f_7bit <= 1'b1;
      

        led <= 1'b1;
      end
      
      {F,Q, D}: //{C,M,D}
      begin
        linkFQD <= 1'b1;
			 enable_enc <= 1'b1;

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
      			
      {S,H, L}: //{C,M,D}
      begin
        linkSHL <= 1'b1;

        led <= 1'b1;
      end
      			
      {W,D, G}: //{C,M,D}
      begin
        linkWDG <= 1'b1;

        led <= 1'b1;
      end
      			
      {P,M, H}: //{C,M,D}
      begin
        linkPMH <= 1'b1;

        led <= 1'b1;
      end
      
      {E,N, C}: //{C,M,D}
      begin
        linkENC <= 1'b1;
			 enable_enc <= 1'b1;

        led <= 1'b1;
      end
      			
      {G,P, I}: //{C,M,D}
      begin
        linkGPI <= 1'b1;

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
      			
      {X,B, R}: //{C,M,D}
      begin
        linkXBR <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,T, M}: //{C,M,D}
      begin
        linkFTM <= 1'b1;

        led <= 1'b1;
      end
      			
      {G,I, I}: //{C,M,D}
      begin
        linkGII <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,P, T}: //{C,M,D}
      begin
        linkFPT <= 1'b1;

        led <= 1'b1;
      end
      			
      {M,C, G}: //{C,M,D}
      begin
        linkMCG <= 1'b1;

        led <= 1'b1;
      end
      
      {S,S, I}: //{C,M,D}
      begin
        linkSSI <= 1'b1;
			 
        spi_rst <= 1'b1;
        spi_tx_en <= 1'b1;
        spi_rx_en <= 1'b1;
        mode_select <= 1'b0;
        

        led <= 1'b1;
      end
      			
      {P,F, T}: //{C,M,D}
      begin
        linkPFT <= 1'b1;

        led <= 1'b1;
      end
      			
      {P,W, M}: //{C,M,D}
      begin
        linkPWM <= 1'b1;

        led <= 1'b1;
      end
      
    /////////////////////////////////////////////

      {R,S,T}: //RESET
         begin
           			linkFDC <= 1'b0;
			linkGLO <= 1'b0;
			linkRES <= 1'b0;
			
    enable_uart7bit <= 1'b0;
    uart_speed_set_7bit<=3'd4;
    tx_start_f_7bit <= 1'b0;
    
			linkUSL <= 1'b0;
			enable_enc <= 1'b0;
			linkFQD <= 1'b0;
			linkUSH <= 1'b0;
			linkFSP <= 1'b0;
			linkCMP <= 1'b0;
			linkFCP <= 1'b0;
			linkSHL <= 1'b0;
			linkWDG <= 1'b0;
			linkPMH <= 1'b0;
			linkENC <= 1'b0;
			linkGPI <= 1'b0;
			linkEWM <= 1'b0;
			linkLPT <= 1'b0;
			linkFIC <= 1'b0;
			linkFOC <= 1'b0;
			linkXBR <= 1'b0;
			linkFTM <= 1'b0;
			linkGII <= 1'b0;
			linkFPT <= 1'b0;
			linkMCG <= 1'b0;
			
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select <= 1'b0;
        
			linkSSI <= 1'b0;
			linkPFT <= 1'b0;
			linkPWM <= 1'b0;

            led <= 1'b0;
            linkBIM <= 1'b1;
        end

         default:
         begin
          			linkFDC <= 1'b0;
			linkGLO <= 1'b0;
			linkRES <= 1'b0;
			
    enable_uart7bit <= 1'b0;
    uart_speed_set_7bit<=3'd4;
    enable_uart7bit <= 1'b0;
    
			linkUSL <= 1'b0;
			enable_enc <= 1'b0;
			linkFQD <= 1'b0;
			linkUSH <= 1'b0;
			linkFSP <= 1'b0;
			linkCMP <= 1'b0;
			linkFCP <= 1'b0;
			linkSHL <= 1'b0;
			linkWDG <= 1'b0;
			linkPMH <= 1'b0;
			linkENC <= 1'b0;
			linkGPI <= 1'b0;
			linkEWM <= 1'b0;
			linkLPT <= 1'b0;
			linkFIC <= 1'b0;
			linkFOC <= 1'b0;
			linkXBR <= 1'b0;
			linkFTM <= 1'b0;
			linkGII <= 1'b0;
			linkFPT <= 1'b0;
			linkMCG <= 1'b0;
			
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select <= 1'b0;
        
			linkSSI <= 1'b0;
			linkPFT <= 1'b0;
			linkPWM <= 1'b0;

          led <= 1'b0;
          linkBIM <= 1'b1;
      end
    endcase
  end
end


/////////////////////////////////////////////////////////////

endmodule
