library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity kn_kalman_Kofkplusone is
  port
    ( clock           : in std_logic;
      Pdashofkplusone : in std_logic_vector(31 downto 0);
      R               : in std_logic_vector(31 downto 0);
      Kofkplusone     : out std_logic_vector(31 downto 0)
    );
  end kn_kalman_Kofkplusone;
architecture struct of kn_kalman_Kofkplusone is
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
	  component kn_kalman_inv IS
	PORT
	( clock		: IN STD_LOGIC ;
		data		 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component;
	signal Z1 : std_logic_vector(31 downto 0);
	signal Z2 : std_logic_vector(31 downto 0);
	begin
	  M1 : kn_kalman_add port map (clock => clock, dataa => Pdashofkplusone, datab => R, result => Z1);
	  M2 : kn_kalman_inv port map (clock => clock, data => Z1, result => Z2);
	  M3 : kn_kalman_mult port map (clock => clock, dataa => Pdashofkplusone, datab => Z2, result => Kofkplusone);
	  end struct; 
	
  
