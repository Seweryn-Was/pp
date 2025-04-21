-- Komponent multipleksera 2:1 (16-bitowego)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Definicja komponentu multipleksera 2:1
ENTITY MUX2 IS
    PORT (
        IN0     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN1     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SEL     : IN STD_LOGIC;
        DATA_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END MUX2;

ARCHITECTURE Behavioral OF MUX2 IS
BEGIN
    PROCESS (IN0, IN1, SEL)
    BEGIN
        IF SEL = '0' THEN
            DATA_OUT <= IN0;
        ELSE
            DATA_OUT <= IN1;
        END IF;
    END PROCESS;
END Behavioral;

