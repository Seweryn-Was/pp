-----------------------------------------------------------------------
-- VHDL lab1
-- struct test
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library work;

entity sw2display is
  port(sw: in std_logic_vector(9 downto 0);
       hex5, hex4, hex3, hex2, hex1, hex0: out std_logic_vector(6 downto 0));
end entity;

architecture struct of sw2display is

    -- Bezpo?rednie u?ycie komponentów z biblioteki work
    use work.all;

  signal demux_out0, demux_out1, demux_out2, demux_out3, demux_out4, demux_out5 : std_logic_vector(3 downto 0);

  signal decoded_digit0, decoded_digit1, decoded_digit2, decoded_digit3, decoded_digit4, decoded_digit5 : std_logic_vector(6 downto 0);
    signal selected_display : std_logic_vector(3 downto 0);

begin

    dec_inst: entity work.dec7seg port map (
        bcd => demux_out0,
        seg => decoded_digit0
    );
    dec_inst1: entity work.dec7seg port map (
        bcd => demux_out1,
        seg => decoded_digit1
    );
    dec_inst2: entity work.dec7seg port map (
        bcd => demux_out2,
        seg => decoded_digit2
    );
    dec_inst3: entity work.dec7seg port map (
        bcd => demux_out3,
        seg => decoded_digit3
    );
    dec_inst4: entity work.dec7seg port map (
        bcd => demux_out4,
        seg => decoded_digit4
    );

    dec_inst5: entity work.dec7seg port map (
        bcd => demux_out5,
        seg => decoded_digit5
    );
	
	decoder: entity work.encoder port map(
	s => "0000" & sw(5 downto 0), y => selected_display
	);

    demux: entity work.demux6x1 port map (
	d => sw(9 downto 6), 
	s0 =>selected_display(0), s1 => selected_display(1), s2 => selected_display(2),
	y0 => demux_out0, 
	y1 => demux_out1, 
	y2 => demux_out2, 
	y3 => demux_out3, 
	y4 => demux_out4, 
	y5 => demux_out5
	);
	
hex0 <= decoded_digit0; 
hex1 <= decoded_digit1;
hex2 <= decoded_digit2;
hex3 <= decoded_digit3;
hex4 <= decoded_digit4;
hex5 <= decoded_digit5;
    
end architecture struct;