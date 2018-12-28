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

inout [61:56] BusA;
inout [86:76] BusB;
inout [99:95] BusC;


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


wire ss_rd_sck_b2b;
wire ss_rd_mosi_b2b;
wire ss_rd_miso_b2b;
wire ss_rd_ssel_b2b;
wire spi_rd_slave_result_b2b;
           
wire pha;
wire phb;
          
wire sm_rd_sck;
wire sm_rd_mosi;
wire sm_rd_miso;
wire sm_rd_cs_n;
wire spi_receive_rd_status;
          
wire scl_slv_rd;
    
wire scl_rd;
wire rd_receive_status;
          



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

reg linkGLO;
reg linkUART;
reg linkSPS;

reg spi_rd_slave_rst_b2b;
    reg linkGPC;
 
reg enable_pwm_out;
reg[0:31] pwmfreq;
reg[0:31] dutyratio;
    reg linkSPM;

reg spi_tx_rd_en;
reg spi_rx_rd_en;
reg spi_rd_rst;
reg mode_rd_select;
    reg linkICS;

reg i2c_rst_slv_rd;
    reg linkICR;

reg RD_EN;
reg WR_EN;
reg i2c_rd_rst;
    reg linkPWM;
reg linkICW;


assign BusB[82] =  linkGLO ? BusB[84] : 1'bz;
assign BusA[61] =  linkSPS ? ss_rd_miso_b2b : 1'bz;
assign ss_rd_mosi_b2b =  linkSPS ? BusA[57] : 1'bz;
assign ss_rd_sck_b2b =  linkSPS ? BusA[56] : 1'bz;
assign ss_rd_ssel_b2b =  linkSPS ? BusA[58] : 1'bz;
assign BusB[76] =  linkGPC ? pha : 1'bz;
assign BusB[77] =  linkGPC ? phb : 1'bz;
assign BusA[58] =  linkSPM ? sm_rd_cs_n : 1'bz;
assign sm_rd_miso =  linkSPM ? BusA[61] : 1'bz;
assign BusA[57] =  linkSPM ? sm_rd_mosi : 1'bz;
assign BusA[56] =  linkSPM ? sm_rd_sck : 1'bz;
assign scl_slv_rd =  linkICS ? BusC[99] : 1'bz;
`define sda BusC[97]
`define ack_status BusC[95]
assign BusC[99] =  linkICR ? scl_rd : 1'bz;
assign BusB[82] =  linkPWM ? BusB[86] : 1'bz;
assign BusC[99] =  linkICW ? scl_rd : 1'bz;


 
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
    
spi_slave_b2b_reduced		spi_slave_b2b_instance_reduced(
							.clk(clk),
							.sck(ss_rd_sck_b2b),
							.mosi(ss_rd_mosi_b2b),
							.miso(ss_rd_miso_b2b),
							.ssel(ss_rd_ssel_b2b),
							.rst_n(spi_rd_slave_rst_b2b),
							.recived_status(spi_rd_slave_result_b2b)
                            );

         
pwm_out pwm_out(.rst_n(rst_n),
          .clk(clk),
          .enable(enable_pwm_out),
          .pha(pha), 
          .phb(phb), 
          .pwmfre(pwmfreq), 
          .dutyratio(dutyratio)
        );
        
spi_ctrl_reduced      spi_ctrl_reduced_instance(
							.clk(clk),
							.rst_n(spi_rd_rst),
							.sck(sm_rd_sck),
							.mosi(sm_rd_mosi),
							.miso(sm_rd_miso),
							.cs_n(sm_rd_cs_n),
							.spi_tx_en(spi_tx_rd_en),
							.spi_rx_en(spi_rx_rd_en),
							.mode_select(mode_rd_select),
							.receive_status(spi_receive_rd_status)
							);
        
i2c_slave_reduced      i2c_slave_reduced_instance(
							.reset_n(i2c_rst_slv_rd),
							.sda(`sda),
							.scl(scl_slv_rd),
							.clock(clk)
							);
  

I2C_MASTER_reduced        I2C_MASTER_reduced_instance(
							.clk(clk),
							.rst_n(i2c_rd_rst),
							.sda(`sda),
							.scl(scl_rd),
							.RD_EN(RD_EN),
							.WR_EN(WR_EN),
							.receive_status(`ack_status)
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
			linkGLO <= 1'b0;
			linkSPS <= 1'b0;
			linkGPC <= 1'b0;
			linkSPM <= 1'b0;
			linkICS <= 1'b0;
			linkICR <= 1'b0;
			linkPWM <= 1'b0;
			linkICW <= 1'b0;

    ///////////////////////////////////////////////
    led <= 1'b0; // for debug led
    linkBIM <= 1'b1;
  end
  else
  begin
    case(Rx_cmd)
    ///////////////////add case here/////////////
      			
      {G,L, O}: //{C,M,D}
      begin
        linkGLO <= 1'b1;

        led <= 1'b1;
      end
      
      {S,P, S}: //{C,M,D}
      begin
        linkSPS <= 1'b1;
			 
        spi_rd_slave_rst_b2b <= 1'b1;
        

        led <= 1'b1;
      end
      
      {G,P, C}: //{C,M,D}
      begin
        linkGPC <= 1'b1;
			 enable_pwm_out <= 1'b1;

        led <= 1'b1;
      end
      
      {S,P, M}: //{C,M,D}
      begin
        linkSPM <= 1'b1;
			 
        spi_rd_rst <= 1'b1;
        spi_tx_rd_en <= 1'b1;
        spi_rx_rd_en <= 1'b1;
        mode_rd_select <= 1'b0;
        

        led <= 1'b1;
      end
      
      {I,C, S}: //{C,M,D}
      begin
        linkICS <= 1'b1;
			 
        i2c_rst_slv_rd <= 1'b1;
    

        led <= 1'b1;
      end
      
      {I,C, R}: //{C,M,D}
      begin
        linkICR <= 1'b1;
			 
        i2c_rd_rst <= 1'b1;
        RD_EN   <= 1'b1;
        WR_EN   <= 1'b0;
        

        led <= 1'b1;
      end
      			
      {P,W, M}: //{C,M,D}
      begin
        linkPWM <= 1'b1;

        led <= 1'b1;
      end
      
      {I,C, W}: //{C,M,D}
      begin
        linkICW <= 1'b1;
			 
        i2c_rd_rst <= 1'b1;
        RD_EN   <= 1'b0;
        WR_EN   <= 1'b1;
		

        led <= 1'b1;
      end
      
    /////////////////////////////////////////////

      {R,S,T}: //RESET
         begin
           			linkGLO <= 1'b0;
			
        spi_rd_slave_rst_b2b <= 1'b0;
        
			linkSPS <= 1'b0;
			
    enable_pwm_out <= 1'b0;
    pwmfreq   <= 32'd500000;
    dutyratio <= 32'd250000;
    
			linkGPC <= 1'b0;
			
        spi_rd_rst <= 1'b0;
        spi_tx_rd_en <= 1'b0;
        spi_rx_rd_en <= 1'b0;
        mode_rd_select <= 1'b0;
        
			linkSPM <= 1'b0;
			
        i2c_rst_slv_rd <= 1'b0;
    
			linkICS <= 1'b0;
			
        i2c_rd_rst <= 1'b0;
        RD_EN   <= 1'b0;
        WR_EN   <= 1'b0;
        
			linkICR <= 1'b0;
			linkPWM <= 1'b0;
			linkICW <= 1'b0;

            led <= 1'b0;
            linkBIM <= 1'b1;
        end

         default:
         begin
          			linkGLO <= 1'b0;
			
        spi_rd_slave_rst_b2b <= 1'b0;
        
			linkSPS <= 1'b0;
			
    enable_pwm_out <= 1'b0;
    pwmfreq   <= 32'd500000;
    dutyratio <= 32'd250000;
    
			linkGPC <= 1'b0;
			
        spi_rd_rst <= 1'b0;
        spi_tx_rd_en <= 1'b0;
        spi_rx_rd_en <= 1'b0;
        mode_rd_select <= 1'b0;
        
			linkSPM <= 1'b0;
			
        i2c_rst_slv_rd <= 1'b0;
    
			linkICS <= 1'b0;
			
        i2c_rd_rst <= 1'b0;
        RD_EN   <= 1'b0;
        WR_EN   <= 1'b0;
        
			linkICR <= 1'b0;
			linkPWM <= 1'b0;
			linkICW <= 1'b0;

          led <= 1'b0;
          linkBIM <= 1'b1;
      end
    endcase
  end
end


/////////////////////////////////////////////////////////////

endmodule
