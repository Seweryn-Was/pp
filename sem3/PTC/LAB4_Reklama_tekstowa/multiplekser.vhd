
-- implementacja multipleksera 8 do 1 (wektor 3 bitowy)
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux3bit8to1 IS
	PORT ( 
		S, U0, U1, U2, U3, U4, U5,U6,U7: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		M : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
END mux3bit8to1;

ARCHITECTURE strukturalna OF mux3bit8to1 IS
	BEGIN
	 -- . . . do uzupełnienia opis struktury za pomocą równań boolowskich specyfikowanych zgodnie z zasadami języka VHDL
		PROCESS(S, U0, U1, U2, U3, U4, U5,U6,U7)
			 BEGIN
				  CASE S IS
						WHEN "000" => M <= U0; -- Wybór U0
						WHEN "001" => M <= U1; -- Wybór U1
						WHEN "011" => M <= U2; -- Wybór U2
						WHEN "010" => M <= U3; -- Wybór U3
						WHEN "110" => M <= U4; -- Wybór U4
						WHEN "111" => M <= U5;
						WHEN "101" => M <= U6;
						WHEN "100" => M <= U7;
						WHEN OTHERS => M <= (OTHERS => '0'); -- Domyślnie: wyłącz
			  END CASE;
		END PROCESS;
	END strukturalna;

	