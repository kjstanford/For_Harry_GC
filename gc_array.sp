** gc array model

.PARAM vsup = 1.8
.PARAM step = 1e-12
.PARAM sim_time = 3e-08

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
.PARAM rwl_pw = 5e-09
.PARAM rwl_tp = 1e-07

.PARAM vnone = 0
.PARAM vwbit = 1.8
.PARAM wbl_del = 1e-09
.PARAM wbl_rise = 5e-10
.PARAM wbl_fall = 5e-10
.PARAM wbl_pw = 1.2e-08
.PARAM wbl_tp = 1e-07

.PARAM version = 0.0
.PARAM Tjun = 300
.PARAM mu_eff = 0.001775
.PARAM W = 3.2e-07
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

.SUBCKT wos_ros_gc wwl wbl rwl rbl sn vdd
xos wbl wwl sn osfet
+ version='version' Tjun='Tjun' mu_eff='mu_eff' W='W' Lg='Lg' Cg='Cg' Cpar='Cpar' longVT='longVT'
+ alpha1='alpha1' alpha2='alpha2' meff='meff' rsd_mode='rsd_mode' Rs0='Rs0' Rd0='Rd0'
+ delta='delta' n0='n0' nd='nd' rollVT='rollVT' type='type'

xosr rbl sn rwl osfet
+ version='version' Tjun='Tjun' mu_eff='mu_eff' W='W' Lg='Lg' Cg='Cg' Cpar='Cpar' longVT='longVT'
+ alpha1='alpha1' alpha2='alpha2' meff='meff' rsd_mode='rsd_mode' Rs0='Rs0' Rd0='Rd0'
+ delta='delta' n0='n0' nd='nd' rollVT='rollVT' type='type'
.ENDS

.SUBCKT wos_rpsi25ud18_gc wwl wbl rwl rbl sn vdd
xos wbl wwl sn osfet
+ version='version' Tjun='Tjun' mu_eff='mu_eff' W='W' Lg='Lg' Cg='Cg' Cpar='Cpar' longVT='longVT'
+ alpha1='alpha1' alpha2='alpha2' meff='meff' rsd_mode='rsd_mode' Rs0='Rs0' Rd0='Rd0'
+ delta='delta' n0='n0' nd='nd' rollVT='rollVT' type='type'

m0 rbl sn rwl vdd pch_25ud18 l=250e-9 w=320e-9 m=1 nf=1 sd=220e-9 ad=48e-15 as=48e-15 pd=940e-9 ps=940e-9 nrd=0 nrs=0 sa=150e-9 sb=150e-9
.ENDS

.TRAN 'step' 'sim_time'
.DCVOLT sn_0_0 0
 
xgc_0_0 wwl_0 wbl_0 rwl_0 rbl_0 sn_0_0 vdd wos_rpsi25ud18_gc
 
vww_0 wwl_0 0 PULSE 'vhold' '1*vboost' 'wwl_del' 'wwl_rise' 'wwl_fall' 'wwl_pw' 'wwl_tp'
vrw_0 rwl_0 0 PULSE '0' '1*vread' 'rwl_del' 'rwl_rise' 'rwl_fall' 'rwl_pw' 'rwl_tp'
vwb_0 wbl_0 0 PULSE 'vnone' '1*vwbit' 'wbl_del' 'wbl_rise' 'wbl_fall' 'wbl_pw' 'wbl_tp'
vrb_0 rbl_0 0 DC=0
vvdd vdd 0 DC='vsup'

.END