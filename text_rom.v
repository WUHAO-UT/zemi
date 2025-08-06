module text_rom(
    input [1:0] msg_idx,         // 表示メッセージ番号
    input [9:0] h_addr, v_addr,  // 現在ピクセル座標
    output reg [7:0] char_code   // 出力する文字コード
);
    localparam X0 = 272; // 中央（640x480で16文字表示の場合）
    localparam Y0 = 224;

    reg [7:0] msg0 [0:15];
    reg [7:0] msg1 [0:15];

    initial begin
        msg0 = {"HELLO, FPGA!!! "}; // 16文字
        msg1 = {"PUSH BUTTON DEMO"};
    end

    reg [3:0] x;

    always @* begin
        char_code = 8'd32; // デフォルトは空白
        if (h_addr >= X0 && h_addr < X0+8*16 && v_addr >= Y0 && v_addr < Y0+16) begin
            x = (h_addr-X0)/8;
            case (msg_idx)
                2'd0: char_code = msg0[x];
                2'd1: char_code = msg1[x];
                default: char_code = 8'd32;
            endcase
        end
    end
endmodule
