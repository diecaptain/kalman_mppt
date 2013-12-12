#!/usr/bin/perl -w
#program to verify fuzman filter
#inputs are Zin,Vin,Vref
#outputs are Vout,Zout,k
$M = 0.05; #Value of M
$Q = 0.01; #Value of Q
$R = 0.0001; #value of R
$Vin = 21; #initial estimate of input voltage
$Zin = 0.99; #initial estimate of input error
@Vref = qw(20 20.6 19.27 20.1 19.8 19.36 19.42 19.62 19.38 20.4 19.32 18.1 19.64 19.25 19.44 19.21 19.69 19.67 19.62 19.58);
print "\n the reference voltage array is : \n @Vref \n\n";
$n = @Vref;
@Iref = qw(0.42 0.93 0.45 0.78 0.83 0.72 0.75 0.9 0.77 0.96 0.84 0.41 0.82 0.68 0.72 0.55 0.7 0.73 0.76 0.68);
print "\n the reference current array is : \n @Iref \n\n";
for ( $j = 0;$j < $n; $j++ ) 
  {
   $P[$j] = $Vref[$j] * $Iref[$j]; #Power array is calculated here
  }
print "\n the reference power array is : \n @P \n\n";
$Vopt = 21;
print "\nThe optimal voltage is : $Vopt \n";
@Iopt = qw (1.19 1.20 1.22 1.24 1.22 1.21);
print "The optimal current array is : @Iopt \n";
$q = @Iopt;
for ( $l = 0;$l < $q; $l++ ) 
  {
   $Popt[$l] = $Vopt * $Iopt[$l]; #Power array is calculated here
  }
print "\n the optimal reference power array is : \n @Popt \n\n";
kalman ();
kalman_opt ();
print "That's all folks!!!\n";
####################################################
################# Kalman algorithm #################
####################################################
sub kalman
{
open (FIRST,">kalman.txt");
for ( $i = 0;$i < $n;$i++ )
  { 
      $h = $i - 1;
   if ( $i == '0' )
    {
      $Zcap[$i] = $Zin + $Q; # Priori error probability projectile
      $temp1 = $P[$i];
      $temp2 = $Vref[$i];
      $U[$i] = $temp1/$temp2;
      $Vcap[$i] = $Vin + $M * $U[$i]; # priori voltage estimate
      $k[$i] = $Zcap[$i] / ($Zcap[$i] + $R); # Kalman gain
      $V[$i] = $Vcap[$i] + ($k[$i] * ($Vref[$i] - $Vcap[$i])); #Output kalman voltage estimate 
      $Z[$i] = ((1 - $k[$i]) * $Zcap[$i]);
      $Pm[$i] = $V[$i] * $Iref[$i]; #MPPT power
      }
      elsif ( $i > '0' )
          {
           $Zcap[$i] = $Z[$h] + $Q; # Priori error probability projectile
           $temp1 = $P[$i]-$P[$h];
           $temp2 = $Vref[$i]-$Vref[$h];
           $U[$i] = $temp1/$temp2;
           $Vcap[$i] = $V[$h] + $M * $U[$i]; # priori voltage estimate
           $k[$i] = $Zcap[$i] / ($Zcap[$i] + $R); # Kalman gain
           $V[$i] = $Vcap[$i] + ($k[$i] * ($Vref[$i] - $Vcap[$i])); #Output kalman voltage estimate 
           $Z[$i] = ((1 - $k[$i]) * $Zcap[$i]);
           $Pm[$i] = $V[$i] * $Iref[$i]; #MPPT power
            }
             write(FIRST);
              }
format FIRST_TOP =
Page @<<<
$%

 Vref   Iref   Pref        Gain         Voltage             Error             Power
====== ====== ====== =============== ============== ==================== ===============
.
format FIRST =
@<<<<< @<<<<< @<<<<< @<<<<<<<<<<<<<< @<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<
$Vref[$i], $Iref[$i], $P[$i], $k[$i], $V[$i], $Z[$i], $Pm[$i]
.
 close (FIRST);
             }
#####################################################################
################ Kalman Optimal Conditions ##########################
#####################################################################
sub kalman_opt
{
open (SECOND,">kalman_opt.txt");
for ( $y = 0;$y < $q;$y++ )
  { 
      $g = $y - 1;
   if ( $y == '0' )
     {
      $Zcapopt[$y] = $Zin + $Q; # Priori error probability projectile
      #$temp1 = $P[$y];
      #$temp2 = $Vref[$y];
      $Uopt[$y] = $Iopt[$y];
      $Vcapopt[$y] = $Vopt + $M * $Uopt[$y]; # priori voltage estimate
      $kopt[$y] = $Zcapopt[$y] / ($Zcapopt[$y] + $R); # Kalman gain
      $Vo[$y] = $Vcapopt[$y] + ($kopt[$y] * ($Vopt - $Vcapopt[$y])); #Output kalman voltage estimate 
      $Zopt[$y] = ((1 - $kopt[$y]) * $Zcapopt[$y]);
      $Pmopt[$y] = $Vo[$y] * $Iopt[$y];
      }
       elsif ( $y > '0' )
          {
           $Zcapopt[$y] = $Zin + $Q; # Priori error probability projectile
           #$temp1 = $P[$y];
           #$temp2 = $Vref[$y];
           $Uopt[$y] = $Iopt[$y]-$Iopt[$g];
           $Vcapopt[$y] = $Vo[$g] + $M * $Uopt[$y]; # priori voltage estimate
           $kopt[$y] = $Zcapopt[$y] / ($Zcapopt[$y] + $R); # Kalman gain
           $Vo[$y] = $Vcapopt[$y] + ($kopt[$y] * ($Vopt - $Vcapopt[$y])); #Output kalman voltage estimate 
           $Zopt[$y] = ((1 - $kopt[$y]) * $Zcapopt[$y]);
           $Pmopt[$y] = $Vo[$y] * $Iopt[$y];
           }
          write(SECOND);
          }
format SECOND_TOP =
Page @<<<
$%

 Vopt   Iopt   Popt    Gain(optimal)  Voltage(opt)     Error(optimal)      Power(opt)
====== ====== ====== =============== ============== ==================== ===============
.
format SECOND =
@<<<<< @<<<<< @<<<<< @<<<<<<<<<<<<<< @<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<
$Vopt, $Iopt[$y], $Popt[$y], $kopt[$y], $Vo[$y], $Zopt[$y], $Pmopt[$y]
.
close (SECOND);
}
