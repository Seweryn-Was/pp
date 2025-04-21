 -- IMPLEMENTACJA TRANSKODERA
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY char7seg IS
	PORT ( 
		C : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END char7seg;

ARCHITECTURE strukturalna OF char7seg IS
	BEGIN
	-- . . . do uzupełnienia opis struktury za pomocą równań boolowskich specyfikowanych zgodnie z zasadami języka VHDL
	Display(0) <= NOT(C(1) OR (NOT C(2) AND C(0)) OR ( C(2) AND NOT C(1) AND NOT C(0))); 
 	Display(1) <= NOT(C(2) AND C(0)); 
	Display(2) <= NOT C(2); 
	Display(3) <= NOT((C(1) AND NOT C(0)) OR (C(2) AND NOT C(0)) OR ( NOT C(2) AND NOT C(1) AND C(0))); 
	Display(4) <= NOT(C(0) OR C(1) OR C(2)); 
	Display(5) <= NOT(C(0) OR C(1) OR C(2)); 
	Display(6) <= NOT(C(1) OR C(2)); 
	 
	END strukturalna; 
