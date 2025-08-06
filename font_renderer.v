module font_renderer(
    input [7:0] char_code,
    input [9:0] h_addr, v_addr,
    output pixel_on
);
    wire [3:0] row = v_addr % 16;
    wire [2:0] col = h_addr % 8;
    wire [7:0] font_line;

    font_rom font_rom_inst(
        .char_code(char_code),
        .row(row),
        .font_line(font_line)
    );

    assign pixel_on = font_line[7-col];
endmodule
