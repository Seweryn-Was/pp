--------------------------------------------------------------------------------
-- lab VHDL
-- multiplexer 4x1
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mux4x1 is
	port (d0,d1,d2,d3: in std_logic;
        s0,s1: in std_logic;
		y: out std_logic	);
end entity mux4x1;

architecture behav of mux4x1 is

begin
	process(d0, d1, d2, d3, s0, s1)
	begin 
		case (s1 & s0) is
			when "00" => y <= d0; 
			when "01" => y <= d1; 
			when "10" => y <= d2; 
			when "11" => y <= d3; 
			when others => y <= '0'; 
		end case; 
	end process; 
end architecture behav;
--------------------------------------------------------------------------------
