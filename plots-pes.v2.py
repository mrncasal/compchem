#!/usr/bin/env python
# coding: utf-8

  ## Create the PES plot in PNG starting from an input file where:
  ## First line: S0 absolute energies
  ## Following lines: excitation energies of the following state
  ## Script for input generationi in GAUSSIAN: pes_processing_input.sh
  ## python3 script file number_states
  ## 03/03/2020

  ## Example of input file:
  ## -1182.10104880 -1182.09454065 -1182.08064322 
  ## 3.1919 3.1522 3.0922 
  ## 5.0324 4.6084 3.8125 
  ## 5.0793 4.9172 4.7274 
  ## 5.1537 5.0121 4.9436 
  ## 5.1955 5.1174 5.1011 
  ## 5.2217 5.2648 5.3137 
  ## 5.5116 5.3996 5.3708 
  ## 5.9234 5.9091 5.4368
  ## 6.5519 6.0140 5.8947 
  ## 6.5728 6.4447 6.1710 

import pandas as pd
import numpy as np
import argparse
import glob

  ## 1) Argument parsers
parser = argparse.ArgumentParser(description='PES post-processing')
parser.add_argument('file')
parser.add_argument('number_states')

args = parser.parse_args()
FILE = args.file
NUMBER_STATES=int(args.number_states)

# FILE = "/home/mariana/Documents/01-Em.andamento/08-BoostCrop/04-Molecules/36-DPP/08-LIIC.OPTS1.CI/02-DPP-w.lateral.groups/pes_energies.dat"
# NUMBER_STATES = 2
au2ev = 27.211

RAW_DATA_df = pd.read_csv(FILE, header=None, sep=" ")
# RAW_DATA_df = RAW_DATA_df

  ## 2) PES
   # Conversion au to eV
RAW_DATA_df = RAW_DATA_df.apply(lambda x: x*au2ev if x.name == 0 else x, axis=1)

   # Absolute energy value (in eV)
ABS_ENERGIES = RAW_DATA_df + RAW_DATA_df.loc[0].values.squeeze()
ABS_ENERGIES.loc[0] = RAW_DATA_df.loc[0]
print(ABS_ENERGIES)

ABS_ENERGIES.to_csv(r'abs.energies', sep=' ', mode='a')


   # Normalized plot
S0_MIN = np.amin(ABS_ENERGIES.values[0])
NORM_ENERGIES = ABS_ENERGIES - S0_MIN
MAX_ENERGY = np.amax(NORM_ENERGIES.values[NUMBER_STATES])

   # x values
x=[i for i in range(NORM_ENERGIES.shape[1])] 

# print(S0_MIN)
# print (MAX_ENERGY)
# print(NORM_ENERGIES)


  ## PLOT 

import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import matplotlib.font_manager as font_manage
from matplotlib.ticker import FormatStrFormatter
from matplotlib import rcParams

fig , ax = plt.subplots()

   # Axis parameters
   # limite dos eixos: estabelece MAX_Y para maior valor de y e MAX_X para o maior valor de x do input fornecido

MAX_Y = MAX_ENERGY + 0.1*MAX_ENERGY
MIN_Y = 0
# MAX_X = int(len(list(df[:0]))) - 1

# # ax.set_xlim(left=0,right=MAX_X)
# ax.set_ylim(bottom=MIN_Y,top=MAX_Y)
ax.set_ylim(top=MAX_Y)

  # numero de casas decimais 

#ax.xaxis.set_major_formatter(FormatStrFormatter('%.3f'))

  # linhas delimitando area de plotagem
ax.spines['top'].set_visible(True)
ax.spines['right'].set_visible(True)
ax.spines['bottom'].set_visible(True)
ax.spines['left'].set_visible(True)

  # ticks de cada um dos eixos
ax.xaxis.set_tick_params(top=False, direction='out', width=1)
ax.xaxis.set_tick_params(bottom=True, direction='in', width=1)
ax.yaxis.set_tick_params(right=False, direction='in', width=1)
ax.yaxis.set_tick_params(bottom=True, direction='in', width=1)

  # formatacao dos ticks dos eixos
plt.rc('font', family='sans-serif')
plt.tick_params(axis='y',bottom=True,which='minor',length=2,width=1, direction='in')
plt.tick_params(axis='y',bottom=True,which='major',length=4,width=1, direction='in')
plt.tick_params(axis='x',bottom=True,length=4,width=1)

step = 0.25
ticky = np.arange(MIN_Y, MAX_Y, step)
ax.set_yticks(ticky, minor=True)
plt.tick_params(axis='y',right=False,which='minor')

  # tamanho do incremento no eixo
ax.xaxis.set_major_locator(ticker.MultipleLocator(1.0))

  # numero de casas decimais no eixo y
ax.yaxis.set_major_formatter(FormatStrFormatter("%.2f"))

  # titulo dos eixos
ax.set_ylabel(r'$\Delta$E (eV)', fontsize=12)
#ax.set_xlabel('d ('r'$\AA$'')', fontsize=12)
ax.set_xlabel('LIIC Step', fontsize=12)

  # tamanho do grafico
width=5.0
height = 5.0
fig.set_size_inches(width, height)

  # posicao da legenda
box = ax.get_position()


  # Plot of states
f = 0
colors = ["#004586", "#ff420e" , "#579d1c" , "#7e0021", "#ff6d00" , "#46bdc6", "#ffd320", "#875F9A", "#6C7A89", "#003171", "#F47983"]

while (f<= NUMBER_STATES):
    plt.plot(x, NORM_ENERGIES.iloc[f], marker='o', label='S'+str(f), color=colors[f], linewidth=2.0, markersize=5)

    # legenda ao lado do grafico
    # ax.legend(loc='lower right', bbox_to_anchor=(1.05, 0.05), frameon=None)
    # ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=5)
    f +=1

  # Saving the image
#fig.savefig('CEP-'+str(EXCITED_STATES)+'states.png', dpi=600, transparent=True)
fig.savefig(FILE+'.png', dpi=300, transparent=False)


