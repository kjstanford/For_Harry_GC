from os import system as sys
import fileinput as fi

params = dict(
            version=0.00, Tjun=300, mu_eff=17.75e-4, W=4e-6, Lg=2e-6, Cg=0.0124, Cpar=1.24e-12, longVT=0.6, alpha1=0.774175, alpha2=0.043085, meff=0.3, rsd_mode=0, Rs0=60e-6, Rd0=60e-6, n0=1.0, nd=0.0, delta=0.0, rollVT=0.0, type=1, \
            vsup = 1.8, step = 1e-12, sim_time = 30e-9, \
            vhold = 0, vboost = 2.5, wwl_del = 2e-9, wwl_rise = 500e-12, wwl_fall = 500e-12,  wwl_pw = 10e-9, wwl_tp = 100e-9, \
            vread = 1.8, rwl_del = 20e-9, rwl_rise = 500e-12, rwl_fall = 500e-12,  rwl_pw = 5e-9, rwl_tp = 100e-9, \
            vnone = 0, vwbit = 1.8, wbl_del = 1e-9, wbl_rise = 500e-12, wbl_fall = 500e-12,  wbl_pw = 12e-9, wbl_tp = 100e-9 \
            )

Nrows = 4 # num of word lines
Ncols = 4 # word length
wwl_en = [0, 0, 1, 0]
rwl_en = [0, 0, 1, 0]
wword = [1, 0, 0, 1]
vsn_init = [[0 for _ in range(Ncols)] for _ in range(Nrows)]

is_lines = list(fi.input(files = f'create_gc_array_starter.txt'))
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

gc_netlist = [' ']
for ii in range(Nrows):
    for jj in range(Ncols):
        gc_netlist.append(f'xgc_{ii}_{jj} wwl_{ii} wbl_{jj} rwl_{ii} rbl_{jj} sn_{ii}_{jj} wos_ros_gc')

signal_netlist = [' ']
for ii in range(Nrows):
    signal_netlist.append(f"vww_{ii} wwl_{ii} 0 PULSE 'vhold' '{wwl_en[ii]}*vboost' 'wwl_del' 'wwl_rise' 'wwl_fall' 'wwl_pw' 'wwl_tp'")
    signal_netlist.append(f"vrw_{ii} rwl_{ii} 0 PULSE '0' '{rwl_en[ii]}*vread' 'rwl_del' 'rwl_rise' 'rwl_fall' 'rwl_pw' 'rwl_tp'")

for jj in range(Ncols):
    signal_netlist.append(f"vwb_{jj} wbl_{jj} 0 PULSE 'vnone' '{wword[jj]}*vwbit' 'wbl_del' 'wbl_rise' 'wbl_fall' 'wbl_pw' 'wbl_tp'")
    signal_netlist.append(f"vrb_{jj} rbl_{jj} 0 DC=0")

ie_lines = list(fi.input(files = f'create_gc_array_ender.txt'))
ender = []

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

