library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Definicja komponentu multipleksera 8:1
ENTITY MUX8 IS
    PORT (
        IN0     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN1     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN2     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN3     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN4     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN5     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN6     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN7     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SEL     : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        DATA_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END MUX8;

ARCHITECTURE Behavioral OF MUX8 IS
BEGIN
    PROCESS (IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7, SEL)
    BEGIN
        CASE SEL IS
            WHEN "000" => DATA_OUT <= IN0;
            WHEN "001" => DATA_OUT <= IN1;
            WHEN "010" => DATA_OUT <= IN2;
            WHEN "011" => DATA_OUT <= IN3;
            WHEN "100" => DATA_OUT <= IN4;
            WHEN "101" => DATA_OUT <= IN5;
            WHEN "110" => DATA_OUT <= IN6;
            WHEN "111" => DATA_OUT <= IN7;
            WHEN OTHERS => DATA_OUT <= (OTHERS => '0');
        END CASE;
    END PROCESS;
END Behavioral;