--------------------------------------------------------------------------------
-- lab VHDL
-- Demultiplexer 6 do 1 using 4x1 multiplexers
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity demux6x1 is
    port (
        d : in std_logic_vector(3 downto 0);           -- Wej?cie
        s0, s1, s2 : in std_logic;  -- Sygna?y steruj?ce
        y0, y1, y2, y3, y4, y5: out std_logic_vector(3 downto 0) -- Wyj?cia
    );
end entity demux6x1;

architecture behav of demux6x1 is
begin
	
mux8x1Inst1 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => d(0), d1 => '0', d2 => '0' , d3 => '0', 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y0(0)
); 

mux8x1Inst2 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => d(1), d1 => '0', d2 => '0' , d3 => '0', 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y0(1)
);

mux8x1Inst3 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => d(2), d1 => '0', d2 => '0' , d3 => '0', 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y0(2)
); 

mux8x1Inst4 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => d(3), d1 => '0', d2 => '0' , d3 => '0', 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y0(3)
);

--wyjscie dla HEX2 

mux8x1Inst5 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => d(0), d2 => '0' , d3 => '0', 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y1(0)
); 

mux8x1Inst6 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => d(1), d2 => '0' , d3 => '0', 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y1(1)
);

mux8x1Inst7 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => d(2), d2 => '0' , d3 => '0', 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y1(2)
); 

mux8x1Inst8 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => d(3), d2 => '0' , d3 => '0', 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y1(3)
);

		
--wyjscie dla HEX3

mux8x1Inst9 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => d(0) , d3 => '0', 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y2(0)
); 

mux8x1Inst10 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => d(1) , d3 => '0', 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y2(1)
);

mux8x1Inst11 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => d(2) , d3 => '0', 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y2(2)
); 

mux8x1Inst12 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => d(3) , d3 => '0', 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y2(3)
);

--wyjscie dla HEX4

mux8x1Inst13 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => '0', d3 => d(0), 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y3(0)
); 

mux8x1Inst14 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => '0' , d3 => d(1), 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y3(1)
);

mux8x1Inst15 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => '0' , d3 => d(2), 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y3(2)
); 

mux8x1Inst16 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => '0' , d3 => d(3), 
	d4 => '0', d5 => '0', d6 => '0', d7 => '0', 
	y => y3(3)
);

--wyjscie dla HEX5

mux8x1Inst17 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => '0', d3 => '0', 
	d4 => d(0), d5 => '0', d6 => '0', d7 => '0', 
	y => y4(0)
); 

mux8x1Inst18 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => '0' , d3 => '0', 
	d4 => d(1), d5 => '0', d6 => '0', d7 => '0', 
	y => y4(1)
);

mux8x1Inst19 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => '0' , d3 => '0', 
	d4 => d(2), d5 => '0', d6 => '0', d7 => '0', 
	y => y4(2)
); 

mux8x1Inst20 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => '0' , d3 => '0', 
	d4 => d(3), d5 => '0', d6 => '0', d7 => '0', 
	y => y4(3)
);

--  wyjesice dla HEX6 

mux8x1Inst21 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => '0', d3 => '0', 
	d4 => '0', d5 => d(0), d6 => '0', d7 => '0', 
	y => y5(0)
); 

mux8x1Inst22 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => '0' , d3 => '0', 
	d4 => '0', d5 => d(1), d6 => '0', d7 => '0', 
	y => y5(1)
);

mux8x1Inst23 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => '0' , d3 => '0', 
	d4 => '0', d5 => d(2), d6 => '0', d7 => '0', 
	y => y5(2)
); 

mux8x1Inst24 : entity work.mux8x1 port map(
	s0 => s0, s1 => s1, s2 => s2, 
	d0 => '0', d1 => '0', d2 => '0' , d3 => '0', 
	d4 => '0', d5 => d(3), d6 => '0', d7 => '0', 
	y => y5(3)
);


  end architecture behav;
