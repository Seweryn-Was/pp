library IEEE;
  use IEEE.std_logic_1164.all;
library bramki;
    
entity test is
  port(a: in std_logic;
       b: in std_logic;
       c: in std_logic;       
       d: in std_logic;       
       y: out std_logic);
end test;

architecture struct of test is
  signal y1_i, y2_i : std_logic;
    
    begin
        and_1: entity bramki.and2
        port map(a,b,y1_i);
          
        and_2: entity bramki.and2
        port map(c,y1_i,y2_i);

        and_3: entity bramki.and2
        port map(d,y2_i,y);
              
    end struct;