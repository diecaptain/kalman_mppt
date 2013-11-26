library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity kn_kalman_Vactcapofkplusone is
  port
    ( clock              : in std_logic;
      Vactcapdashofkplusone : in std_logic_vector(31 downto 0);
      Vrefofkplusone            : in std_logic_vector(31 downto 0);
      Kofkplusone        : in std_logic_vector(31 downto 0);
      Vactcapofkplusone     : out std_logic_vector(31 downto 0)
    );
  end kn_kalman_Vactcapofkplusone;
architecture struct of kn_kalman_Vactcapofkplusone is
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
	component kn_kalman_add IS
	 PORT
	  ( clock		: IN STD_LOGIC ;
		  dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		  datab		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		  result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	  );
	  end component;
	  signal Z1 : std_logic_vector(31 downto 0);
	  signal Z2 : std_logic_vector(31 downto 0);
	  begin
	    M1 : kn_kalman_sub port map (clock => clock, dataa => Vrefofkplusone, datab => Vactcapdashofkplusone, result => Z1);
	    M2 : kn_kalman_mult port map (clock => clock, dataa => Z1, datab => Kofkplusone, result => Z2); 
	    M3 : kn_kalman_add port map (clock => clock, dataa => Vactcapdashofkplusone, datab => Z2, result => Vactcapofkplusone);
	    end struct;  
	  
