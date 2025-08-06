module text_switch_vga(
    input wire clk,        // 25MHz
    input wire rst_n,      // リセット
    input wire btn,        // ボタン入力
    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b,
    output wire vga_hs,
    output wire vga_vs
);
    wire [9:0] h_addr, v_addr;
    wire valid;

    vga_sync vga_sync_inst(
        .clk(clk),
        .rst_n(rst_n),
        .h_addr(h_addr),
        .v_addr(v_addr),
        .hs(vga_hs),
        .vs(vga_vs),
        .valid(valid)
    );

    reg [1:0] msg_idx = 0;
    // ボタンの立ち上がり検出
    reg btn_ff0, btn_ff1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_ff0 <= 0;
            btn_ff1 <= 0;
        end else begin
            btn_ff0 <= btn;
            btn_ff1 <= btn_ff0;
        end
    end
    wire btn_rising = btn_ff0 & ~btn_ff1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) msg_idx <= 0;
        else if (btn_rising) msg_idx <= msg_idx + 1'b1;
    end

    wire [7:0] char_code;
    text_rom rom_inst(
        .msg_idx(msg_idx),
        .h_addr(h_addr),
        .v_addr(v_addr),
        .char_code(char_code)
    );

    wire pixel_on;
    font_renderer font_inst(
        .char_code(char_code),
        .h_addr(h_addr),
        .v_addr(v_addr),
        .pixel_on(pixel_on)
    );

    assign {vga_r, vga_g, vga_b} = (valid && pixel_on) ? 12'hFFF : 12'h000;
endmodule
