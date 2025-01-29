** dgosfet model test
.PROBE DC
+    V(g)
+    I(vs)
.PRINT DC
+    V(g)
+    I(vs)

.PARAM vdrainlin = 50e-3
.PARAM vdrainsat = 2
.PARAM vdrain = vdrainlin
.PARAM vgateh = 2
.PARAM vgatel = -2 
.PARAM vgate = vgatel
.PARAM vsource = 0
.PARAM vtgate = 0

* .DC vgate LIN 100.0 'vgatel' 'vgateh'
.DC vgate LIN 121 'vgatel' 'vgateh' SWEEP vtgate LIN 9 -2 2

.TEMP 25.0
.OPTION
+    ARTIST=2
+    INGOLD=2
+    PARHIER=LOCAL
+    PSF=2

.HDL dg_osfet_potential_based_compact_model_v0.va

xos d g s tg dgosfet 

vd d 0 DC='vdrain'
vg g 0 DC='vgate'
vs s 0 DC='vsource'
vtg tg 0 DC='vtgate'

.END