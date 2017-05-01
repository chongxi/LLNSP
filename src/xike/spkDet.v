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
//////////////////////////////////////////////////////////////////////////////////
module spkDet (
    input          bus_clk,
    input          spkDet_en, 
    input          mua_comb_valid, 
    input [59 :0]  mua_comb_ch,
    input [159:0]  mua_comb_data,    
    input [159:0]  threshold_comb,
    input [159:0]  ch_unigroup_comb,
    input [159:0]  off_set_comb,

    output [159:0] muap_comb_data,
    output [ 59:0] muap_comb_ch  ,
    output         muap_comb_valid
);
 
  // spkDet_A, detect spikes according to channel No and threshold
  // output spike state value indicate there is a spike happen
  // (* mark_debug = "true" *) 
  parameter NUM_BANK=5;
   
  // input structure
  wire [31:0] threshold   [0:NUM_BANK-1];
  wire [31:0] ch_unigroup [0:NUM_BANK-1];
  wire [31:0] off_set     [0:NUM_BANK-1];
  wire [31:0] mua_in      [0:NUM_BANK-1];
  wire [11:0] mua_ch      [0:NUM_BANK-1];
  
  assign threshold[0] = threshold_comb[31:0];
  assign threshold[1] = threshold_comb[63:32];
  assign threshold[2] = threshold_comb[95:64];
  assign threshold[3] = threshold_comb[127:96];
  assign threshold[4] = threshold_comb[159:128];
  
  assign ch_unigroup[0] = ch_unigroup_comb[31:0];
  assign ch_unigroup[1] = ch_unigroup_comb[63:32];
  assign ch_unigroup[2] = ch_unigroup_comb[95:64];
  assign ch_unigroup[3] = ch_unigroup_comb[127:96];
  assign ch_unigroup[4] = ch_unigroup_comb[159:128];
  
  assign off_set[0] = off_set_comb[31:0];
  assign off_set[1] = off_set_comb[63:32];
  assign off_set[2] = off_set_comb[95:64];
  assign off_set[3] = off_set_comb[127:96];
  assign off_set[4] = off_set_comb[159:128];  

  assign mua_in[0] = mua_comb_data[31:0]    - off_set_comb[31:0];
  assign mua_in[1] = mua_comb_data[63:32]   - off_set_comb[63:32];
  assign mua_in[2] = mua_comb_data[95:64]   - off_set_comb[63:32];
  assign mua_in[3] = mua_comb_data[127:96]  - off_set_comb[127:96];
  assign mua_in[4] = mua_comb_data[159:128] - off_set_comb[159:128];   

  assign mua_ch[0] = mua_comb_ch[11:0];
  assign mua_ch[1] = mua_comb_ch[23:12];
  assign mua_ch[2] = mua_comb_ch[35:24];
  assign mua_ch[3] = mua_comb_ch[47:36];
  assign mua_ch[4] = mua_comb_ch[59:48];    
  
  
  // output structure
  wire [ 7:0] spkA_ch_out [0:NUM_BANK-1];
  wire [31:0] spkA_ch_unigroup_out[0:NUM_BANK-1];
  wire        spkA_eof_out[0:NUM_BANK-1];
  wire        spkA_valid_out[0:NUM_BANK-1];
  wire [31:0] spkA_v_out[0:NUM_BANK-1];
  wire [31:0] spkA_min_out[0:NUM_BANK-1];
  wire [ 1:0] spkA_state_out[0:NUM_BANK-1];
  wire        spkA_is_peak[0:NUM_BANK-1];
  
  assign muap_comb_data[31:0]    = spkA_v_out[0];
  assign muap_comb_data[63:32]   = spkA_v_out[1];
  assign muap_comb_data[95:64]   = spkA_v_out[2];
  assign muap_comb_data[127:96]  = spkA_v_out[3];
  assign muap_comb_data[159:128] = spkA_v_out[4];
  
  assign muap_comb_ch[11: 0]     = spkA_ch_out[0];
  assign muap_comb_ch[23:12]     = spkA_ch_out[1];
  assign muap_comb_ch[35:24]     = spkA_ch_out[2];
  assign muap_comb_ch[47:36]     = spkA_ch_out[3];
  assign muap_comb_ch[59:48]     = spkA_ch_out[4];

  assign muap_comb_valid         = spkA_valid_out[0];

  spkDet_A #(.NUM_CH(32)) spkDet_A_bank_0 (
    .clk            (bus_clk             ),
    .thr_enable     (spkDet_en           ),
    .valid_in       (mua_comb_valid           ), // <-- fir_valid
    .end_of_frame   (end_of_frame        ), // <-- end_of_frame
    .ch_No          (mua_ch[0]              ), // <-- chNo_to_spkDet
    .ch_unigroup    (ch_unigroup[0]         ),
    .threshold_in   (threshold[0]           ), // <-- threshold
    .v_in           (mua_in[0]            ), // <-- fir_out
    .ch_out         (spkA_ch_out[0]         ),
    .ch_unigroup_out(spkA_ch_unigroup_out[0]),
    .eof_out        (spkA_eof_out[0]        ), // --> end_of_frame
    .valid_out      (spkA_valid_out[0]      ),
    .v_out          (spkA_v_out[0]          ), // --> spkDet_B
    .min_out        (spkA_min_out[0]        ),
    .state_out      (spkA_state_out[0]      ),
    .is_peak_out    (spkA_is_peak[0]        )
  );

  spkDet_A #(.NUM_CH(32)) spkDet_A_bank_1 (
    .clk            (bus_clk             ),
    .thr_enable     (spkDet_en           ),
    .valid_in       (mua_comb_valid           ), // <-- fir_valid
    .end_of_frame   (end_of_frame        ), // <-- end_of_frame
    .ch_No          (mua_ch[1]              ), // <-- chNo_to_spkDet
    .ch_unigroup    (ch_unigroup[1]         ),
    .threshold_in   (threshold[1]           ), // <-- threshold
    .v_in           (mua_in[1]            ), // <-- fir_out
    .ch_out         (spkA_ch_out[1]         ),
    .ch_unigroup_out(spkA_ch_unigroup_out[1]),
    .eof_out        (spkA_eof_out[1]        ), // --> end_of_frame
    .valid_out      (spkA_valid_out[1]      ),
    .v_out          (spkA_v_out[1]          ), // --> spkDet_B
    .min_out        (spkA_min_out[1]        ),
    .state_out      (spkA_state_out[1]      ),
    .is_peak_out    (spkA_is_peak[1]        )
  );
  
  spkDet_A #(.NUM_CH(32)) spkDet_A_bank_2 (
    .clk            (bus_clk             ),
    .thr_enable     (spkDet_en           ),
    .valid_in       (mua_comb_valid           ), // <-- fir_valid
    .end_of_frame   (end_of_frame        ), // <-- end_of_frame
    .ch_No          (mua_ch[2]              ), // <-- chNo_to_spkDet
    .ch_unigroup    (ch_unigroup[2]         ),
    .threshold_in   (threshold[2]           ), // <-- threshold
    .v_in           (mua_in[2]            ), // <-- fir_out
    .ch_out         (spkA_ch_out[2]         ),
    .ch_unigroup_out(spkA_ch_unigroup_out[2]),
    .eof_out        (spkA_eof_out[2]        ), // --> end_of_frame
    .valid_out      (spkA_valid_out[2]      ),
    .v_out          (spkA_v_out[2]          ), // --> spkDet_B
    .min_out        (spkA_min_out[2]        ),
    .state_out      (spkA_state_out[2]      ),
    .is_peak_out    (spkA_is_peak[2]        )
  );
  
  spkDet_A #(.NUM_CH(32)) spkDet_A_bank_3 (
    .clk            (bus_clk             ),
    .thr_enable     (spkDet_en           ),
    .valid_in       (mua_comb_valid           ), // <-- fir_valid
    .end_of_frame   (end_of_frame        ), // <-- end_of_frame
    .ch_No          (mua_ch[3]              ), // <-- chNo_to_spkDet
    .ch_unigroup    (ch_unigroup[3]         ),
    .threshold_in   (threshold[3]           ), // <-- threshold
    .v_in           (mua_in[3]            ), // <-- fir_out
    .ch_out         (spkA_ch_out[3]         ),
    .ch_unigroup_out(spkA_ch_unigroup_out[3]),
    .eof_out        (spkA_eof_out[3]        ), // --> end_of_frame
    .valid_out      (spkA_valid_out[3]      ),
    .v_out          (spkA_v_out[3]          ), // --> spkDet_B
    .min_out        (spkA_min_out[3]        ),
    .state_out      (spkA_state_out[3]      ),
    .is_peak_out    (spkA_is_peak[3]        )
  );
  
  spkDet_A #(.NUM_CH(32)) spkDet_A_bank_4 (
    .clk            (bus_clk             ),
    .thr_enable     (spkDet_en           ),
    .valid_in       (mua_comb_valid           ), // <-- fir_valid
    .end_of_frame   (end_of_frame        ), // <-- end_of_frame
    .ch_No          (mua_ch[4]              ), // <-- chNo_to_spkDet
    .ch_unigroup    (ch_unigroup[4]         ),
    .threshold_in   (threshold[4]           ), // <-- threshold
    .v_in           (mua_in[4]            ), // <-- fir_out
    .ch_out         (spkA_ch_out[4]         ),
    .ch_unigroup_out(spkA_ch_unigroup_out[4]),
    .eof_out        (spkA_eof_out[4]        ), // --> end_of_frame
    .valid_out      (spkA_valid_out[4]      ),
    .v_out          (spkA_v_out[4]          ), // --> spkDet_B
    .min_out        (spkA_min_out[4]        ),
    .state_out      (spkA_state_out[4]      ),
    .is_peak_out    (spkA_is_peak[4]        )
  );

endmodule 
