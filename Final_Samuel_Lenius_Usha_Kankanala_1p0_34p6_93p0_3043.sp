* Design Problem, ee114/214A-2015
* Team Member 1 Name: Usha Kankanala
* Team Member 2 Name: Samuel Lenius
* Please fill in the specification achieved by your circuit
* before you submit the netlist
*************************************************************
* sunetids of team members:
*   ukankana@stanford.edu:  06091239
*   lenius@stanford.edu:    06091240
* The specification that this script achieves are:
* Power         1.06mW    <= 2.00 mW      Meets Spec
* Gain          34.6kOhm  >=  30.0 kOhm   Meets Spec
* BandWidth     93.0MHz   >= 90.0 MHz     Meets Spec
* FOM           3043      >= 1350         Meets Spec
*************************************************************

* Including the model file
.include /usr/class/ee114/hspice/ee114_hspice.sp

* Defining Top level circuit parameters
.param p_Cin = 220f
.param p_CL  = 250f
.param p_RL  = 20k

* Defining the supply voltages
vdd     n_vdd   0       2.5
vss     n_vss   0       -2.5

*Defining the input current source
** For ac simulation uncomment the following 2 lines**
Iin     n_iin   0       ac      100n
*Iin     n_iin   0       ac      1

** For transient simulation uncomment the following 2 lines**
*Iin    n_iin    0    sin(0 0.5u 1e6)

* Defining Input capacitance
Cin    n_iin    0    'p_Cin'

* Defining the load
RL      n_vout  0       'p_RL'
CL      n_vout  0       'p_CL'

*** Your Trans-impedance Amplifier here ***
***     d       g       s       b       n/pmos114       w       l

*** Vx/Iin = V(n_x) / Iin, use "n_x" as the node label for Vx ***
MN1     n_iin   n_bias_n  n_vss   n_vss nmos114 w=3.0u l=2.0u

* Increasing the size of MN2 here is a power-free trick to improve the input
* pole performance.
MN2     n_x     0         n_iin  n_vss  nmos114 w=28.0u l=1.0u
MP3     n_x     n_bias_p  n_vdd  n_vdd  pmos114 w=6.0u l=2.0u

* The parallel combination of these resistors provide the first stage gain.
R1      n_vdd   n_x       19200
R2      n_x     0         20800

*** Vy/Vx = V(n_y) / V(n_x), use "n_y" as the node label for Vy ***
* MP4 both provides gain to the second stage and provides most of the node
* capacitance to the first stage, hence it's sizing is a delicate balance.
MP4     n_w     n_x       n_vdd  n_vdd  pmos114 w=6.0u l=1.0u
MP5     n_y     0         n_w    n_vdd  pmos114 w=6.0u l=1.0u
MN6     n_y     n_bias_n  n_vss  n_vss  nmos114 w=3.0u l=2.0u
* We used asymmetry on MN6 in order to make Vy faster, and allow a higher Vov on
* MN6 however it made selecting the resistor values a lot tougher.

* These resistors provide the second stage gain, when combined with gm4.
* Asymmetry in MN6:MP4 sizing leads to a bit of a wonky ratio as they need to
* accoutn for the imbalanced current.
R3      n_y     0         168100
R4      n_y     n_vss     34400

*** Vz/Vy = V(n_z) / V(n_y), use "n_z" as the node label for Vz ***
* The size of these transistors sets up the gain of the third stage. Here it's
* approximately sqrt(2)
MN7     n_z     n_y       n_vss  n_vss  nmos114 w=2.0u l=1.0u
MP8     n_z     n_z       n_vdd  n_vdd  pmos114 w=2.0u l=1.0u

*** Vout/Vz = V(n_vout) / V(n_z), use "n_vout" as the node label for Vout ***
* MN10 is very tricky to bias right. You need to account for it's large Vt due
* to backgate and you tend to have a lot of error stacked up by the time that Vz
* is biased. Hence it required a small amount of monkeying to get it just right
* after we hand calculated the values.
MN9     n_vout  n_bias_n  n_vss  n_vss  nmos114 w=5.0u l=2.0u
MN10    n_vdd   n_z       n_vout n_vss  nmos114 w=28.0u l=1.0u

*** Your Bias Circuitry goes here ***

* This design is a self-biasing delta-Vgs / constant gm reference with startup
* circuit. The design was taken from lecture notes 14.

* These transistors provide the PMOS bias
MP100   n_bias_n n_bias_p n_vdd n_vdd  pmos114 w=4u  l=2u
MP200   n_bias_p n_bias_p n_vdd n_vdd  pmos114 w=4u  l=2u

* These transistors provide the NMOS bias and are the source of the delta
* Vgs reference. The ratio between the widths of these transistors defines m.
MN300   n_bias_n n_bias_n n_vss n_vss  nmos114 w=2u  l=2u
MN400   n_bias_p n_bias_n n_biasr2   n_vss  nmos114 w=4u l=2u

* This resistor is the denominator of the reference vov equation.
R200    n_biasr2 n_vss  16.7k

* These transistors are the startup circuit that enforces that it stay at
* the upper stable point, as the system is bistable.
MP800   n_biasn9 n_bias_n n_vdd n_vdd pmos114 w=2u  l=9u
MN700   n_biasn9 n_bias_n n_vss n_vss nmos114 w=5u  l=2u
MN900   n_bias_p n_biasn9 n_vss n_vss nmos114 w=4u  l=2u

*** defining the analysis ***
.op
.option post brief nomod

** For ac simulation uncomment the following line**
.ac dec 1k 100 1g

.measure ac gainmax_vout max vdb(n_vout)
.measure ac f3db_vout when vdb(n_vout)='gainmax_vout-3'

.measure ac gainmax_vx max vdb(n_x)
.measure ac f3db_vx when vdb(n_x)='gainmax_vx-3'

.measure ac gainmax_vy max vdb(n_y)
.measure ac f3db_vy when vdb(n_y)='gainmax_vy-3'

.measure ac gainmax_vz max vdb(n_z)
.measure ac f3db_vz when vdb(n_z)='gainmax_vz-3'

** For transient simulation uncomment the following line **
*.tran 0.01u 4u

.end
