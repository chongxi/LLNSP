`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  HHMI Janelia
// Engineer: Chongxi Lai
// 
// Create Date: 02/17/2016 05:03:55 PM
// Design Name: spkDet
// Module Name: spkDet
// Project Name: Xike
// Target Devices: KC705
// Tool Versions: Vivado 2015.4
// Description: 
// TODO: 1.(should spkDet be channel number aware?) (Yes, Done)
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
// 
// 
// 
// initiate template:
// module spkDet_A (
//     .clk         (), // <-- use fir_valid for the first version trial
//     .thr_enable  (),
//     .valid_in    (), // <-- fir_valid
//     .end_of_frame(), // <-- end_of_frame
//     .ch_No       (), // <-- chNo_out
//     .threshold_in(), // <-- threshold
//     .v_in        (), // <-- fir_out
//     .ch_out      (),
//     .eof_out     (),
//     .valid_out   (), // (spkDet_valid && !fifo1_full) --> fifo1_wr_en
//     .v_out       (), // --> tohost
//     .min_out     
// );
// 
//////////////////////////////////////////////////////////////////////////////////
// 
//    s0                               s0
//      s0                    s0    s0    s0
//        s0               s0    s0          s0          s0
//   --------------------------------------------------------- threshold
//          s1          s2                      s1    s2
//                    s2                           s1    
//            s1    s2                                      
//                s2
//              s1
// 
//////////////////////////////////////////////////////////////////////////////////

module spkDet_A (
      input                clk            , // <-- use fir_valid for the first version trial
      input                rst            ,
      input                thr_enable     ,
      input                valid_in       , // <-- fir_valid
      input                end_of_frame   , // <-- end_of_frame
      input         [ 7:0] ch_No          , // <-- chNo_out
      input         [31:0] ch_unigroup    ,
      input  signed [31:0] threshold_in   , // <-- threshold
      input  signed [31:0] v_in           , // <-- fir_out
      //
      output        [ 7:0] ch_out         ,
      output        [31:0] ch_unigroup_out,
      output               eof_out        ,
      output               valid_out      , // (spkDet_valid && !fifo1_full) --> fifo1_wr_en
      output signed [31:0] v_out          , // --> tohost
      output signed [31:0] min_out        ,
      output        [ 1:0] state_out      ,
      output               is_peak_out
);


parameter NUM_CH=32;
parameter S0 = 2'b00,
          S1 = 2'b01,
          S2 = 2'b10,
          S3 = 2'b11;

(* ram_style = "distributed" *)
reg [1:0] state[0:NUM_CH-1];

reg [NUM_CH-1:0] ispeak;
reg peak_bufo;
reg [1:0] state_bufo;

(* ram_style = "distributed" *)
reg signed [31:0] Mn[0:NUM_CH-1];
reg signed [31:0] Min[0:NUM_CH-1];
// reg signed [31:0] Min_bufo;


// threshold buffer by 1 clock
reg signed [31:0] threshold;


// other inputs buffer by 2 clocks
reg valid_in_buf;
reg [7:0] ch_in_buf;
reg [31:0] ch_unigroup_in_buf;
reg signed [31:0] v_in_buf;
reg eof_in_buf;
// second buf for processing 
reg valid_buf;    // (*) which is enable signal to FSM, so is important
reg [7:0] ch_buf; 
reg [31:0] ch_unigroup_buf;
reg signed [31:0] v_buf;
reg eof_buf;
// output buffer
reg valid_bufo;
reg [7:0] ch_bufo;
reg [31:0] ch_unigroup_bufo;
reg signed [31:0] v_bufo;
reg eof_bufo;

// ch_unigroup is a hash_code, which contains 4 bytes: 0. streamNo; 1-3: 3 nearest electrodes
wire [7:0] streamNo;
wire signed [7:0] ch_nn0;
wire signed [7:0] ch_nn1;
wire signed [7:0] ch_nn2;

assign streamNo = ch_unigroup_buf[ 7:0 ];
assign ch_nn0   = ch_unigroup_buf[15:8 ];
assign ch_nn1   = ch_unigroup_buf[23:16];
assign ch_nn2   = ch_unigroup_buf[31:24];

// Input and Output pipeline buffer for timing
always @(posedge clk) begin : pipeline_buffer_input_internal_output
  if (!thr_enable) begin   // thresholding disable
    valid_bufo <= valid_in;
    v_bufo     <= v_in;
  end
  // spike detection
  else begin
    // input buff for processing
    valid_in_buf       <= valid_in;
    ch_in_buf          <= ch_No;
    v_in_buf           <= v_in;
    eof_in_buf         <= end_of_frame;
    // get internal buffer (where computation depends on)
    valid_buf          <= valid_in_buf;
    ch_buf             <= ch_in_buf;
    ch_unigroup_buf    <= ch_unigroup;
    v_buf              <= v_in_buf;
    eof_buf            <= eof_in_buf;

    threshold          <= threshold_in;

    // output buff
    if (v_buf < threshold) begin
      valid_bufo       <= valid_buf;
      ch_bufo          <= ch_buf;
      ch_unigroup_bufo <= ch_unigroup_buf;
      v_bufo           <= v_buf;
      eof_bufo         <= eof_buf;
    end
    else begin
      valid_bufo       <= valid_buf;
      ch_bufo          <= ch_buf;
      ch_unigroup_bufo <= ch_unigroup_buf;
      v_bufo           <= v_buf;   // change `v_buf` to 0 would remove signal above threshold
      eof_bufo         <= eof_buf;
    end
  end
end


// Mn for PeakDet FSM
always @(posedge clk) begin : proc_Min_Array
    if (valid_buf) begin
        if  (v_buf >= threshold) begin
            Mn[ch_buf] <= 0;
        end
        else if (v_buf < threshold && v_buf < Mn[ch_buf]) begin
            Mn[ch_buf] <= v_buf;
        end
    end
end


//------------------------------------------------
// PeakDet FSM:                                  |
// -----------------------------------------------
// input:   v_buf, Mn[ch_buf], threshold         |
// output:  ispeak[ch_buf]                       |
// state:   state[ch_buf] --> nextstate[ch_buf]  |
// -----------------------------------------------
always @(posedge clk) begin : nextstate_and_output_logic
    if (valid_buf) begin
      (* full_case *)
      case (state[ch_buf])

       S0 : if(v_buf >= threshold) begin                             // keep above thres:  S0-->S0
              state[ch_buf]  <= S0;
              state_bufo     <= S0;
              ispeak[ch_buf] <= 0;
              peak_bufo      <= 0;
            end
            else if(v_buf < threshold) begin                         // down to threshold: S0-->S1
              state[ch_buf]  <= S1;
              state_bufo     <= S1;
              ispeak[ch_buf] <= 0;
              peak_bufo      <= 0;
            end

       S1 : if(v_buf < threshold && v_buf < Mn[ch_buf]) begin        // keep going down:   S1-->S1
              state[ch_buf]  <= S1;
              state_bufo     <= S1;
              ispeak[ch_buf] <= 0;
              peak_bufo      <= 0;
            end
            else if(v_buf < threshold && v_buf >= Mn[ch_buf]) begin  // stop going down:   S1-->S2 (peak)
              state[ch_buf]  <= S2;
              state_bufo     <= S2;
              // This is a tricky point, if ch_buf+1 is critical point, then Mn[ch_buf+1] < v_buf@ch_buf+1, 
              // Then if Mn[ch_buf] < Mn[ch_buf+1] proves that ch_buf is critical
              if(Mn[ch_buf] < Mn[ch_nn0] && Mn[ch_buf] < Mn[ch_nn1]) begin 
                ispeak[ch_buf] <= 1;
                peak_bufo      <= 1;
              end
              else begin
                ispeak[ch_buf] <= 0;
                peak_bufo      <= 0;
              end
            end
            else if(v_buf >= threshold) begin
              state[ch_buf]  <= S0;
              state_bufo     <= S0;
              ispeak[ch_buf] <= 0;
              peak_bufo      <= 0;
            end

       S2 : if(v_buf < threshold && v_buf >= Mn[ch_buf]) begin      // between Mn and thres:           S2-->S2
              state[ch_buf]  <= S2;
              state_bufo     <= S2;
              ispeak[ch_buf] <= 0;
              peak_bufo      <= 0;
            end
            else if(v_buf < threshold && v_buf < Mn[ch_buf]) begin  // going down even lower somehow:  S2-->S1
              state[ch_buf]  <= S1;
              state_bufo     <= S1;
              ispeak[ch_buf] <= 0;
              peak_bufo      <= 0;
            end
            else if(v_buf >= threshold) begin                       // going up above thres:           S2-->S0
              state[ch_buf]  <= S0;
              state_bufo     <= S0;
              ispeak[ch_buf] <= 0;
              peak_bufo      <= 0;
              Min[ch_buf]    <= 0;
            end

      endcase

    end
end


assign ch_out          = ch_bufo;
assign v_out           = {v_bufo[31:1], peak_bufo};   // last bit indicate turning point
assign valid_out       = valid_bufo;
assign eof_out         = eof_bufo;
assign min_out         = Mn[ch_bufo];
assign state_out       = state_bufo;
assign is_peak_out     = peak_bufo&valid_out;
assign ch_unigroup_out = ch_unigroup_bufo;


endmodule
