library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library std;
use std.textio.all;
use ieee.std_logic_textio.all;

entity sw2display_tb is
    generic(T: time := 20 ns);
end entity;

architecture behav of sw2display_tb is
    signal sw : std_logic_vector(9 downto 0) := (others => '0');
    signal hex5, hex4, hex3, hex2, hex1, hex0 : std_logic_vector(6 downto 0);

function reverse(seg : std_logic_vector(6 downto 0)) return std_logic_vector is
    variable rev : std_logic_vector(6 downto 0);
begin
    for i in 0 to 6 loop
        rev(i) := seg(6 - i);
    end loop;
    return rev;
end function;


      function decode_7seg(seg : std_logic_vector(6 downto 0)) return string is
      begin
          case reverse(seg) is
               when "1000000" => return "0";
                when "1111001" => return "1";
                when "0100100" => return "2";
                when "0110000" => return "3";
                when "0011001" => return "4";
	        when "0010010" => return "5";
  	        when "0000010" => return "6";
                when "1111000" => return "7";
                when "0000000" => return "8";
		when "0010000" => return "9";
       		when "0001000" => return "A";
	    	when "0000011" => return "b";
        	when "1000110" => return "C";
                when "0100001" => return "d";
        	when "0000110" => return "E";
        	when "0001110" => return "F";
	        when others    => return "?";
           end case;
    	end function;

begin

    	uut: entity work.sw2display
        port map (
            sw   => sw,
            hex5 => hex5,
            hex4 => hex4,
            hex3 => hex3,
            hex2 => hex2,
            hex1 => hex1,
            hex0 => hex0
        );


	stim_proc: process
    	variable disp : integer;
    	variable j_start : integer;
        variable L : line;
	begin
    		for i in 0 to 5 loop
        		disp := 2 ** i;
        		sw(5 downto 0) <= std_logic_vector(to_unsigned(disp, 6));
        		j_start := i * 2;
       	 		for j in j_start to j_start + 2 loop
            			sw(9 downto 6) <= std_logic_vector(to_unsigned(j, 4));
				wait for T;
                		-- Print test number
                		write(L, string'("Test: i="));
                		write(L, i);
                		write(L, string'(", j="));
             			write(L, j);
                		writeline(output, L);

                		-- Print sw(9 downto 6) in hex
                		write(L, string'("  sw(9 downto 6) = 0x"));
                		hwrite(L, sw(9 downto 6));
                		writeline(output, L);

                		-- Print sw(5 downto 0) as selected bit index
                		write(L, string'("  sw(5 downto 0) active bit = "));
                		write(L, integer'image(i));
                		writeline(output, L);

                		-- Print hex display values
                		-- Print decoded display output
				write(L, string'("  hex5 = " & decode_7seg(hex5)));  writeline(output, L);
				write(L, string'("  hex4 = " & decode_7seg(hex4))); writeline(output, L);
				write(L, string'("  hex3 = " & decode_7seg(hex3))); writeline(output, L);
				write(L, string'("  hex2 = " & decode_7seg(hex2))); writeline(output, L);
				write(L, string'("  hex1 = " & decode_7seg(hex1))); writeline(output, L);
				write(L, string'("  hex0 = " & decode_7seg(hex0))); writeline(output, L);

        		end loop;
    		end loop;
	end process;
end architecture;

