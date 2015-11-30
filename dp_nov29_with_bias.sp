* Design Problem, ee114/214A-2015
* Team Member 1 Name: Usha Kankanala (SCPD)
* Team Member 2 Name: Samuel Lenius (SCPD)
* Please fill in the specification achieved by your circuit
* before you submit the netlist
*************************************************************
*sunetids of team members = ukankana, lenius
* The specification that this script achieves are:
* Power		<= 2.00 mW (NOT met 2.36mW)
* Gain		>= 30.0 kOhm (MET 30.8 kOhm)
* BandWidth	>= 90.0 MHz (MET 90.23 MHz 
* FOM		>= 1350 (Not met 1178)
*************************************************************

** Including the model file
.include /usr/class/ee114/hspice/ee114_hspice.sp

** Definignt Top level circuit parameters
.param p_Cin = 220f
.param p_CL  = 250f
.param p_RL  = 20k

* defining the supply voltages
vdd	n_vdd	0	2.5
vss	n_vss	0	-2.5

*Defining the input current source
** For ac simulation uncomment the following 2 lines**
Iin	n_iin	0	ac	1

** For transient simulation uncomment the following 2 lines**
*Iin	n_iin	0	sin(0 0.5u 1e6) 

* Defining input capacitance
Cin n_iin 0 'p_Cin'

* Defining the load
RL	n_vout	0	'p_RL'
CL	n_vout	0	'p_CL'

*** Your Trans-impedance Amplifier here ***
***	d	g	s	b	n/pmos114	w	l

*** Vx/Iin = V(n_x) / Iin, use "n_x" as the node label for Vx ***
MN1	n_iin	n_bias_n  n_vss	 n_vss	nmos114 w=3u	l=2u
MN2	n_x	0	  n_iin  n_vss	nmos114 w=12u	l=1u
MP3	n_x	n_bias_p  n_vdd	 n_vdd	pmos114	w=6.6u	l=2u
R1	n_vdd	n_x	  20k
R2	n_x	0	  20k

*** Vy/Vx = V(n_y) / V(n_x), use "n_y" as the node label for Vy ***
MP4	n_w	n_x	  n_vdd	 n_vdd	pmos114	w=8u	l=1u
MP5	n_y	0	  n_w	 n_vdd	pmos114	w=8.6u	l=1u
MN6	n_y	n_bias_n  n_vss	 n_vss	nmos114	w=4.4u	l=2u
R3	n_y	0	  44.5k 
R4	n_y	n_vss	  36.4k

*** Vz/Vy = V(n_z) / V(n_y), use "n_z" as the node label for Vz ***
MN7	n_z	n_y	  n_vss	 n_vss	nmos114	w=2u	l=1u
MP8	n_z	n_z	  n_vdd	 n_vdd	pmos114	w=2u	l=1u

*** Vout/Vz = V(n_vout) / V(n_z), use "n_vout" as the node label for Vout ***
MN9	n_vout	n_bias_n  n_vss	 n_vss	nmos114	w=2u	l=2u
MN10	n_vdd	n_z	  n_vout n_vss	nmos114	w=28u	l=1u

*** Your Bias Circuitry goes here ***
*v_bias_n n_bias_n n_vss 1.55
*v_bias_p n_bias_p n_vdd -1.55
MP100	n_bias_n n_bias_p n_vdd  n_vdd	pmos114 w=4u	l=2u
MP200	n_bias_p n_bias_p n_vdd  n_vdd	pmos114 w=4u	l=2u
MN300	n_bias_n n_bias_n n_vss  n_vss	nmos114 w=2u	l=2u
MN400	n_bias_p n_bias_n n_biasr2   n_vss	nmos114 w=4u	l=2u
R200	n_biasr2 n_vss	11.2k  	 
MP800	n_biasn9 n_bias_n n_vdd  n_vdd pmos114 w=2u	l=4u
MN700	n_biasn9 n_bias_n n_vss  n_vss nmos114 w=5u	l=2u
MN900   n_bias_p n_biasn9 n_vss  n_vss nmos114 w=4u	l=2u 


*** defining the analysis ***
.op
.option post brief nomod

** For ac simulation uncomment the following line**
.ac dec 1k 100 1g

.measure ac gainmax_viin max vdb(n_iin)
.measure ac f3db_viin when vdb(n_iin)='gainmax_viin-3'

.measure ac gainmax_vx max vdb(n_x)
.measure ac f3db_vx when vdb(n_x)='gainmax_vx-3'

.measure ac gainmax_vy max vdb(n_y)
.measure ac f3db_vy when vdb(n_y)='gainmax_vy-3'

.measure ac gainmax_vz max vdb(n_z)
.measure ac f3db_vz when vdb(n_z)='gainmax_vz-3' 			  	

.measure ac gainmax_vout max vdb(n_vout)
.measure ac f3db_vout when vdb(n_vout)='gainmax_vout-3'

** For transient simulation uncomment the following line **
.tran 0.01u 4u

.end