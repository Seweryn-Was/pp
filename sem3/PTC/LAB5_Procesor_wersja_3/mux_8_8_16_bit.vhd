LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Mux8to1 IS
    PORT (
        IN_0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN_1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN_3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN_4 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN_5 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN_6 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN_7 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  IN_8 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SEL  : IN STD_LOGIC_VECTOR(8 DOWNTO 0);       
        MUX_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Mux8to1;

ARCHITECTURE Behavior OF Mux8to1 IS
BEGIN
    PROCESS (SEL, IN_0, IN_1, IN_2, IN_3, IN_4, IN_5, IN_6, IN_7, IN_8)
    BEGIN
        CASE SEL IS
            WHEN "000000001" => MUX_OUT <= IN_0;
            WHEN "000000010" => MUX_OUT <= IN_1;
            WHEN "000000100" => MUX_OUT <= IN_2;
            WHEN "000001000" => MUX_OUT <= IN_3;
            WHEN "000010000" => MUX_OUT <= IN_4;
            WHEN "000100000" => MUX_OUT <= IN_5;
            WHEN "001000000" => MUX_OUT <= IN_6;
            WHEN "010000000" => MUX_OUT <= IN_7;
				WHEN "100000000" => MUX_OUT <= IN_8;
            WHEN OTHERS => MUX_OUT <= (OTHERS => '0');  -- Bezpieczne domyślne wyjście
        END CASE;
    END PROCESS;
END Behavior;
