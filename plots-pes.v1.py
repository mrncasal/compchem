#!/usr/bin/env python
# coding: utf-8

## Feito para python 3


import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import matplotlib.font_manager as font_manager
import numpy as np
import argparse 
from matplotlib.ticker import FormatStrFormatter

# Possibilita a passagem de argumentos pelo terminal
parser = argparse.ArgumentParser(description='Create scatter CEPs of each state and N number of states together. Type of plot could be individual or group')
parser.add_argument('file')
parser.add_argument('number_excited_states')
parser.add_argument('type_of_plot')
parser.add_argument('min_y')
parser.add_argument('file_name')

args = parser.parse_args()

FILE = args.file
EXCITED_STATES=int(args.number_excited_states)
TYPE_OF_PLOT = args.type_of_plot
MIN_Y = float(args.min_y)
FILE_NAME = str(args.file_name)

#FILE = 'results2.txt'
#EXCITED_STATES=int(5)

# Lê as informações do arquivo result.txt em formato de tabela
df = pd.read_csv(FILE, sep=";")

# Identifica a primeira energia (S0) da primeira entrada de geometria (otimizada)
ground_state = df.iloc[0,0]

# Normaliza para a energia do S0 otimizado.
# Energia do estado fundamental otimizado - energia do x'ésimo estado
# .applymap aplica a função lambda (x - ground_state) para todas as células
df2 = df.applymap(lambda x: x - ground_state)

# df2.columns retorna a primeira linha
# no arquivo results.txt equivale a um número de 0 a 20 referente
# ao grau de distorção da geometria
x = list(df2.columns)

# df2.values retorna apenas os valores do DataFrame
# excluindo os nomes das colunas (primeira linhas)
state = df2.values.tolist()

############### FORMATACAO

from matplotlib import rcParams
#rcParams.update({'figure.autolayout': True})
#plt.tight_layout()

fig , ax = plt.subplots()

## Parametros dos eixos
#limite dos eixos: estabelece MAX_Y para maior valor de y e MAX_X para o maior valor de x do input fornecido

NUMBER_STATES = df2[:EXCITED_STATES+1]

MAX_Y = np.amax(np.amax(NUMBER_STATES, axis=0)) + 0.1*np.amax(np.amax(NUMBER_STATES, axis=0))
MAX_X = int(len(list(df[:0]))) - 1

ax.set_xlim(left=0,right=MAX_X)
ax.set_ylim(bottom=MIN_Y,top=MAX_Y)

# numero de casas decimais 
#ax.xaxis.set_major_formatter(FormatStrFormatter('%.3f'))

#linhas delimitando area de plotagem
ax.spines['top'].set_visible(True)
ax.spines['right'].set_visible(True)
ax.spines['bottom'].set_visible(True)
ax.spines['left'].set_visible(True)

#ticks de cada um dos eixos
ax.xaxis.set_tick_params(top=False, direction='out', width=1)
ax.xaxis.set_tick_params(bottom=True, direction='in', width=1)
ax.yaxis.set_tick_params(right=False, direction='out', width=1)
ax.yaxis.set_tick_params(bottom=True, direction='in', width=1)

#formatacao dos ticks dos eixos
plt.rc('font', family='sans-serif')
plt.rc('xtick', labelsize=8)
plt.rc('ytick', labelsize=8)

#tamanho do incremento no eixo
ax.xaxis.set_major_locator(ticker.MultipleLocator(1.0))

#numero de casas decimais no eixo x
#ax.yaxis.set_major_formatter(FormatStrFormatter("%.2f"))

#titulo dos eixos
ax.set_ylabel(r'$\Delta$E (eV)', fontsize=12)

distance = True
if distance == True:
    ax.set_xlabel('d ('r'$\AA$'')', fontsize=12)
#    ax.set_xlabel('d C-Si ('r'$\AA$'')', fontsize=12)
else:
        pass

angle = False 
if angle == True:
    ax.set_xlabel(r"${\Theta}$"' (C-Si-C-C)', fontsize=12)
else:
        pass

#tamanho do grafico
width = 5.0
height = 5.0
fig.set_size_inches(width, height)

##posicao da legenda
box = ax.get_position()

#Plota os estados separadamente
if TYPE_OF_PLOT == 'individual':
        f = 0
        while (f<= EXCITED_STATES):
            
            plt.plot(x, state[f], marker='o', label='S'+str(f), linewidth=1.0, markersize=4)
            
            #legenda ao lado do grafico
            ax.set_position([box.x0, box.y0, box.width*0.9, box.height])
            ax.legend(loc='upper right', bbox_to_anchor=(1.25, 1.00))

            #fonte da legenda
            font = font_manager.FontProperties(style='normal', size=10)
            ax.legend(prop=font)
            
            #salva o plot
            fig.savefig('CEP-S'+str(f)+'.png', dpi=600, transparent=True)
            
            #apaga a imagem do gráfico anterior para iniciar o próximo
            plt.clf()
                    
            f +=1
else:
    pass
    
#Plota todos os estados no mesmo gráfico
if TYPE_OF_PLOT == 'group':
    f = 0
    while (f<= EXCITED_STATES):

        plt.plot(x, state[f], marker='o', label='S'+str(f), linewidth=1.0, markersize=4)
        
        #legenda ao lado do grafico
#        ax.legend(loc='upper right', bbox_to_anchor=(1.25, 1.00))
        ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=5)

        f +=1
#    fig.savefig('CEP-'+str(EXCITED_STATES)+'states.png', dpi=600, transparent=True)
    fig.savefig(FILE_NAME+'.png', dpi=600, transparent=True)

else:
    pass

