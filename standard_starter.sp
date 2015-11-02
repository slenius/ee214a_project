* Design Problem, ee114/214A-2015
* Team Member 1 Name:
* Team Member 2 Name:
* Please fill in the specification achieved by your circuit 
* before you submit the netlist.
**************************************************************
* sunetids of team members = 
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
vdd n_vdd 0 2.5
vss n_vss 0 -2.5

* Defining the input current source
** For ac simulation uncomment the following 2 lines**
Iin    n_iin    0    ac    100n	
 
** For transient simulation uncomment the following 2 lines**
*Iin    n_iin    0    sin(0 0.5u 1e6)

* Defining Input capacitance
Cin    n_iin    0    'p_Cin'

* Defining the load 
RL    n_vout     0          'p_RL'
CL    n_vout     0          'p_CL'

*** Your Trans-impedance Amplifier here ***
***	d	g	s	b	n/pmos114	w	l

*** Vx/Iin = V(n_x) / Iin, use "n_x" as the node label for Vx ***
MN1    n_???    n_???      n_???    n_???    nmos114 w=???u  l=???u
MN2    n_???    0          n_???    n_???    nmos114 w=???u  l=???u
MP3    n_???    n_???      n_???    n_???    pmos114 w=???u  l=???u
R1     n_???    n_???      ???
R2     n_???    0          ???

*** Vy/Vx = V(n_y) / V(n_x) use "n_y" as the node label for Vy ***
MP4    n_???    n_???      n_???    n_???    pmos114 w=???u  l=???u
MP5    n_???    0          n_???    n_???    pmos114 w=???u  l=???u
MN6    n_???    n_???      n_???    n_???    pmos114 w=???u  l=???u
R3     n_???    0          ???
R4     n_???    n_???      ???

*** Vz/Vy = V(n_z) / V(n_y) use "n_z"" as the node label for Vz ***
MN7    n_???    n_???      n_???    n_???    nmos114 w=???u  l=???u
MP8    n_???    n_???      n_???    n_???    pmos114 w=???u  l=???u

*** Vout/Vz = V(n_vout) / V(n_z) use "n_vout" as the node label for Vout ***
MN9    n_???    n_???      n_???    n_???    nmos114 w=???u  l=???u
MN10   n_???    n_???      n_???    n_???    nmos114 w=???u  l=???u

*** Your Bias Circuitry goes here ***


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
