import sys
sys.path.append("../")
from helper_funs import *
import re

sys(f'hspice dg_osfet_model_run.sp -o')

def generate_figname():
    ii = 0
    pwdpath = os.path.dirname(os.path.realpath(__file__))
    while os.path.isfile(os.path.join(pwdpath, f'temp{ii}.png')):
        ii = ii+1
    return f'temp{ii}.png'

main_directory_path = os.path.dirname(os.path.realpath(__file__))
num_datasets, df_list = read_lis_modified(fname=os.path.join(main_directory_path, "dg_osfet_model_run.lis"), sweep_variable='vgate')

id_list = []
vg_list = []

c = ['r']
s = ['solid']
a = [1]
# logy_lin_plot_dual(x1=vg_list, y1=id_list, x2=vg_list, y2=id_list, c1=c, c2=c, s1=s, s2=s, a1=a, a2=a, lw=4.0, figname=generate_figname(), ylim=[1e-15, 1e-4])
logy_plot(x=vg_list, y=id_list, c=c, s=s, lw=4.0, figname=generate_figname(), ylim=[1e-15, 1e-4])

df = pd.read_excel(f'benchmarking_data/Jimin_Harry_DGFET_data.xlsx')
print(df.columns)

eVg = df['Vg'].to_numpy()[0:161]
print(eVg)

# Vtg_all = [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2]
# for Vtg in Vtg_all:
#     id_list += [df[Vtg].to_numpy()[0:161]]
#     vg_list += [eVg]

id_list += [df['current_vs'] for df in df_list]
vg_list += [df['voltage_g'] for df in df_list]

c = ['k']*9 + ['r']*9
s = [None]*9 +['solid']*9
m = ['o']*9 + [None]*9
logy_plot(x=vg_list, y=id_list, c=c, s=s, m=m, lw=4.0, figname=generate_figname(), ylim=[1e-15, 1e-4], ylabel='$I_{D}$ [A]', xlabel='$V_{G}$ [V]')

# import numpy as np
# import pandas as pd

# # Example data: lists of numpy arrays
# id_list = [np.random.rand(3) for _ in range(5)]  # Replace with your data
# vg_list = [np.random.rand(3) for _ in range(5)]  # Replace with your data

# Create a dictionary to store data for the DataFrame
data = {}

# Add Id_list arrays to the dictionary, each in a separate column
for idx, arr in enumerate(id_list):
    data[f'Id_list_{idx}'] = arr

# Add Vg_list arrays to the dictionary, each in a separate column
for idx, arr in enumerate(vg_list):
    data[f'Vg_list_{idx}'] = arr

# Create a DataFrame from the dictionary
df = pd.DataFrame(data)

# Save the DataFrame to an Excel file
df.to_excel('output.xlsx', index=False)

print('Data has been saved to output.xlsx')


