module font_rom(
    input [7:0] char_code,
    input [3:0] row,
    output reg [7:0] font_line
);
    always @* begin
        case(char_code)
            "A": case(row)
                0: font_line=8'b00011000;
                1: font_line=8'b00100100;
                2: font_line=8'b01000010;
                3: font_line=8'b01000010;
                4: font_line=8'b01111110;
                5: font_line=8'b01000010;
                6: font_line=8'b01000010;
                7: font_line=8'b00000000;
                default: font_line=8'b00000000;
            endcase
            // 他の文字は略（自作拡張推奨）
            default: font_line=8'b00000000;
        endcase
    end
endmodule
