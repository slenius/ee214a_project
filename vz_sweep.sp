* Design Problem, ee114/214A-2015
* Team Member 1 Name: Usha Kankanala
* Team Member 2 Name: Samuel Lenius
* Please fill in the specification achieved by your circuit
* before you submit the netlist.
**************************************************************
* sunetids of team members = lenius
* The specifications that this script achieves are:
* Power       <= 2.00 mW
* Gain        >= 30.0 kOhm
* BandWidth   >= 90.0 MHz
* FOM         >= 1350
***************************************************************

** Including the model file
.include /usr/class/ee114/hspice/ee114_hspice.sp

* Defining Top level circuit parameters
.param p_Cin = 220f
.param p_CL  = 250f
.param p_RL  = 20k

* defining the supply voltages
vdd   n_vdd     0     2.5
vss   n_vss     0     -2.5

* Defining the input current source
** For ac simulation uncomment the following 2 lines**
Iin   n_iin    0     ac    1

** For transient simulation uncomment the following 2 lines**
*Iin   n_iin    0    sin(0 0.5u 1e6)

* Defining Input capacitance
Cin   n_iin    0         'p_Cin'

* Defining the load
RL    n_vout    0         'p_RL'
CL    n_vout    0         'p_CL'

*** Your Trans-impedance Amplifier here ***
***	d	g	s	b	n/pmos114	w	l

*** Vx/Iin = V(n_x) / Iin, use "n_x" as the node label for Vx ***

*** Vy/Vx = V(n_y) / V(n_x) use "n_y" as the node label for Vy ***

*** Vz/Vy = V(n_z) / V(n_y) use "n_z"" as the node label for Vz ***

*** Vout/Vz = V(n_vout) / V(n_z) use "n_vout" as the node label for Vout ***
MN9    n_vout   n_bias_n  n_vss     n_vss     nmos114 w=2u  l=2u
MN10   n_vdd    n_z       n_vout    n_vss     nmos114 w=2u  l=2u

*** Your Bias Circuitry goes here ***
v_bias_n n_bias_n n_vss 0.65

v_sweep n_z 0 1.75


*** defining the analysis ***
.op
.option post brief nomod

** For ac simulation uncomment the following line**
.ac dec 1k 100 1g
.dc v_sweep 1.1 1.85 0.05


.measure ac gainmax_vout max vdb(n_vout)
.measure ac f3db_vout when vdb(n_vout)='gainmax_vout-3'

.measure ac gainmax_vx max vdb(n_x)
.measure ac f3db_vx when vdb(n_x)='gainmax_vx-3'

.measure ac gainmax_vy max vdb(n_y)
.measure ac f3db_vy when vdb(n_y)='gainmax_vy-3'

.measure ac gainmax_vz max vdb(n_z)
.measure ac f3db_vz when vdb(n_z)='gainmax_vz-3'

.print v(n_z, n_vout) v(n_vdd, n_vout) gmo(MN10) gmbo(MN10) vth(MN10)

** For transient simulation uncomment the following line **
*.tran 0.01u 4u

.end
