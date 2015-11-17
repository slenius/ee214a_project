
.include /usr/class/ee114/hspice/ee114_hspice.sp

.param gs=1
.param Lp = 2u
.param Wp = 2u

vgsn     vn  0       dc 'gs'
vdsn     vdn 0       dc 1.25
mn1      vdn vn 0 0   nmos114  w=Wp l=Lp
vgsp     vdp vp      dc 'gs'
vdsp     vdp 0       dc 1.25
mp1      0  vp  vdp vdp  pmos114  w=Wp l=Lp

.op
*
* MODIFY THIS DC SWEEP TO INCLUDE TRANSISTOR LENGTHS
* FROM 0.35..0.7UM IN 0.05UM STEPS
*

**** The modified DC

.dc gs 0.5V 2.5V 10m Lp 2u 8u 1u

.probe nov        = par('gs-vth(mn1)')
.probe ngm_id     = par('gmo(mn1)/i(mn1)')
.probe gm = par('gmo(mn1)')

**** The ft of NMOS ****

.probe nft        =par('1/2/3.142*gmo(mn1)/cggbo(mn1)')

***  The gm/Id *fT *****

.probe ngm_id_ft  = par('ngm_id*nft')

****

.probe ngmro      = par('gmo(mn1)/gdso(mn1)')
.probe nidw       = par('i(mn1)/Wp')
.probe ncgg       = par('cggbo(mn1)')
.probe ncgd       = par('cgdbo(mn1)')
.probe ncdd       = par('cddbo(mn1)')
.probe ncdg       = par('cdgbo(mn1)')

.probe pov        = par('gs-vth(mp1)')
.probe pgm_id     = par('-gmo(mp1)/i(mp1)')
.probe vt = par('vth(mp1)')

**** The fT of PMOS *****

.probe pft        = par('1/2/3.142*(gmo(mp1)/cggbo(mp1))')

.probe pgm_id_ft  = par('pgm_id*pft')
.probe pgmro      = par('gmo(mp1)/gdso(mp1)')
.probe pidw       = par('-i(mp1)/Wp')
.probe pcgg       = par('cggbo(mp1)')
.probe pcgd       = par('cgdbo(mp1)')
.probe pcdd       = par('cddbo(mp1)')
.probe pcdg       = par('cdgbo(mp1)')
.probe gs = par('gs')
.probe wp = par('Wp')
.probe lp = par('Lp')

*.print dc par(Wp) i(mn1)

.options dccap post brief
*.include ee314_hspice.txt
.end

