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

inout [15:3] BusA;
inout [89:82] BusB;


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

 
wire pha;
wire phb;
          
wire ss_sck_0_base;
wire ss_mosi_0_base;
wire ss_miso_0_base;
wire ss_ssel_0_base;
wire spi_slave_0_base_result;
          
wire ss_sck_b2b;
wire ss_mosi_b2b;
wire ss_miso_b2b;
wire ss_ssel_b2b;
wire spi_slave_result_b2b;
          
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

reg linkFCP;
reg linkFDC;
 
reg enable_pwm_out;
reg[0:31] pwmfreq;
reg[0:31] dutyratio;
    reg linkSPS;

reg spi_slave_0_base_rst;
    reg linkFIC;
reg linkEMB;

reg spi_slave_rst_b2b;
    reg linkTDC;
reg linkGLO;
reg linkRLO;
reg linkTCP;
reg linkDSS;

reg spi_tx_en;
reg spi_rx_en;
reg spi_rst;
reg mode_select;
    reg linkFSP;
reg linkFPT;
reg linkTPT;
reg linkUART;
reg linkFOC;
reg linkTOC;
reg linkTSP;
reg linkTIC;


assign BusA[8] =  linkFCP ? BusB[82] : 1'bz;
assign BusA[15] =  linkFCP ? BusB[84] : 1'bz;
assign BusA[3] =  linkFDC ? pha : 1'bz;
assign BusB[84] =  linkSPS ? ss_miso_0_base : 1'bz;
assign ss_mosi_0_base =  linkSPS ? BusB[82] : 1'bz;
assign ss_sck_0_base =  linkSPS ? BusB[86] : 1'bz;
assign ss_ssel_0_base =  linkSPS ? BusB[89] : 1'bz;
assign BusA[3] =  linkFIC ? pha : 1'bz;
assign BusB[84] =  linkEMB ? ss_miso_b2b : 1'bz;
assign ss_mosi_b2b =  linkEMB ? BusB[82] : 1'bz;
assign ss_sck_b2b =  linkEMB ? BusB[86] : 1'bz;
assign ss_ssel_b2b =  linkEMB ? BusB[89] : 1'bz;
assign BusA[3] =  linkTDC ? pha : 1'bz;
assign BusA[8] =  linkGLO ? BusB[86] : 1'bz;
assign BusA[8] =  linkRLO ? BusA[3] : 1'bz;
assign BusA[15] =  linkRLO ? BusA[3] : 1'bz;
assign BusA[8] =  linkTCP ? BusA[3] : 1'bz;
assign BusA[15] =  linkTCP ? BusA[4] : 1'bz;
assign BusB[89] =  linkDSS ? sm_cs_n : 1'bz;
assign sm_miso =  linkDSS ? BusB[82] : 1'bz;
assign BusB[84] =  linkDSS ? sm_mosi : 1'bz;
assign BusB[86] =  linkDSS ? sm_sck : 1'bz;
assign BusA[8] =  linkFSP ? BusB[84] : 1'bz;
assign BusA[15] =  linkFSP ? BusB[84] : 1'bz;
assign BusA[8] =  linkFPT ? BusB[82] : 1'bz;
assign BusA[15] =  linkFPT ? BusB[84] : 1'bz;
assign BusA[8] =  linkTPT ? BusA[3] : 1'bz;
assign BusA[15] =  linkTPT ? BusA[4] : 1'bz;
assign BusA[8] =  linkFOC ? BusB[84] : 1'bz;
assign BusA[15] =  linkFOC ? BusB[84] : 1'bz;
assign BusA[8] =  linkTOC ? BusA[3] : 1'bz;
assign BusA[15] =  linkTOC ? BusA[4] : 1'bz;
assign BusA[8] =  linkTSP ? BusA[3] : 1'bz;
assign BusA[15] =  linkTSP ? BusA[4] : 1'bz;
assign BusA[3] =  linkTIC ? pha : 1'bz;


 
pwm_out pwm_out(.rst_n(rst_n),
          .clk(clk),
          .enable(enable_pwm_out),
          .pha(pha), 
          .phb(phb), 
          .pwmfre(pwmfreq), 
          .dutyratio(dutyratio)
        );
        
spi_slave_0_base		spi_slave_0_base_instance(
							.clk(clk),
							.sck(ss_sck_0_base),
							.mosi(ss_mosi_0_base),
							.miso(ss_miso_0_base),
							.ssel(ss_ssel_0_base),
							.rst_n(spi_slave_0_base_rst),
							.recived_status(spi_slave_0_base_result)
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
			linkFCP <= 1'b0;
			linkFDC <= 1'b0;
			linkSPS <= 1'b0;
			linkFIC <= 1'b0;
			linkEMB <= 1'b0;
			linkTDC <= 1'b0;
			linkGLO <= 1'b0;
			linkRLO <= 1'b0;
			linkTCP <= 1'b0;
			linkDSS <= 1'b0;
			linkFSP <= 1'b0;
			linkFPT <= 1'b0;
			linkTPT <= 1'b0;
			linkFOC <= 1'b0;
			linkTOC <= 1'b0;
			linkTSP <= 1'b0;
			linkTIC <= 1'b0;

    ///////////////////////////////////////////////
    led <= 1'b0; // for debug led
    linkBIM <= 1'b1;
  end
  else
  begin
    case(Rx_cmd)
    ///////////////////add case here/////////////
      			
      {F,C, P}: //{C,M,D}
      begin
        linkFCP <= 1'b1;

        led <= 1'b1;
      end
      
      {F,D, C}: //{C,M,D}
      begin
        linkFDC <= 1'b1;
			 enable_pwm_out <= 1'b1;

        led <= 1'b1;
      end
      
      {S,P, S}: //{C,M,D}
      begin
        linkSPS <= 1'b1;
			 
        spi_slave_0_base_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
      {F,I, C}: //{C,M,D}
      begin
        linkFIC <= 1'b1;
			 enable_pwm_out <= 1'b1;

        led <= 1'b1;
      end
      
      {E,M, B}: //{C,M,D}
      begin
        linkEMB <= 1'b1;
			 
        spi_slave_rst_b2b <= 1'b1;
        

        led <= 1'b1;
      end
      
      {T,D, C}: //{C,M,D}
      begin
        linkTDC <= 1'b1;
			 enable_pwm_out <= 1'b1;

        led <= 1'b1;
      end
      			
      {G,L, O}: //{C,M,D}
      begin
        linkGLO <= 1'b1;

        led <= 1'b1;
      end
      			
      {R,L, O}: //{C,M,D}
      begin
        linkRLO <= 1'b1;

        led <= 1'b1;
      end
      			
      {T,C, P}: //{C,M,D}
      begin
        linkTCP <= 1'b1;

        led <= 1'b1;
      end
      
      {D,S, S}: //{C,M,D}
      begin
        linkDSS <= 1'b1;
			 
        spi_rst <= 1'b1;
        spi_tx_en <= 1'b1;
        spi_rx_en <= 1'b1;
        mode_select <= 1'b0;
        

        led <= 1'b1;
      end
      			
      {F,S, P}: //{C,M,D}
      begin
        linkFSP <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,P, T}: //{C,M,D}
      begin
        linkFPT <= 1'b1;

        led <= 1'b1;
      end
      			
      {T,P, T}: //{C,M,D}
      begin
        linkTPT <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,O, C}: //{C,M,D}
      begin
        linkFOC <= 1'b1;

        led <= 1'b1;
      end
      			
      {T,O, C}: //{C,M,D}
      begin
        linkTOC <= 1'b1;

        led <= 1'b1;
      end
      			
      {T,S, P}: //{C,M,D}
      begin
        linkTSP <= 1'b1;

        led <= 1'b1;
      end
      
      {T,I, C}: //{C,M,D}
      begin
        linkTIC <= 1'b1;
			 enable_pwm_out <= 1'b1;

        led <= 1'b1;
      end
      
    /////////////////////////////////////////////

      {R,S,T}: //RESET
         begin
           			linkFCP <= 1'b0;
			
    enable_pwm_out <= 1'b0;
    pwmfreq   <= 32'd500000;
    dutyratio <= 32'd250000;
    
			linkFDC <= 1'b0;
			
        spi_slave_0_base_rst <= 1'b0;
        
			linkSPS <= 1'b0;
			linkFIC <= 1'b0;
			
        spi_slave_rst_b2b <= 1'b0;
        
			linkEMB <= 1'b0;
			linkTDC <= 1'b0;
			linkGLO <= 1'b0;
			linkRLO <= 1'b0;
			linkTCP <= 1'b0;
			
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select <= 1'b0;
        
			linkDSS <= 1'b0;
			linkFSP <= 1'b0;
			linkFPT <= 1'b0;
			linkTPT <= 1'b0;
			linkFOC <= 1'b0;
			linkTOC <= 1'b0;
			linkTSP <= 1'b0;
			linkTIC <= 1'b0;

            led <= 1'b0;
            linkBIM <= 1'b1;
        end

         default:
         begin
          			linkFCP <= 1'b0;
			
    enable_pwm_out <= 1'b0;
    pwmfreq   <= 32'd500000;
    dutyratio <= 32'd250000;
    
			linkFDC <= 1'b0;
			
        spi_slave_0_base_rst <= 1'b0;
        
			linkSPS <= 1'b0;
			linkFIC <= 1'b0;
			
        spi_slave_rst_b2b <= 1'b0;
        
			linkEMB <= 1'b0;
			linkTDC <= 1'b0;
			linkGLO <= 1'b0;
			linkRLO <= 1'b0;
			linkTCP <= 1'b0;
			
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select <= 1'b0;
        
			linkDSS <= 1'b0;
			linkFSP <= 1'b0;
			linkFPT <= 1'b0;
			linkTPT <= 1'b0;
			linkFOC <= 1'b0;
			linkTOC <= 1'b0;
			linkTSP <= 1'b0;
			linkTIC <= 1'b0;

          led <= 1'b0;
          linkBIM <= 1'b1;
      end
    endcase
  end
end


/////////////////////////////////////////////////////////////

endmodule