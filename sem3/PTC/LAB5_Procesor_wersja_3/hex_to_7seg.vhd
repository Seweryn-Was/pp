library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex_to_7seg is
    Port (
        binary_in : in  STD_LOGIC_VECTOR (3 downto 0); 
        seg_out   : out STD_LOGIC_VECTOR (6 downto 0)
    );
end hex_to_7seg;

architecture Behavioral of hex_to_7seg is
begin
    process(binary_in)
    begin
        case binary_in is
            when "0000" => seg_out <= "1000000"; -- 0
            when "0001" => seg_out <= "1111001"; -- 1
            when "0010" => seg_out <= "0100100"; -- 2
            when "0011" => seg_out <= "0110000"; -- 3
            when "0100" => seg_out <= "0011001"; -- 4
            when "0101" => seg_out <= "0010010"; -- 5
            when "0110" => seg_out <= "0000010"; -- 6
            when "0111" => seg_out <= "1111000"; -- 7
            when "1000" => seg_out <= "0000000"; -- 8
            when "1001" => seg_out <= "0010000"; -- 9
            when "1010" => seg_out <= "0001000"; -- A
            when "1011" => seg_out <= "0000011"; -- B
            when "1100" => seg_out <= "1000110"; -- C
            when "1101" => seg_out <= "0100001"; -- D
            when "1110" => seg_out <= "0000110"; -- E
            when "1111" => seg_out <= "0001110"; -- F
            when others => seg_out <= "1111111"; -- off
        end case;
    end process;

end Behavioral;
