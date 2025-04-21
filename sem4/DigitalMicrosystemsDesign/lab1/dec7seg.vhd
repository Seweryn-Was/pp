library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dec7seg is
    Port ( bcd : in std_logic_vector(3 downto 0);
           seg : out std_logic_vector(6 downto 0));
end entity dec7seg;

architecture behav of dec7seg is

begin

process (bcd)
    begin
        case bcd is			     -- num|hex
            when "0000" => seg <= "0000001"; -- 0 01
            when "0001" => seg <= "1001111"; -- 1 4F
            when "0010" => seg <= "0010010"; -- 2 12 
            when "0011" => seg <= "0000110"; -- 3 06
            when "0100" => seg <= "1001100"; -- 4 4C
            when "0101" => seg <= "0100100"; -- 5 24
            when "0110" => seg <= "0100000"; -- 6 20
            when "0111" => seg <= "0001111"; -- 7 0F
            when "1000" => seg <= "0000000"; -- 8 00
            when "1001" => seg <= "0000100"; -- 9 04
            when "1010" => seg <= "0001000"; -- A 08
            when "1011" => seg <= "1100000"; -- B 60
            when "1100" => seg <= "0110001"; -- C 31
            when "1101" => seg <= "1000010"; -- D 42
            when "1110" => seg <= "0110000"; -- E 30 
            when "1111" => seg <= "0111000"; -- F 38
            when others => seg <= "1111111"; -- Blank
        end case;
    end process;

end architecture behav;