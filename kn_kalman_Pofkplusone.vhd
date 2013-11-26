library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity kn_kalman_Pofkplusone is
  port
    ( clock            : in std_logic;
      Pdashofkplusone  : in std_logic_vector(31 downto 0);
      Kofkplusone      : in std_logic_vector(31 downto 0);
      Pofkplusone      : out std_logic_vector(31 downto 0)
    );
  end kn_kalman_Pofkplusone;
architecture struct of kn_kalman_Pofkplusone is
  component kn_kalman_mult IS
	 PORT
	  ( clock		: IN STD_LOGIC ;
		  dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		  datab		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		  result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	  );
	  end component;
	 component kn_kalman_sub IS
	PORT
	( clock		: IN STD_LOGIC ;
		dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component;
	signal Z : std_logic_vector(31 downto 0);
	begin
	  M1 : kn_kalman_mult port map (clock => clock, dataa => Pdashofkplusone, datab => Kofkplusone, result => Z);
	  M2 : kn_kalman_sub port map (clock => clock, dataa => Pdashofkplusone, datab => Z, result => Pofkplusone);
	  end struct;  
	
      