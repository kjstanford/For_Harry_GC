** gc array model

.PARAM vsup = 1.8
.PARAM vcore = 0.9
.PARAM vss = 0
.PARAM step = 1e-12
.PARAM sim_time = 0.0001

.PARAM vhold = 0
.PARAM vboost = 2.5
.PARAM wwl_del = 2e-09
.PARAM wwl_rise = 5e-10
.PARAM wwl_fall = 5e-10
.PARAM wwl_pw = 1e-08
.PARAM wwl_tp = 1e-07

.PARAM vread = 1.8
.PARAM rwl_del = 2e-08
.PARAM rwl_rise = 5e-10
.PARAM rwl_fall = 5e-10
.PARAM rwl_pw = 5e-08
.PARAM rwl_tp = 1e-07

.PARAM vnone = 0
.PARAM vwbit = 1.8
.PARAM wbl_del = 1e-09
.PARAM wbl_rise = 5e-10
.PARAM wbl_fall = 5e-10
.PARAM wbl_pw = 1.2e-08
.PARAM wbl_tp = 1e-07

.PARAM Rwwl = 1000.0
.PARAM Cwwl = 1e-16
.PARAM Rwbl = 1000.0
.PARAM Cwbl = 1e-16
.PARAM Rrwl = 1000.0
.PARAM Crwl = 1e-16
.PARAM Rrbl = 1000.0
.PARAM Crbl = 1e-16

.PARAM version = 0.0
.PARAM Tjun = 300
.PARAM mu_eff = 0.001775
.PARAM W = 3.2e-07
.PARAM WL = 1.6e-07
.PARAM Lg = 2.5e-07
.PARAM Cg = 0.0124
.PARAM Cpar = 1.24e-12
.PARAM longVT = 0.6
.PARAM alpha1 = 0.774175
.PARAM alpha2 = 0.043085
.PARAM meff = 0.3
.PARAM rsd_mode = 0
.PARAM Rs0 = 6e-05
.PARAM Rd0 = 6e-05
.PARAM delta = 0.0
.PARAM rollVT = 0.0
.PARAM n0 = 1.0
.PARAM nd = 0.0
.PARAM type = 1

.TEMP 25.0
.OPTION
+ ARTIST=2
+ INGOLD=2
+ PARHIER=LOCAL
+ PSF=2
+ ACCURATE=1

.HDL osfet_potential_based_compact_model_v0.va

* TSMC N40 models
.LIB "/cad/tsmc/PDK_N40_2022/1p6m_4x1z/models/hspice/toplevel.l" top_tt
* m0 d g s b nch l=40e-9 w=120e-9 m=1 nf=1 sd=140e-9 ad=13.2e-15 as=13.2e-15 pd=460e-9 ps=460e-9 nrd=193.171e-3 nrs=193.171e-3 sa=110e-9 sb=110e-9 * core NMOS
* m0 d g s b pch l=40e-9 w=120e-9 m=1 nf=1 sd=140e-9 ad=13.2e-15 as=13.2e-15 pd=460e-9 ps=460e-9 nrd=193.171e-3 nrs=193.171e-3 sa=110e-9 sb=110e-9 * core PMOS

.SUBCKT wos_ros_gc wwl wbl rwl rbl sn
xos wbl wwl sn osfet
+ version='version' Tjun='Tjun' mu_eff='mu_eff' W='W' Lg='Lg' Cg='Cg' Cpar='Cpar' longVT='longVT'
+ alpha1='alpha1' alpha2='alpha2' meff='meff' rsd_mode='rsd_mode' Rs0='Rs0' Rd0='Rd0'
+ delta='delta' n0='n0' nd='nd' rollVT='rollVT' type='type'

xosr rbl sn rwl osfet
+ version='version' Tjun='Tjun' mu_eff='mu_eff' W='W' Lg='Lg' Cg='Cg' Cpar='Cpar' longVT='longVT'
+ alpha1='alpha1' alpha2='alpha2' meff='meff' rsd_mode='rsd_mode' Rs0='Rs0' Rd0='Rd0'
+ delta='delta' n0='n0' nd='nd' rollVT='rollVT' type='type'
.ENDS

.SUBCKT wos_rpsi25ud18_gc wwl wbl rwl rbl sn vcc
xos wbl wwl sn osfet
+ version='version' Tjun='Tjun' mu_eff='mu_eff' W='W' Lg='Lg' Cg='Cg' Cpar='Cpar' longVT='longVT'
+ alpha1='alpha1' alpha2='alpha2' meff='meff' rsd_mode='rsd_mode' Rs0='Rs0' Rd0='Rd0'
+ delta='delta' n0='n0' nd='nd' rollVT='rollVT' type='type'

m0 rbl sn rwl vcc pch_25ud18 l=250e-9 w=320e-9 m=1 nf=1 sd=220e-9 ad=48e-15 as=48e-15 pd=940e-9 ps=940e-9 nrd=0 nrs=0 sa=150e-9 sb=150e-9
.ENDS

.SUBCKT gcweight wwl wbl weight rwl sn vcc vss
xos wbl wwl sn osfet
+ version='version' Tjun='Tjun' mu_eff='mu_eff' W='W' Lg='Lg' Cg='Cg' Cpar='Cpar' longVT='longVT'
+ alpha1='alpha1' alpha2='alpha2' meff='meff' rsd_mode='rsd_mode' Rs0='Rs0' Rd0='Rd0'
+ delta='delta' n0='n0' nd='nd' rollVT='rollVT' type='type'

xosr weight sn vss osfet
+ version='version' Tjun='Tjun' mu_eff='mu_eff' W='W' Lg='Lg' Cg='Cg' Cpar='Cpar' longVT='longVT'
+ alpha1='alpha1' alpha2='alpha2' meff='meff' rsd_mode='rsd_mode' Rs0='Rs0' Rd0='Rd0'
+ delta='delta' n0='n0' nd='nd' rollVT='rollVT' type='type'

m0 weight sn rwl vcc pch_25ud18 l=250e-9 w=320e-9 m=1 nf=1 sd=220e-9 ad=48e-15 as=48e-15 pd=940e-9 ps=940e-9 nrd=0 nrs=0 sa=150e-9 sb=150e-9

*xosl weight activate activate osfet
*+ version='version' Tjun='Tjun' mu_eff='mu_eff' W='WL' Lg='Lg' Cg='Cg' Cpar='Cpar' longVT='longVT'
*+ alpha1='alpha1' alpha2='alpha2' meff='meff' rsd_mode='rsd_mode' Rs0='Rs0' Rd0='Rd0'
*+ delta='delta' n0='n0' nd='nd' rollVT='rollVT' type='type'

.ENDS

.SUBCKT NR2D0BWP40 a1 a2 zn vdd vss
mm7 net1 a2 vdd vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm3 zn a1 net1 vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm8 zn a2 vss vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm9 zn a1 vss vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
.ENDS NR2D0BWP40

.SUBCKT FA1D0BWP40 a b ci s co vdd vss
mm10 net44 b net21 vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm2 net5 b vdd vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm26 co net11 vdd vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm12 s net61 vdd vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm8 net61 net11 net20 vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm9 net21 ci vdd vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm0 net25 b vdd vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm4 net11 ci net25 vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm7 net20 a vdd vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm3 net11 a net5 vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm11 net61 a net44 vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm5 net20 ci vdd vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm1 net25 a vdd vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm6 net20 b vdd vdd pch l=40e-9 w=225e-9 m=1 nf=1 sd=140e-9 ad=24.75e-15 as=24.75e-15 pd=670e-9 ps=670e-9 nrd=526.104e-3 nrs=526.104e-3 sa=110e-9 sb=110e-9
mm21 net85 ci vss vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm18 net61 net11 net85 vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm14 net97 b vss vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm13 net11 ci net97 vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm22 net85 a vss vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm17 net11 a net101 vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm25 net81 ci vss vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm24 net85 b vss vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm23 net96 b net81 vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm19 net61 a net96 vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm15 net97 a vss vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm16 net101 b vss vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm20 s net61 vss vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
mm27 co net11 vss vss nch l=40e-9 w=175e-9 m=1 nf=1 sd=140e-9 ad=19.25e-15 as=19.25e-15 pd=570e-9 ps=570e-9 nrd=281.707e-3 nrs=281.707e-3 sa=110e-9 sb=110e-9
.ENDS

.SUBCKT norFA weight input mac cin sum cout vdd vss
xi5 weight input net7 vdd vss NR2D0BWP40
xi4 net7 mac cin sum cout vdd vss FA1D0BWP40
.ENDS

* .param R0 = 1e3
* .param C0 = 1e-13

.SUBCKT rc_unit rc_in rc_out R0=1e3 C0=1e-13
r_unit rc_in rc_out R=R0
c_unit rc_out 0 C=C0
.ENDS rc_unit

.TRAN 'step' 'sim_time'
.DCVOLT sn_0_0 0.0
.DCVOLT mac_0_0 0.9
.DCVOLT sn_0_1 1.8
.DCVOLT mac_0_1 0.0
.DCVOLT sn_0_2 0.0
.DCVOLT mac_0_2 0.0
 
xgc_0_0 wwl_0_0 wbl_0_0 weight_0_0 rwl_0_0 sn_0_0 vcc vss gcweight
xfa_0_0 weight_0_0 input_0_0 mac_0_0 cin_0_0 sum_0_0 cout_0_0 vdd vss norFA 
xrc_wwl_0_0 wwl_0 wwl_0_0 rc_unit R0=Rwwl C0=Cwwl
xrc_wbl_0_0 wbl_0 wbl_0_0 rc_unit R0=Rwbl C0=Cwbl
xrc_rwl_0_0 rwl_0 rwl_0_0 rc_unit R0=Rrwl C0=Crwl
xrc_input_0_0 input_0 input_0_0 rc_unit R0=Rrwl C0=Crwl
xrc_cin_0_0 cin_0 cin_0_0 rc_unit R0=Rrwl C0=Crwl
xgc_0_1 wwl_0_1 wbl_0_1 weight_0_1 rwl_0_1 sn_0_1 vcc vss gcweight
xfa_0_1 weight_0_1 input_0_1 mac_0_1 cin_0_1 sum_0_1 cout_0_1 vdd vss norFA 
xrc_wwl_0_1 wwl_0_0 wwl_0_1 rc_unit R0=Rwwl C0=Cwwl
xrc_wbl_0_1 wbl_1 wbl_0_1 rc_unit R0=Rwbl C0=Cwbl
xrc_rwl_0_1 rwl_0_0 rwl_0_1 rc_unit R0=Rrwl C0=Crwl
xrc_input_0_1 input_0_0 input_0_1 rc_unit R0=Rrwl C0=Crwl
xrc_cin_0_1 cout_0_0 cin_0_1 rc_unit R0=Rrwl C0=Crwl
xgc_0_2 wwl_0_2 wbl_0_2 weight_0_2 rwl_0_2 sn_0_2 vcc vss gcweight
xfa_0_2 weight_0_2 input_0_2 mac_0_2 cin_0_2 sum_0_2 cout_0_2 vdd vss norFA 
xrc_wwl_0_2 wwl_0_1 wwl_0_2 rc_unit R0=Rwwl C0=Cwwl
xrc_wbl_0_2 wbl_2 wbl_0_2 rc_unit R0=Rwbl C0=Cwbl
xrc_rwl_0_2 rwl_0_1 rwl_0_2 rc_unit R0=Rrwl C0=Crwl
xrc_input_0_2 input_0_1 input_0_2 rc_unit R0=Rrwl C0=Crwl
xrc_cin_0_2 cout_0_1 cin_0_2 rc_unit R0=Rrwl C0=Crwl
 
vww_0 wwl_0 0 DC='vhold'
vrw_0 rwl_0 0 DC=vsup
vcin_0 cin_0 0 DC=0
vinput_0 input_0 0 DC=0*vcore
vwb_0 wbl_0 0 DC=0
vwb_1 wbl_1 0 DC=0
vwb_2 wbl_2 0 DC=0
vvdd vdd 0 DC='vcore'
vvcc vcc 0 DC='vsup'
vvss vss 0 DC='vss'

.END