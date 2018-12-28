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

inout [21:8] BusA;
inout [91:71] BusB;


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

reg linkGLO;
reg linkMCG;
reg linkSIO;

reg spi_tx_en;
reg spi_rx_en;
reg spi_rst;
reg mode_select;
    reg linkSPI;
reg linkTPT;
reg linkUART;
reg linkTOC;
reg linkCMP;
reg linkSHL;
reg linkTSP;
reg linkTIC;


assign BusA[8] =  linkGLO ? BusB[73] : 1'bz;
assign BusA[15] =  linkGLO ? BusB[73] : 1'bz;
assign BusA[8] =  linkMCG ? BusB[73] : 1'bz;
assign BusA[15] =  linkMCG ? BusB[73] : 1'bz;
assign BusB[83] =  linkSIO ? sm_cs_n : 1'bz;
assign sm_miso =  linkSIO ? BusB[87] : 1'bz;
assign BusB[85] =  linkSIO ? sm_mosi : 1'bz;
assign BusB[91] =  linkSIO ? sm_sck : 1'bz;
assign BusA[17] =  linkSIO ? spi_receive_status : 1'bz;
assign BusA[21] =  linkSPI ? BusB[91] : 1'bz;
assign BusA[20] =  linkSPI ? BusB[83] : 1'bz;
assign BusB[87] =  linkSPI ? BusA[18] : 1'bz;
assign BusA[19] =  linkSPI ? BusB[85] : 1'bz;
assign BusA[8] =  linkTPT ? BusB[73] : 1'bz;
assign BusA[15] =  linkTPT ? BusB[73] : 1'bz;
assign BusA[8] =  linkTOC ? BusB[73] : 1'bz;
assign BusA[15] =  linkTOC ? BusB[73] : 1'bz;
assign BusB[71] =  linkCMP ? BusA[16] : 1'bz;
assign BusA[17] =  linkCMP ? BusB[75] : 1'bz;
assign BusA[17] =  linkSHL ? BusB[75] : 1'bz;
assign BusA[8] =  linkTSP ? BusB[73] : 1'bz;
assign BusA[15] =  linkTSP ? BusB[73] : 1'bz;
assign BusA[17] =  linkTIC ? BusB[73] : 1'bz;
assign BusB[81] =  linkTIC ? BusA[16] : 1'bz;



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
			linkGLO <= 1'b0;
			linkMCG <= 1'b0;
			linkSIO <= 1'b0;
			linkSPI <= 1'b0;
			linkTPT <= 1'b0;
			linkTOC <= 1'b0;
			linkCMP <= 1'b0;
			linkSHL <= 1'b0;
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
      			
      {G,L, O}: //{C,M,D}
      begin
        linkGLO <= 1'b1;

        led <= 1'b1;
      end
      			
      {M,C, G}: //{C,M,D}
      begin
        linkMCG <= 1'b1;

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
      			
      {S,P, I}: //{C,M,D}
      begin
        linkSPI <= 1'b1;

        led <= 1'b1;
      end
      			
      {T,P, T}: //{C,M,D}
      begin
        linkTPT <= 1'b1;

        led <= 1'b1;
      end
      			
      {T,O, C}: //{C,M,D}
      begin
        linkTOC <= 1'b1;

        led <= 1'b1;
      end
      			
      {C,M, P}: //{C,M,D}
      begin
        linkCMP <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,H, L}: //{C,M,D}
      begin
        linkSHL <= 1'b1;

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

        led <= 1'b1;
      end
      
    /////////////////////////////////////////////

      {R,S,T}: //RESET
         begin
           			linkGLO <= 1'b0;
			linkMCG <= 1'b0;
			
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select <= 1'b0;
        
			linkSIO <= 1'b0;
			linkSPI <= 1'b0;
			linkTPT <= 1'b0;
			linkTOC <= 1'b0;
			linkCMP <= 1'b0;
			linkSHL <= 1'b0;
			linkTSP <= 1'b0;
			linkTIC <= 1'b0;

            led <= 1'b0;
            linkBIM <= 1'b1;
        end

         default:
         begin
          			linkGLO <= 1'b0;
			linkMCG <= 1'b0;
			
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select <= 1'b0;
        
			linkSIO <= 1'b0;
			linkSPI <= 1'b0;
			linkTPT <= 1'b0;
			linkTOC <= 1'b0;
			linkCMP <= 1'b0;
			linkSHL <= 1'b0;
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
