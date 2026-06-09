module AXI_RGB_LED #(
  parameter int NUM_LEDS = 1
  )
  (
    // AVALON MM Interface
    input wire i_clock
  , input wire i_reset_n
  , input wire [7:0] i_address
  , input wire i_chip_select
  , input wire [31:0] i_write_data
  , output wire [31:0] o_read_data

  , output reg o_led_serial);

  localparam int RGB_VALUE_ADDR = 8'h00;
  reg [23:0] rgb_value;

  always_ff @(posedge i_clock) begin
    if (!i_reset_n) begin
      rgb_value <= {24{1'b0}};
    end
    else begin
      if (i_chip_select) begin
        if (i_write_n) begin
          casez (i_address)
            RGB_VALUE_ADDR: o_read_data <= {{32 - 24{1'b0}}, rgb_value};
            default:
              o_read_data <= 32'hCAFEBABE;
          endcase
        end
        else begin
          casez (i_address)
            RGB_VALUE_ADDR: rgb_value <= i_write_data[23:0];
            default:;
          endcase
        end
      end
    end
  end
endmodule
