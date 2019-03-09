library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity kn_kalman_final_fpga is
  port
    ( clock                  : in std_logic;
      Uofk                   : in std_logic_vector(31 downto 0);
      Vrefofkplusone         : in std_logic_vector(31 downto 0);
      Z0                     : in std_logic;
		Z1                     : in std_logic;
		Z2                     : in std_logic;
		Z3                     : in std_logic;
	   S0                     : in std_logic;
      S1                     : in std_logic;
		S2                     : in std_logic;
		  Vrefofkplusone_mux_sel       : in std_logic;
		  Vrefofkplusone_sel           : in std_logic;
		  Vrefofkplusone_reset         : in std_logic;
		  Vactcapofk_mux_sel    : in std_logic;
		  Vactcapofk_sel        : in std_logic;
		  Vactcapofk_reset      : in std_logic;
		  Pofk_mux_sel       : in std_logic;
		  Pofk_sel           : in std_logic;
		  Pofk_reset         : in std_logic;
		  Uofk_mux_sel       : in std_logic;
		  Uofk_sel           : in std_logic;
		  Uofk_reset         : in std_logic;
		  Vactcapofkplusone_sel        : in std_logic;
		  Vactcapofkplusone_reset      : in std_logic;
		  Pofkplusone_sel           : in std_logic;
		  Pofkplusone_reset         : in std_logic;
		  Vactcapofkplusone_enable    : out std_logic;
		  Pofkplusone_enable            : out std_logic;
      Sout                   : out std_logic_vector(7 downto 0)
      );
    end kn_kalman_final_fpga;
  architecture struct of kn_kalman_final_fpga is
    component kn_kalman_final is
     port
       ( clock                  : in std_logic;
         Uofk                   : in std_logic_vector(31 downto 0);
         Vrefofkplusone         : in std_logic_vector(31 downto 0);
         Vactcapofk_mux_sel    : in std_logic;
		  Vactcapofk_sel        : in std_logic;
		  Vactcapofk_reset      : in std_logic;
		  Pofk_mux_sel       : in std_logic;
		  Pofk_sel           : in std_logic;
		  Pofk_reset         : in std_logic;
		  Vactcapofkplusone_sel        : in std_logic;
		  Vactcapofkplusone_reset      : in std_logic;
		  Pofkplusone_sel           : in std_logic;
		  Pofkplusone_reset         : in std_logic;
			Pofkplusone            : out std_logic_vector(31 downto 0);
         Vactcapofkplusone      : out std_logic_vector(31 downto 0);
        Vactcapofkplusone_enable    : out std_logic;
		  Pofkplusone_enable            : out std_logic
		  );
      end component;
      component demux is
        port 
          ( clock : in std_logic;
            prod : in std_logic_vector (31 downto 0);
		        Z0 : in std_logic;
		        Z1 : in std_logic;
		        Z2 : in std_logic;
		        Z3 : in std_logic;
			     S0 : in std_logic;
              S1 : in std_logic;
               a : out std_logic_vector (7 downto 0)
            );
          end component;
			 component mux is
			   port 
              ( clock       : in std_logic;
                a           : in std_logic_vector(31 downto 0);
	             b           : in std_logic_vector(31 downto 0);
	             Z           : in std_logic;
	             prod        : out std_logic_vector(31 downto 0));
					 end component;
					 component kr_regbuf is
          port ( clock,reset,load : in std_logic;
                 I                : in std_logic_vector (31 downto 0);
                 Y                : out std_logic_vector (31 downto 0) );
               end component;
          signal V :  std_logic_vector(31 downto 0);
			 signal N :  std_logic_vector(31 downto 0);
			 signal J :  std_logic_vector(31 downto 0);
			 signal K1,K2 :  std_logic_vector(31 downto 0);
			 signal H1,H2 :  std_logic_vector(31 downto 0);
			 signal Vrefofkplusone_initial : std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
			 signal Uofk_initial : std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
			 --signal I1 : std_logic_vector(31 downto 0) := "01000001101000000011110000101001";
			 --signal I2 : std_logic_vector(31 downto 0) := "00111011000000110001001001101111";
			 --signal I3 : std_logic_vector(31 downto 0) := "01000000101001110101110000101001";
			 --signal I4 : std_logic_vector(31 downto 0) := "00111010011110101010101101000110";
			 --signal I5 : std_logic_vector(31 downto 0) := "00111000110100011011011100010111";
			 --signal I6 : std_logic_vector(31 downto 0) := "00111100001000111101011100001010";
			 --signal I7 : std_logic_vector(31 downto 0) := "01000001100110111000010100011111";
        begin
		       M1 : mux
			 	 port map
			 	     ( clock => clock,
			 	       a => Vrefofkplusone_initial,
			 	       b => Vrefofkplusone,
			 	       z => Vrefofkplusone_mux_sel,
			 	       prod => H1); 
			   M2 : kr_regbuf
			   port map
			       ( clock => clock,
			         reset => Vrefofkplusone_reset,
			         load => Vrefofkplusone_sel,
			         I => H1,
			         Y => K1 );
				M3 : mux
			 	 port map
			 	     ( clock => clock,
			 	       a => Uofk_initial,
			 	       b => Uofk,
			 	       z => Uofk_mux_sel,
			 	       prod => H2); 
			   M4 : kr_regbuf
			   port map
			       ( clock => clock,
			         reset => Uofk_reset,
			         load => Uofk_sel,
			         I => H2,
			         Y => K2 );
             M5 : kn_kalman_final 
              port map
                ( clock => clock,
                  Uofk => K2,
                  Vrefofkplusone => K1,
                  Vactcapofk_mux_sel => Pofk_mux_sel,   
		            Vactcapofk_sel => Pofk_sel,       
		            Vactcapofk_reset => Pofk_reset,      
		            Pofk_mux_sel => Pofk_mux_sel,       
		            Pofk_sel =>Pofk_sel,           
		            Pofk_reset => Pofk_reset,         
		            Vactcapofkplusone_sel => Vactcapofkplusone_sel,        
		            Vactcapofkplusone_reset => Vactcapofkplusone_reset,     
		            Pofkplusone_sel => Pofkplusone_sel,          
		            Pofkplusone_reset => Pofkplusone_reset,        
			         Pofkplusone => N,
			         Vactcapofkplusone  => V,
					   Vactcapofkplusone_enable => Vactcapofkplusone_enable,
					   Pofkplusone_enable => Pofkplusone_enable);
				  M6 : mux
				   port map
					  ( clock => clock,
					     a => V,
						  b => N,
						  Z => S2,
						  prod => J);
              M7 : demux
               port map
                 ( clock => clock,
                   prod => J,
                   Z0 => Z0,
                   Z1 => Z1,
                   Z2 => Z2,
                   Z3 => Z3,
                   S0 => S0,
                   S1 => S1,
                   a => Sout );
                 end struct;