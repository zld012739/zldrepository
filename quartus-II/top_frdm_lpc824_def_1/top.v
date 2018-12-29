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

inout [8:5] BusA;
inout [17:16] BusB;
inout [42:40] BusC;
inout [75:61] BusD;
inout [100:83] BusE;


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


wire sm_sck;
wire sm_mosi;
wire sm_miso;
wire sm_cs_n;
wire spi_receive_status;
          
wire scl_slv_polling;
    
wire ss_sck_cpha0;
wire ss_mosi_cpha0;
wire ss_miso_cpha0;
wire ss_ssel_cpha0;
          



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
reg linkSBS;

reg spi_tx_en;
reg spi_rx_en;
reg spi_rst;
reg mode_select_CPHA;
reg mode_select_CPOL;
    reg linkSBP;
reg linkCTB;
reg linkGLO;
reg linkSWA;
reg linkSWC;
reg linkSWB;
reg linkRSB;
reg linkURT;
reg linkISS;

reg i2c_rst_slv_polling;
reg ip_select;
    reg linkISI;
reg linkSBM;

reg spi_slave_rst_cpha0;
    reg linkUART;
reg linkPMA;
reg linkPMB;
reg linkSDC;
reg linkCMP;
reg linkADC;


assign BusE[83] =  linkSBS ? sm_cs_n : 1'bz;
assign sm_miso =  linkSBS ? BusE[87] : 1'bz;
assign BusE[85] =  linkSBS ? sm_mosi : 1'bz;
assign BusE[91] =  linkSBS ? sm_sck : 1'bz;
assign spi_receive_status =  linkSBS ? BusB[17] : 1'bz;
assign BusE[83] =  linkSBP ? sm_cs_n : 1'bz;
assign sm_miso =  linkSBP ? BusE[87] : 1'bz;
assign BusE[85] =  linkSBP ? sm_mosi : 1'bz;
assign BusE[91] =  linkSBP ? sm_sck : 1'bz;
assign spi_receive_status =  linkSBP ? BusB[17] : 1'bz;
assign BusA[8] =  linkCTB ? BusD[73] : 1'bz;
assign BusD[61] =  linkGLO ? BusB[16] : 1'bz;
assign BusB[17] =  linkGLO ? BusD[73] : 1'bz;
assign BusD[61] =  linkSWA ? BusB[16] : 1'bz;
assign BusA[5] =  linkSWC ? BusB[16] : 1'bz;
assign BusD[67] =  linkSWB ? BusB[16] : 1'bz;
assign BusA[5] =  linkRSB ? BusB[16] : 1'bz;
assign BusD[75] =  linkURT ? BusE[91] : 1'bz;
assign BusD[64] =  linkURT ? BusE[87] : 1'bz;
assign BusD[69] =  linkURT ? BusE[85] : 1'bz;
assign scl_slv_polling =  linkISS ? BusE[100] : 1'bz;
`define sda BusE[98]
assign scl_slv_polling =  linkISI ? BusE[100] : 1'bz;
assign BusE[87] =  linkSBM ? ss_miso_cpha0 : 1'bz;
assign ss_mosi_cpha0 =  linkSBM ? BusE[85] : 1'bz;
assign ss_sck_cpha0 =  linkSBM ? BusE[91] : 1'bz;
assign ss_ssel_cpha0 =  linkSBM ? BusE[83] : 1'bz;
assign BusD[61] =  linkPMA ? BusB[16] : 1'bz;
assign BusD[67] =  linkPMB ? BusB[16] : 1'bz;
assign BusA[8] =  linkSDC ? BusD[67] : 1'bz;
assign BusC[42] =  linkCMP ? BusB[16] : 1'bz;
assign BusB[17] =  linkCMP ? BusD[67] : 1'bz;
assign BusC[40] =  linkADC ? BusB[16] : 1'bz;



spi_ctrl      spi_ctrl_instance(
							.clk(clk),
							.rst_n(spi_rst),
							.sck(sm_sck),
							.mosi(sm_mosi),
							.miso(sm_miso),
							.cs_n(sm_cs_n),
							.spi_tx_en(spi_tx_en),
							.spi_rx_en(spi_rx_en),
							.mode_select_CPHA(mode_select_CPHA),
							.mode_select_CPOL(mode_select_CPOL),
							.receive_status(spi_receive_status)
							);
        
i2c_slave_lpc8_polling      i2c_slave_lpc8_polling_instance(
							.reset_n(i2c_rst_slv_polling),
							.sda(`sda),
							.scl(scl_slv_polling),
							.clock(clk),
							.ip_select(ip_select)
							);
    
spi_slave_cpha0		spi_slave_cpha0_instance(
							.clk(clk),
							.sck(ss_sck_cpha0),
							.mosi(ss_mosi_cpha0),
							.miso(ss_miso_cpha0),
							.ssel(ss_ssel_cpha0),
							.rst_n(spi_slave_rst_cpha0)
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
			linkSBS <= 1'b0;
			linkSBP <= 1'b0;
			linkCTB <= 1'b0;
			linkGLO <= 1'b0;
			linkSWA <= 1'b0;
			linkSWC <= 1'b0;
			linkSWB <= 1'b0;
			linkRSB <= 1'b0;
			linkURT <= 1'b0;
			linkISS <= 1'b0;
			linkISI <= 1'b0;
			linkSBM <= 1'b0;
			linkPMA <= 1'b0;
			linkPMB <= 1'b0;
			linkSDC <= 1'b0;
			linkCMP <= 1'b0;
			linkADC <= 1'b0;

    ///////////////////////////////////////////////
    led <= 1'b0; // for debug led
    linkBIM <= 1'b1;
  end
  else if(cmd_red) begin
						
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select_CPOL <= 1'b0;
        mode_select_CPHA <= 1'b0;
        
			linkSBS <= 1'b0;
			linkSBP <= 1'b0;
			linkCTB <= 1'b0;
			linkGLO <= 1'b0;
			linkSWA <= 1'b0;
			linkSWC <= 1'b0;
			linkSWB <= 1'b0;
			linkRSB <= 1'b0;
			linkURT <= 1'b0;
			
        i2c_rst_slv_polling <= 1'b0;
        ip_select <= 1'b0;
    
			linkISS <= 1'b0;
			linkISI <= 1'b0;
			
        spi_slave_rst_cpha0 <= 1'b0;
        
			linkSBM <= 1'b0;
			linkPMA <= 1'b0;
			linkPMB <= 1'b0;
			linkSDC <= 1'b0;
			linkCMP <= 1'b0;
			linkADC <= 1'b0;

            led <= 1'b0;
            capture_rst <= 1'b0;
  end
  else
  begin
    case(Rx_cmd)
    ///////////////////add case here/////////////
      
      {S,B, S}: //{C,M,D}
      begin
        linkSBS <= 1'b1;
			 
        spi_rst <= 1'b1;
        spi_tx_en <= 1'b1;
        spi_rx_en <= 1'b1;
        mode_select_CPOL <= 1'b0;
        mode_select_CPHA <= 1'b0;	
        

        led <= 1'b1;
      end
      
      {S,B, P}: //{C,M,D}
      begin
        linkSBP <= 1'b1;
			 
        spi_rst <= 1'b1;
        spi_tx_en <= 1'b1;
        spi_rx_en <= 1'b1;
        mode_select_CPOL <= 1'b0;
        mode_select_CPHA <= 1'b1;		
        

        led <= 1'b1;
      end
      			
      {C,T, B}: //{C,M,D}
      begin
        linkCTB <= 1'b1;

        led <= 1'b1;
      end
      			
      {G,L, O}: //{C,M,D}
      begin
        linkGLO <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,W, A}: //{C,M,D}
      begin
        linkSWA <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,W, C}: //{C,M,D}
      begin
        linkSWC <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,W, B}: //{C,M,D}
      begin
        linkSWB <= 1'b1;

        led <= 1'b1;
      end
      			
      {R,S, B}: //{C,M,D}
      begin
        linkRSB <= 1'b1;

        led <= 1'b1;
      end
      			
      {U,R, T}: //{C,M,D}
      begin
        linkURT <= 1'b1;

        led <= 1'b1;
      end
      
      {I,S, S}: //{C,M,D}
      begin
        linkISS <= 1'b1;
			 
        i2c_rst_slv_polling <= 1'b1;
        ip_select <= 1'b0;
        

        led <= 1'b1;
      end
      
      {I,S, I}: //{C,M,D}
      begin
        linkISI <= 1'b1;
			 
        i2c_rst_slv_polling <= 1'b1;
        ip_select <= 1'b1;
        

        led <= 1'b1;
      end
      
      {S,B, M}: //{C,M,D}
      begin
        linkSBM <= 1'b1;
			 
        spi_slave_rst_cpha0 <= 1'b1;
        

        led <= 1'b1;
      end
      			
      {P,M, A}: //{C,M,D}
      begin
        linkPMA <= 1'b1;

        led <= 1'b1;
      end
      			
      {P,M, B}: //{C,M,D}
      begin
        linkPMB <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,D, C}: //{C,M,D}
      begin
        linkSDC <= 1'b1;

        led <= 1'b1;
      end
      			
      {C,M, P}: //{C,M,D}
      begin
        linkCMP <= 1'b1;

        led <= 1'b1;
      end
      			
      {A,D, C}: //{C,M,D}
      begin
        linkADC <= 1'b1;

        led <= 1'b1;
      end
      
    /////////////////////////////////////////////

      {R,S,T}: //RESET
         begin
           			
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select_CPOL <= 1'b0;
        mode_select_CPHA <= 1'b0;
        
			linkSBS <= 1'b0;
			linkSBP <= 1'b0;
			linkCTB <= 1'b0;
			linkGLO <= 1'b0;
			linkSWA <= 1'b0;
			linkSWC <= 1'b0;
			linkSWB <= 1'b0;
			linkRSB <= 1'b0;
			linkURT <= 1'b0;
			
        i2c_rst_slv_polling <= 1'b0;
        ip_select <= 1'b0;
    
			linkISS <= 1'b0;
			linkISI <= 1'b0;
			
        spi_slave_rst_cpha0 <= 1'b0;
        
			linkSBM <= 1'b0;
			linkPMA <= 1'b0;
			linkPMB <= 1'b0;
			linkSDC <= 1'b0;
			linkCMP <= 1'b0;
			linkADC <= 1'b0;

            led <= 1'b0;
            linkBIM <= 1'b1;
            capture_rst <= 1'b0;
        end

         default:
         begin
          			
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select_CPOL <= 1'b0;
        mode_select_CPHA <= 1'b0;
        
			linkSBS <= 1'b0;
			linkSBP <= 1'b0;
			linkCTB <= 1'b0;
			linkGLO <= 1'b0;
			linkSWA <= 1'b0;
			linkSWC <= 1'b0;
			linkSWB <= 1'b0;
			linkRSB <= 1'b0;
			linkURT <= 1'b0;
			
        i2c_rst_slv_polling <= 1'b0;
        ip_select <= 1'b0;
    
			linkISS <= 1'b0;
			linkISI <= 1'b0;
			
        spi_slave_rst_cpha0 <= 1'b0;
        
			linkSBM <= 1'b0;
			linkPMA <= 1'b0;
			linkPMB <= 1'b0;
			linkSDC <= 1'b0;
			linkCMP <= 1'b0;
			linkADC <= 1'b0;

          led <= 1'b0;
          linkBIM <= 1'b1;
          capture_rst <= 1'b0;		  
      end
    endcase
  end
end


/////////////////////////////////////////////////////////////

endmodule