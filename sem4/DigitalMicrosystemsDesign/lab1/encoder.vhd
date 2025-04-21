--------------------------------------------------------------------------------
-- lab VHDL
-- encoder 10b
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity encoder is
  generic (delay: time := 3 ns);
  port (s: in std_logic_vector(9 downto 0); 
		y: out std_logic_vector(3 downto 0) );
end entity encoder;

architecture with_delay of encoder is
	signal y_tmp: std_logic_vector(y'range);
begin
y <= y_tmp after delay;
p_enc : process (s) begin
	case s is
		when b"00_0000_0001" => y_tmp <= x"0";
		when b"00_0000_0010" => y_tmp <= x"1";
		when b"00_0000_0100" => y_tmp <= x"2";
		when b"00_0000_1000" => y_tmp <= x"3";
		when b"00_0001_0000" => y_tmp <= x"4";
		when b"00_0010_0000" => y_tmp <= x"5";
		when b"00_0100_0000" => y_tmp <= x"6";
		when b"00_1000_0000" => y_tmp <= x"7";
		when b"01_0000_0000" => y_tmp <= x"8";
		when b"10_0000_0000" => y_tmp <= x"9";
		when others => y_tmp <= x"0";		
	end case;
end process;

end architecture with_delay;
