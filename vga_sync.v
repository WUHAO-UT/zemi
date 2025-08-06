module vga_sync(
    input wire clk,        // 25MHz クロック
    input wire rst_n,      // 非同期リセット（低有効）
    output reg [9:0] h_addr, // 現在の水平座標
    output reg [9:0] v_addr, // 現在の垂直座標
    output reg hs,         // 水平同期信号
    output reg vs,         // 垂直同期信号
    output reg valid       // 表示エリア判定
);
    parameter H_SYNC = 96, H_BACK = 48, H_DISP = 640, H_FRONT = 16, H_TOTAL = 800;
    parameter V_SYNC = 2,  V_BACK = 33, V_DISP = 480, V_FRONT = 10, V_TOTAL = 525;

    reg [9:0] h_cnt, v_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            h_cnt <= 0; v_cnt <= 0;
        end else if (h_cnt == H_TOTAL - 1) begin
            h_cnt <= 0;
            if (v_cnt == V_TOTAL - 1) v_cnt <= 0;
            else v_cnt <= v_cnt + 1;
        end else begin
            h_cnt <= h_cnt + 1;
        end
    end

    always @* begin
        hs = (h_cnt < H_SYNC) ? 0 : 1;
        vs = (v_cnt < V_SYNC) ? 0 : 1;
        h_addr = (h_cnt >= H_SYNC + H_BACK && h_cnt < H_SYNC + H_BACK + H_DISP) ? h_cnt - (H_SYNC + H_BACK) : 10'd0;
        v_addr = (v_cnt >= V_SYNC + V_BACK && v_cnt < V_SYNC + V_BACK + V_DISP) ? v_cnt - (V_SYNC + V_BACK) : 10'd0;
        valid = (h_cnt >= H_SYNC + H_BACK && h_cnt < H_SYNC + H_BACK + H_DISP &&
                 v_cnt >= V_SYNC + V_BACK && v_cnt < V_SYNC + V_BACK + V_DISP);
    end
endmodule
