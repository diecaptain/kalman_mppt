library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity kn_kalman_final is
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
  end kn_kalman_final;
architecture struct of kn_kalman_final is
  component kn_kalman_Vactcapdashofkplusone is
  port
   ( clock      : in std_logic;
     Vactcapofk : in std_logic_vector(31 downto 0);
     M          : in std_logic_vector(31 downto 0);
     Uofk       : in std_logic_vector(31 downto 0);
     Vactcapdashofkplusone : out std_logic_vector(31 downto 0)
     );
   end component;
   component kn_kalman_Pdashofkplusone is
  port
    ( clock   : in std_logic;
      Pofk    : in std_logic_vector(31 downto 0);
      Q       : in std_logic_vector(31 downto 0);
      Pdashofkplusone : out std_logic_vector(31 downto 0)
    );
  end component;
  component kn_kalman_Kofkplusone is
  port
    ( clock           : in std_logic;
      Pdashofkplusone : in std_logic_vector(31 downto 0);
      R               : in std_logic_vector(31 downto 0);
      Kofkplusone     : out std_logic_vector(31 downto 0)
    );
  end component;
  component kn_kalman_Pofkplusone is
  port
    ( clock            : in std_logic;
      Pdashofkplusone  : in std_logic_vector(31 downto 0);
      Kofkplusone      : in std_logic_vector(31 downto 0);
      Pofkplusone      : out std_logic_vector(31 downto 0)
    );
  end component;
  component kn_kalman_Vactcapofkplusone is
  port
    ( clock              : in std_logic;
      Vactcapdashofkplusone : in std_logic_vector(31 downto 0);
      Vrefofkplusone            : in std_logic_vector(31 downto 0);
      Kofkplusone        : in std_logic_vector(31 downto 0);
      Vactcapofkplusone     : out std_logic_vector(31 downto 0)
    );
end component;
     component mux is
			   port 
            (  clock       : in std_logic;
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
component kr_regbuf_enable is
  port ( clock,reset,load : in std_logic;
         I : in std_logic_vector (31 downto 0);
         Y : out std_logic_vector (31 downto 0);
         enable : out std_logic );
			end component;
signal Vactcapdashofkplusone,Pdashofkplusone,Kofkplusone : std_logic_vector(31 downto 0);
signal Vactcapofk_initial : std_logic_vector (31 downto 0) := "00111111111011001100110011001101";
signal Pofk_initial : std_logic_vector (31 downto 0) := "00111111011111010111000010100100";
signal M : std_logic_vector (31 downto 0) := "00111100001000111101011100001010";
signal Q : std_logic_vector (31 downto 0) := "00111100001000111101011100001010";
signal R : std_logic_vector (31 downto 0) := "00111000110100011011011100010111";
signal V1,V2,V3,J1,J2,J3,K1,K2,K3,N1,N2 : std_logic_vector (31 downto 0);
begin
  M1 : mux port map
		     ( clock => clock,
			    a => Vactcapofk_initial,
				 b => K1,
				 z => Vactcapofk_mux_sel,
				 prod => V1);
		 M2 : kr_regbuf port map
		     ( clock => clock,
			    reset => Vactcapofk_reset,
				 load => Vactcapofk_sel,
				 I => V1,
				 Y => J1);
		 M3 : mux port map
		     ( clock => clock,
			    a => Pofk_initial,
				 b => K2,
				 z => Pofk_mux_sel,
				 prod => V2);
		 M4 : kr_regbuf port map
		     ( clock => clock,
			    reset => Pofk_reset,
				 load => Pofk_sel,
				 I => V2,
				 Y => J2);
  M5 : kn_kalman_Vactcapdashofkplusone 
   port map
     ( clock => clock,
       Vactcapofk => J1,
       M => M,
       Uofk => Uofk,
       Vactcapdashofkplusone => Vactcapdashofkplusone );
  M6 : kn_kalman_Pdashofkplusone
   port map
     ( clock => clock,
       Pofk => J2,
       Q => Q,
       Pdashofkplusone => Pdashofkplusone );
  M7 : kn_kalman_Kofkplusone 
   port map 
     ( clock => clock,
       Pdashofkplusone => Pdashofkplusone,
       R => R,
       Kofkplusone => Kofkplusone );
  M8 : kn_kalman_Pofkplusone 
   port map 
    ( clock => clock,
      Pdashofkplusone => Pdashofkplusone,
      Kofkplusone => Kofkplusone,
      Pofkplusone => N2 );
  M9 : kr_regbuf_enable 
  port map
		      ( clock => clock,
				  reset => Pofkplusone_reset,
				  load => Pofkplusone_sel,
				  I => N2,
				  Y => K2,
				  enable => Pofkplusone_enable);
  M10 : kn_kalman_Vactcapofkplusone
   port map
     ( clock => clock,
       Vactcapdashofkplusone => Vactcapdashofkplusone,
       Vrefofkplusone => Vrefofkplusone,
       Kofkplusone => Kofkplusone,
       Vactcapofkplusone => N1 ); 
  M11 : kr_regbuf_enable 
  port map
		      ( clock => clock,
				  reset => Vactcapofkplusone_reset,
				  load => Vactcapofkplusone_sel,
				  I => N1,
				  Y => K1,
				  enable => Vactcapofkplusone_enable);       
  Pofkplusone <= K2;
  Vactcapofkplusone <= K1;
  end struct;
       
  
      
