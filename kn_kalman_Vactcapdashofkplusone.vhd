library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity kn_kalman_Vactcapdashofkplusone is
  port
   ( clock      : in std_logic;
     Vactcapofk : in std_logic_vector(31 downto 0);
     M          : in std_logic_vector(31 downto 0);
     Uofk       : in std_logic_vector(31 downto 0);
     Vactcapdashofkplusone : out std_logic_vector(31 downto 0)
     );
   end kn_kalman_Vactcapdashofkplusone;
architecture struct of kn_kalman_Vactcapdashofkplusone is
  component kn_kalman_add IS
	 PORT
	  ( clock		: IN STD_LOGIC ;
		  dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		  datab		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		  result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	  );
	  end component;
	 component kn_kalman_mult IS
	 PORT
	  ( clock		: IN STD_LOGIC ;
		  dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		  datab		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		  result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	  );
	  end component;
	  signal Z : std_logic_vector(31 downto 0);
	  begin
	    M1 : kn_kalman_mult port map (clock => clock, dataa => M, datab => Uofk, result => Z);
	    M2 : kn_kalman_add port map (clock => clock, dataa => Vactcapofk, datab => Z, result => Vactcapdashofkplusone);
	      end struct;
	  