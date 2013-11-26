library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity demux is
port ( clock : in std_logic;
       prod : in std_logic_vector (31 downto 0);
		   Z0 : in std_logic;
		   Z1 : in std_logic;
		   Z2 : in std_logic;
		   Z3 : in std_logic;
       a : out std_logic_vector (7 downto 0));
end demux;
architecture dataf of demux is
signal S0 : std_logic;
signal S1 : std_logic;
begin
process (prod,S0,S1,Z0,Z1,Z2,Z3)
begin
if S0 = '0' then
  if S1 = '0' then
     if Z0 = '0' then
     a <= prod(31 downto 24);
	  end if;
	  else
	  if Z1 = '0' then
	  a <= prod(23 downto 16);
	  end if;
	 end if;
else
  if S1 = '0' then
     if Z2 = '0' then
     a <= prod(15 downto 8);
	  end if;
	  else
	  if Z3 = '0' then
	  a <= prod(7 downto 0);
	  end if;
	 end if;
end if;
end process;
end dataf;