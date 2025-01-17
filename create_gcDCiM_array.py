from os import system as sys
import fileinput as fi
import numpy as np

params = dict(
            version=0.00, Tjun=300, mu_eff=17.75e-4, W=320e-9, WL = 160e-9, Lg=250e-9, Cg=0.0124, Cpar=1.24e-12, longVT=0.6, alpha1=0.774175, alpha2=0.043085, meff=0.3, rsd_mode=0, Rs0=60e-6, Rd0=60e-6, n0=1.0, nd=0.0, delta=0.0, rollVT=0.0, type=1, \
            vsup = 1.8, vcore=0.9, vss = 0, step = 1e-12, sim_time = 100e-6, \
            vhold = 0, vboost = 2.5, wwl_del = 2e-9, wwl_rise = 500e-12, wwl_fall = 500e-12,  wwl_pw = 10e-9, wwl_tp = 100e-9, \
            vread = 1.8, rwl_del = 20e-9, rwl_rise = 500e-12, rwl_fall = 500e-12,  rwl_pw = 50e-9, rwl_tp = 100e-9, \
            vnone = 0, vwbit = 1.8, wbl_del = 1e-9, wbl_rise = 500e-12, wbl_fall = 500e-12,  wbl_pw = 12e-9, wbl_tp = 100e-9, \
            Rwwl = 1e3, Cwwl = 1e-16, Rwbl = 1e3, Cwbl = 1e-16, Rrwl = 1e3, Crwl = 1e-16, Rrbl = 1e3, Crbl = 1e-16 \
            )

Nrows = 1 # num of word lines
Ncols = 3 # word length
wwl_en = [1]
rwl_en = [1]

#vsn_init = [[0 for _ in range(Ncols)] for _ in range(Nrows)]
vsn_init = np.random.choice([0, float(params["vwbit"])], size=(Nrows, Ncols), p=[0.5, 0.5])
vmac_init = np.random.choice([0, float(params["vcore"])], size=(Nrows, Ncols), p=[0.5, 0.5])
input = np.random.choice([0, 1], size=Nrows, p=[0.5, 0.5])
is_lines = list(fi.input(files = f'create_gcDCiM_array_starter.txt'))
starter = []

for line in is_lines:
    line_list = line.split()
    if len(line_list) == 4:
        if line_list[0] == ".PARAM" and line_list[3] == 'xxx':
            line_list[3] = str(params[line_list[1]])
    starter.append(' '.join(line_list))

for ii in range(Nrows):
    for jj in range(Ncols):
        starter.append(f".DCVOLT sn_{ii}_{jj} {vsn_init[ii][jj]}")
        starter.append(f".DCVOLT mac_{ii}_{jj} {vmac_init[ii][jj]}")

gc_netlist = [' ']
#for ii in range(Nrows):
#    for jj in range(Ncols):
        


for ii in range(Nrows):
    for jj in range(Ncols):
        ## instantiate instances
        ## connect wires through parasitics
        gc_netlist.append(f'xgc_{ii}_{jj} wwl_{ii}_{jj} wbl_{ii}_{jj} weight_{ii}_{jj} rwl_{ii}_{jj} sn_{ii}_{jj} vcc vss gcweight')
        gc_netlist.append(f'xfa_{ii}_{jj} weight_{ii}_{jj} input_{ii}_{jj} mac_{ii}_{jj} cin_{ii}_{jj} sum_{ii}_{jj} cout_{ii}_{jj} vdd vss norFA ')
        
        if ii == 0 and jj == 0:
            gc_netlist.append(f'xrc_wwl_{ii}_{jj} wwl_{ii} wwl_{ii}_{jj} rc_unit R0=Rwwl C0=Cwwl')
            gc_netlist.append(f'xrc_wbl_{ii}_{jj} wbl_{jj} wbl_{ii}_{jj} rc_unit R0=Rwbl C0=Cwbl')
            gc_netlist.append(f'xrc_rwl_{ii}_{jj} rwl_{ii} rwl_{ii}_{jj} rc_unit R0=Rrwl C0=Crwl')
            gc_netlist.append(f'xrc_input_{ii}_{jj} input_{ii} input_{ii}_{jj} rc_unit R0=Rrwl C0=Crwl')
            gc_netlist.append(f'xrc_cin_{ii}_{jj} cin_{ii} cin_{ii}_{jj} rc_unit R0=Rrwl C0=Crwl')  ## initial cin
            #gc_netlist.append(f'xrc_rbl_{ii}_{jj} rbl_{jj} rbl_{ii}_{jj} rc_unit R0=Rrbl C0=Crbl')
        elif ii == 0 and jj != 0:
            gc_netlist.append(f'xrc_wwl_{ii}_{jj} wwl_{ii}_{jj-1} wwl_{ii}_{jj} rc_unit R0=Rwwl C0=Cwwl')
            gc_netlist.append(f'xrc_wbl_{ii}_{jj} wbl_{jj} wbl_{ii}_{jj} rc_unit R0=Rwbl C0=Cwbl')
            gc_netlist.append(f'xrc_rwl_{ii}_{jj} rwl_{ii}_{jj-1} rwl_{ii}_{jj} rc_unit R0=Rrwl C0=Crwl')
            gc_netlist.append(f'xrc_input_{ii}_{jj} input_{ii}_{jj-1} input_{ii}_{jj} rc_unit R0=Rrwl C0=Crwl')
            gc_netlist.append(f'xrc_cin_{ii}_{jj} cout_{ii}_{jj-1} cin_{ii}_{jj} rc_unit R0=Rrwl C0=Crwl') ## connect cout to next cin

            #gc_netlist.append(f'xrc_rbl_{ii}_{jj} rbl_{jj} rbl_{ii}_{jj} rc_unit R0=Rrbl C0=Crbl')
        elif jj == 0 and ii != 0:
            gc_netlist.append(f'xrc_wwl_{ii}_{jj} wwl_{ii} wwl_{ii}_{jj} rc_unit R0=Rwwl C0=Cwwl')
            gc_netlist.append(f'xrc_wbl_{ii}_{jj} wbl_{ii-1}_{jj} wbl_{ii}_{jj} rc_unit R0=Rwbl C0=Cwbl')
            gc_netlist.append(f'xrc_rwl_{ii}_{jj} rwl_{ii} rwl_{ii}_{jj} rc_unit R0=Rrwl C0=Crwl')
            gc_netlist.append(f'xrc_input_{ii}_{jj} input_{ii} input_{ii}_{jj} rc_unit R0=Rrwl C0=Crwl')
            gc_netlist.append(f'xrc_cin_{ii}_{jj} cin_{ii} cin_{ii}_{jj} rc_unit R0=Rrwl C0=Crwl')  ## initial cin
            #gc_netlist.append(f'xrc_rbl_{ii}_{jj} rbl_{ii-1}_{jj} rbl_{ii}_{jj} rc_unit R0=Rrbl C0=Crbl')
        else:
            gc_netlist.append(f'xrc_wwl_{ii}_{jj} wwl_{ii}_{jj-1} wwl_{ii}_{jj} rc_unit R0=Rwwl C0=Cwwl')
            gc_netlist.append(f'xrc_wbl_{ii}_{jj} wbl_{ii-1}_{jj} wbl_{ii}_{jj} rc_unit R0=Rwbl C0=Cwbl')
            gc_netlist.append(f'xrc_rwl_{ii}_{jj} rwl_{ii}_{jj-1} rwl_{ii}_{jj} rc_unit R0=Rrwl C0=Crwl')
            gc_netlist.append(f'xrc_input_{ii}_{jj} input_{ii}_{jj-1} input_{ii}_{jj} rc_unit R0=Rrwl C0=Crwl')
            gc_netlist.append(f'xrc_cin_{ii}_{jj} cout_{ii}_{jj-1} cin_{ii}_{jj} rc_unit R0=Rrwl C0=Crwl') ## connect cout to next cin

            #gc_netlist.append(f'xrc_rbl_{ii}_{jj} rbl_{ii-1}_{jj} rbl_{ii}_{jj} rc_unit R0=Rrbl C0=Crbl')

signal_netlist = [' ']
for ii in range(Nrows):
    signal_netlist.append(f"vww_{ii} wwl_{ii} 0 DC='vhold'")
    
    #signal_netlist.append(f"vww_{ii} wwl_{ii} 0 PULSE 'vhold' '{wwl_en[ii]}*vboost' 'wwl_del' 'wwl_rise' 'wwl_fall' 'wwl_pw' 'wwl_tp'")
    #signal_netlist.append(f"vrw_{ii} rwl_{ii} 0 PULSE '0' 'vread' 'rwl_del' 'rwl_rise' 'rwl_fall' 'rwl_pw' 'rwl_tp'")
    signal_netlist.append(f"vrw_{ii} rwl_{ii} 0 DC=vsup")
    signal_netlist.append(f"vcin_{ii} cin_{ii} 0 DC=0")
    signal_netlist.append(f"vinput_{ii} input_{ii} 0 DC={input[ii]}*vcore")

for jj in range(Ncols):
    signal_netlist.append(f"vwb_{jj} wbl_{jj} 0 DC=0")
    

ie_lines = list(fi.input(files = f'create_gcDCiM_array_ender.txt'))
ender = []
## add measure command
for line in ie_lines:
    line_list = line.split()
    if len(line_list) == 4:
        if line_list[0] == ".PARAM" and line_list[3] == 'xxx':
            line_list[3] = str(params[line_list[1]])
    ender.append(' '.join(line_list))

with open(f'gc_array.sp', 'w') as fp:
    fp.write('\n'.join(starter+gc_netlist+signal_netlist+ender))
fp.close()

sys(f'hspice gc_array.sp -o')

