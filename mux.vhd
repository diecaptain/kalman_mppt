library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;
entity mux is
 port (  clock       : in std_logic;
     a           : in std_logic_vector(31 downto 0);
     b           : in std_logic_vector(31 downto 0);
     Z           : in std_logic;
     prod        : out std_logic_vector(31 downto 0));
       end mux;
architecture behav of mux is
    begin
    process (z,a,b)
      begin
      if z = '0' then
        prod <= a;
      elsif z = '1' then
        prod <= b;
      end if;
    end process;
  end behav;
