library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity kn_kalman_Pdashofkplusone is
  port
    ( clock   : in std_logic;
      Pofk    : in std_logic_vector(31 downto 0);
      Q       : in std_logic_vector(31 downto 0);
      Pdashofkplusone : out std_logic_vector(31 downto 0)
    );
  end kn_kalman_Pdashofkplusone;
architecture struct of kn_kalman_Pdashofkplusone is
  component kn_kalman_add IS
	 PORT
	  ( clock		: IN STD_LOGIC ;
		  dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		  datab		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		  result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	  );
	  end component;
	 begin
	   M1 : kn_kalman_add port map (clock => clock, dataa => Pofk, datab => Q, result => Pdashofkplusone);
	     end struct;
