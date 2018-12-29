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
inout [89:69] BusB;
inout [97:97] BusC;


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
          
wire ss_sck;
wire ss_mosi;
wire ss_miso;
wire ss_ssel;
wire spi_slave_result;
          



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

reg linkCTP;
reg linkCMI;
reg linkGLO;
reg linkSMS;
reg linkCTM;
reg linkUART;
reg linkPPI;
reg linkSHM;
reg linkSPI;
reg linkPML;
reg linkSCT;
reg linkMHO;
reg linkSHS;
reg linkUTW;
reg linkFRT;
reg linkGIN;
reg linkSHL;
reg linkMHS;
reg linkSBS;

reg spi_tx_en;
reg spi_rx_en;
reg spi_rst;
reg mode_select;
    reg linkSSP;
reg linkSDC;
reg linkRIT;
reg linkSBM;

reg spi_slave_rst;
    

assign BusA[15] =  linkCTP ? BusB[87] : 1'bz;
assign BusA[8] =  linkCTP ? BusB[87] : 1'bz;
assign BusA[15] =  linkCMI ? BusB[87] : 1'bz;
assign BusA[8] =  linkCMI ? BusB[87] : 1'bz;
assign BusC[97] =  linkGLO ? BusA[16] : 1'bz;
assign BusA[3] =  linkGLO ? BusA[17] : 1'bz;
assign BusA[4] =  linkGLO ? BusA[4] : 1'bz;
assign BusA[5] =  linkGLO ? BusA[5] : 1'bz;
assign BusA[15] =  linkSMS ? BusB[87] : 1'bz;
assign BusA[8] =  linkSMS ? BusB[87] : 1'bz;
assign BusC[97] =  linkSMS ? BusA[16] : 1'bz;
assign BusA[15] =  linkCTM ? BusB[87] : 1'bz;
assign BusA[8] =  linkCTM ? BusB[87] : 1'bz;
assign BusC[97] =  linkPPI ? BusA[16] : 1'bz;
assign BusA[3] =  linkPPI ? BusA[17] : 1'bz;
assign BusA[20] =  linkSHM ? BusB[75] : 1'bz;
assign BusB[71] =  linkSHM ? BusA[18] : 1'bz;
assign BusA[19] =  linkSHM ? BusB[73] : 1'bz;
assign BusA[21] =  linkSHM ? BusB[69] : 1'bz;
assign BusB[82] =  linkSPI ? BusB[75] : 1'bz;
assign BusB[71] =  linkSPI ? BusB[86] : 1'bz;
assign BusB[84] =  linkSPI ? BusB[73] : 1'bz;
assign BusB[89] =  linkSPI ? BusB[69] : 1'bz;
assign BusC[97] =  linkPML ? BusA[16] : 1'bz;
assign BusA[15] =  linkSCT ? BusB[87] : 1'bz;
assign BusA[8] =  linkSCT ? BusB[87] : 1'bz;
assign BusC[97] =  linkMHO ? BusA[16] : 1'bz;
assign BusB[75] =  linkSHS ? BusA[20] : 1'bz;
assign BusA[18] =  linkSHS ? BusB[71] : 1'bz;
assign BusB[73] =  linkSHS ? BusA[19] : 1'bz;
assign BusB[69] =  linkSHS ? BusA[21] : 1'bz;
assign BusA[15] =  linkUTW ? BusB[85] : 1'bz;
assign BusA[8] =  linkUTW ? BusB[85] : 1'bz;
assign BusC[97] =  linkFRT ? BusA[16] : 1'bz;
assign BusC[97] =  linkGIN ? BusA[16] : 1'bz;
assign BusA[3] =  linkGIN ? BusA[16] : 1'bz;
assign BusA[17] =  linkSHL ? BusB[85] : 1'bz;
assign BusA[3] =  linkMHS ? BusA[16] : 1'bz;
assign BusB[75] =  linkSBS ? sm_cs_n : 1'bz;
assign sm_miso =  linkSBS ? BusB[71] : 1'bz;
assign BusB[73] =  linkSBS ? sm_mosi : 1'bz;
assign BusB[69] =  linkSBS ? sm_sck : 1'bz;
assign BusA[17] =  linkSBS ? spi_receive_status : 1'bz;
assign BusA[15] =  linkSSP ? BusB[87] : 1'bz;
assign BusA[8] =  linkSSP ? BusB[87] : 1'bz;
assign BusA[15] =  linkSDC ? BusA[2] : 1'bz;
assign BusA[8] =  linkSDC ? BusA[2] : 1'bz;
assign BusA[15] =  linkRIT ? BusB[87] : 1'bz;
assign BusA[8] =  linkRIT ? BusB[87] : 1'bz;
assign BusA[17] =  linkSBM ? spi_receive_status : 1'bz;
assign ss_cs_n =  linkSBM ? BusB[75] : 1'bz;
assign BusB[71] =  linkSBM ? ss_miso : 1'bz;
assign ss_mosi =  linkSBM ? BusB[73] : 1'bz;
assign ss_sck =  linkSBM ? BusB[69] : 1'bz;


 
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
        
spi_slave		spi_slave_instance(
							.clk(clk),
							.sck(ss_sck),
							.mosi(ss_mosi),
							.miso(ss_miso),
							.ssel(ss_ssel),
							.rst_n(spi_slave_rst),
							.recived_status(spi_slave_result)
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
			linkCTP <= 1'b0;
			linkCMI <= 1'b0;
			linkGLO <= 1'b0;
			linkSMS <= 1'b0;
			linkCTM <= 1'b0;
			linkPPI <= 1'b0;
			linkSHM <= 1'b0;
			linkSPI <= 1'b0;
			linkPML <= 1'b0;
			linkSCT <= 1'b0;
			linkMHO <= 1'b0;
			linkSHS <= 1'b0;
			linkUTW <= 1'b0;
			linkFRT <= 1'b0;
			linkGIN <= 1'b0;
			linkSHL <= 1'b0;
			linkMHS <= 1'b0;
			linkSBS <= 1'b0;
			linkSSP <= 1'b0;
			linkSDC <= 1'b0;
			linkRIT <= 1'b0;
			linkSBM <= 1'b0;

    ///////////////////////////////////////////////
    led <= 1'b0; // for debug led
    linkBIM <= 1'b1;
  end
  else
  begin
    case(Rx_cmd)
    ///////////////////add case here/////////////
      			
      {C,T, P}: //{C,M,D}
      begin
        linkCTP <= 1'b1;

        led <= 1'b1;
      end
      			
      {C,M, I}: //{C,M,D}
      begin
        linkCMI <= 1'b1;

        led <= 1'b1;
      end
      			
      {G,L, O}: //{C,M,D}
      begin
        linkGLO <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,M, S}: //{C,M,D}
      begin
        linkSMS <= 1'b1;

        led <= 1'b1;
      end
      			
      {C,T, M}: //{C,M,D}
      begin
        linkCTM <= 1'b1;

        led <= 1'b1;
      end
      			
      {P,P, I}: //{C,M,D}
      begin
        linkPPI <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,H, M}: //{C,M,D}
      begin
        linkSHM <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,P, I}: //{C,M,D}
      begin
        linkSPI <= 1'b1;

        led <= 1'b1;
      end
      			
      {P,M, L}: //{C,M,D}
      begin
        linkPML <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,C, T}: //{C,M,D}
      begin
        linkSCT <= 1'b1;

        led <= 1'b1;
      end
      			
      {M,H, O}: //{C,M,D}
      begin
        linkMHO <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,H, S}: //{C,M,D}
      begin
        linkSHS <= 1'b1;

        led <= 1'b1;
      end
      			
      {U,T, W}: //{C,M,D}
      begin
        linkUTW <= 1'b1;

        led <= 1'b1;
      end
      			
      {F,R, T}: //{C,M,D}
      begin
        linkFRT <= 1'b1;

        led <= 1'b1;
      end
      			
      {G,I, N}: //{C,M,D}
      begin
        linkGIN <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,H, L}: //{C,M,D}
      begin
        linkSHL <= 1'b1;

        led <= 1'b1;
      end
      			
      {M,H, S}: //{C,M,D}
      begin
        linkMHS <= 1'b1;

        led <= 1'b1;
      end
      
      {S,B, S}: //{C,M,D}
      begin
        linkSBS <= 1'b1;
			 
        spi_rst <= 1'b1;
        spi_tx_en <= 1'b1;
        spi_rx_en <= 1'b1;
        mode_select <= 1'b0;
        

        led <= 1'b1;
      end
      			
      {S,S, P}: //{C,M,D}
      begin
        linkSSP <= 1'b1;

        led <= 1'b1;
      end
      			
      {S,D, C}: //{C,M,D}
      begin
        linkSDC <= 1'b1;

        led <= 1'b1;
      end
      			
      {R,I, T}: //{C,M,D}
      begin
        linkRIT <= 1'b1;

        led <= 1'b1;
      end
      
      {S,B, M}: //{C,M,D}
      begin
        linkSBM <= 1'b1;
			 
        spi_slave_rst <= 1'b1;
        

        led <= 1'b1;
      end
      
    /////////////////////////////////////////////

      {R,S,T}: //RESET
         begin
           			linkCTP <= 1'b0;
			linkCMI <= 1'b0;
			linkGLO <= 1'b0;
			linkSMS <= 1'b0;
			linkCTM <= 1'b0;
			linkPPI <= 1'b0;
			linkSHM <= 1'b0;
			linkSPI <= 1'b0;
			linkPML <= 1'b0;
			linkSCT <= 1'b0;
			linkMHO <= 1'b0;
			linkSHS <= 1'b0;
			linkUTW <= 1'b0;
			linkFRT <= 1'b0;
			linkGIN <= 1'b0;
			linkSHL <= 1'b0;
			linkMHS <= 1'b0;
			
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select <= 1'b0;
        
			linkSBS <= 1'b0;
			linkSSP <= 1'b0;
			linkSDC <= 1'b0;
			linkRIT <= 1'b0;
			
        spi_slave_rst <= 1'b0;
        
			linkSBM <= 1'b0;

            led <= 1'b0;
            linkBIM <= 1'b1;
        end

         default:
         begin
          			linkCTP <= 1'b0;
			linkCMI <= 1'b0;
			linkGLO <= 1'b0;
			linkSMS <= 1'b0;
			linkCTM <= 1'b0;
			linkPPI <= 1'b0;
			linkSHM <= 1'b0;
			linkSPI <= 1'b0;
			linkPML <= 1'b0;
			linkSCT <= 1'b0;
			linkMHO <= 1'b0;
			linkSHS <= 1'b0;
			linkUTW <= 1'b0;
			linkFRT <= 1'b0;
			linkGIN <= 1'b0;
			linkSHL <= 1'b0;
			linkMHS <= 1'b0;
			
        spi_rst <= 1'b0;
        spi_tx_en <= 1'b0;
        spi_rx_en <= 1'b0;
        mode_select <= 1'b0;
        
			linkSBS <= 1'b0;
			linkSSP <= 1'b0;
			linkSDC <= 1'b0;
			linkRIT <= 1'b0;
			
        spi_slave_rst <= 1'b0;
        
			linkSBM <= 1'b0;

          led <= 1'b0;
          linkBIM <= 1'b1;
      end
    endcase
  end
end


/////////////////////////////////////////////////////////////

endmodule