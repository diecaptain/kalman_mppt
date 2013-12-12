#!/usr/bin/perl -w
#program to verify fuzman filter
#inputs are Zin,Vin,Vref
#outputs are Vout,Zout,k
$M = 0.05; #Value of M
$Q = 0.01; #Value of Q
$R = 0.0001; #value of R
$Vin = 21; #initial estimate of input voltage
$Zin = 0.99; #initial estimate of input error
print "\n Enter reference voltage array here :\n";
chomp(@Vref = <STDIN>);
$n = @Vref;
print "\n Enter reference current array here :\n";
chomp(@Iref = <STDIN>);
for ( $j = 0;$j < $n; $j++ ) 
  {
   $P[$j] = $Vref[$j] * $Iref[$j]; #Power array is calculated here
  }
print "\n Enter optimal voltage here :\n";
chomp($Vopt = <STDIN>);
print "\n Enter optimal current array here :\n";
chomp(@Iopt = <STDIN>);
$q = @Iopt;
for ( $l = 0;$l < $q; $l++ ) 
  {
   $Popt[$l] = $Vopt * $Iopt[$l]; #Power array is calculated here
  }
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
