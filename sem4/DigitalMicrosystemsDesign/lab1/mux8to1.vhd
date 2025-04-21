
--------------------------------------------------------------------------------
-- lab VHDL
-- multiplexer 8x1
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mux8x1 is
	port (d0,d1,d2,d3, d4, d5, d6, d7: in std_logic;
        s0,s1, s2: in std_logic;
		y: out std_logic	);
end entity mux8x1;

architecture behav of mux8x1 is
--signal sel : std_logic_vector(2 downto 0); 
signal out1, out2 : std_logic; 
begin
	/*sel(0) <= s0; 
	sel(1) <= s1; 
	sel(2) <= s2; 
	process(d0, d1, d2, d3, d4, d5, d6, d7, sel)
	begin 
		case (sel) is
			when "000" => y <= d0; 
			when "001" => y <= d1; 
			when "010" => y <= d2; 
			when "011" => y <= d3; 
			when "100" => y <= d4; 
			when "101" => y <= d5; 
			when "110" => y <= d6; 
			when "111" => y <= d7;
			when others => y <= '0'; 
		end case; 
	end process; */ 
	mux1: entity work.mux4x1 port map(
		d0 => d0, d1 => d1, d2=>d2, d3=>d3, 
		s0 => s0, s1=>s1, y => out1
	); 

	mux2: entity work.mux4x1 port map(
		d0 => d4, d1 => d5, d2=>d6, d3=>d7, 
		s0 => s0, s1=>s1, y => out2
	); 

	mux3: entity work.mux4x1 port map(
		d0 => out1, d1 => out2, d2=> '0', d3=>'0', 
		s0 => s2, s1=> '0', y => y
	); 

end architecture behav;
--------------------------------------------------------------------------------