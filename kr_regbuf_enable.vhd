library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity kr_regbuf_enable is
  port ( clock,reset,load : in std_logic;
         I : in std_logic_vector (31 downto 0);
         Y : out std_logic_vector (31 downto 0);
         enable : out std_logic );
       end kr_regbuf_enable;
architecture behav of kr_regbuf_enable is
  begin
    process ( clock, reset, load, I)
      begin
        if (reset = '1') then
          Y <= "00000000000000000000000000000000";
          enable <= '0';
        elsif (clock'event and clock = '1') then
          if (load = '1') then
            Y <= I;
            enable <= '1';
          end if;
        end if;
      end process;
    end behav;

