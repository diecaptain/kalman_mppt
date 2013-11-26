library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity k_kalman_final is
  port
    ( clock                  : in std_logic;
      Uofk                   : in std_logic_vector(31 downto 0);
      Vrefofkplusone         : in std_logic_vector(31 downto 0);
      Vactcapofk             : in std_logic_vector(31 downto 0);
      pofk                   : in std_logic_vector(31 downto 0);
      Pofkplusone            : out std_logic_vector(31 downto 0);
      Vactcapofkplusone      : out std_logic_vector(31 downto 0)
    );
  end k_kalman_final;
architecture struct of k_kalman_final is
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
signal I1 : std_logic_vector (31 downto 0) := "00111101010011001100110011001101";
signal I2 : std_logic_vector (31 downto 0) := "00111100001000111101011100001010";
signal I3 : std_logic_vector (31 downto 0) := "00111000110100011011011100010111";
signal X1,X2,X3 : std_logic_vector (31 downto 0);
begin
  M1 : kn_kalman_Vactcapdashofkplusone
        port map ( clock => clock,
                   Vactcapofk => Vactcapofk,
                   M => I1,
                   Uofk => Uofk,
                   Vactcapdashofkplusone => X1 );
  M2 : kn_kalman_Pdashofkplusone
        port map ( clock => clock,
                   Pofk => Pofk,
                   Q => I2,
                   Pdashofkplusone => X2 );
  M3 : kn_kalman_Kofkplusone 
        port map ( clock => clock,
                   Pdashofkplusone => X2,
                   R => I3,
                   Kofkplusone => X3 );
  M4 : kn_kalman_Pofkplusone 
        port map ( clock => clock,
                   Pdashofkplusone => X2,
                   Kofkplusone => X3,
                   Pofkplusone => Pofkplusone );
  M5 : kn_kalman_Vactcapofkplusone
        port map ( clock => clock,
                   Vactcapdashofkplusone => X1,
                   Vrefofkplusone => Vrefofkplusone,
                   Kofkplusone => X3,
                   Vactcapofkplusone => Vactcapofkplusone );
                 end struct;