#!/usr/bin/env python
# coding: utf-8

## README:
# Input: arquivo csv.
# x: primeira linha
# cada série de dados: cada linha
# não pode conter labels na primeira coluna.

## PARÂMETROS QUE PRECISO ESCOLHER
FONTSIZE = 11
EXCITED_STATES = 6     # Número de estados para aparecer no gráfico
INITIAL_STATE = 0

TYPE = "EE"
#TYPE = "POS"
#TYPE = "CT"

if TYPE == "EE":
    MAX_Y = 4.5   # EE
    MIN_Y = -0.5   # EE
    YLABEL = "Relative Energy (eV)"

elif TYPE == "POS":
    MAX_Y = 2.0   # POS
    MIN_Y = 1.0   # POS
    YLABEL = "POS"
else:
    MAX_Y = 1.0   # CT
    MIN_Y = 0.0   # CT
    YLABEL = "CT"

## MODULES
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
import matplotlib.ticker as ticker
from matplotlib.ticker import FormatStrFormatter
from matplotlib import rcParams
import argparse 
import pandas as pd
import numpy as np

# cria uma lista de todos os arquivos csv na pasta e retira a string .csv
from glob import glob
FILES = [x.rstrip(".csv") for x in glob("*.csv")]
#FILES = [x.rstrip(".csv") for x in glob("*BHandHLYP*")]
#FILES = ['energias.relativas']

def plot_graph(file):
    ## FORMATACAO

    #rcParams.update({'figure.autolayout': True})
    fig , ax = plt.subplots()
    #plt.figure()
    plt.tight_layout()

    # numero de casas decimais 
    ax.xaxis.set_major_formatter(FormatStrFormatter('%.2f'))

    #linhas delimitando area de plotagem
    ax.spines['top'].set_visible(True)
    ax.spines['right'].set_visible(True)
    ax.spines['bottom'].set_visible(True)
    ax.spines['left'].set_visible(True)
    
    #ticks de cada um dos eixos
    ax.xaxis.set_tick_params(top=False, direction='in', width=2)
    #ax.xaxis.set_tick_params(bottom=True, direction='in', width=2)
    ax.yaxis.set_tick_params(right=False, direction='in', width=2)
    #ax.yaxis.set_tick_params(bottom=True, direction='in', width=2)

    #formatacao dos ticks dos eixos
    plt.rc('font', family='sans-serif')
    plt.tick_params(axis='y',bottom=True,which='minor',length=5,width=1, direction='in')
    plt.tick_params(axis='y',bottom=True,which='major',length=5,width=1, direction='in')
    plt.tick_params(axis='x',bottom=True,length=5,width=1)
    #plt.tick_params(axis='y',right=False,which='minor')
    
    ticky = np.arange(MIN_Y, MAX_Y, step=0.5)
    ax.set_yticks(ticky ,minor=True)
    plt.tick_params(axis='y',right=False,which='minor')
 
    #ax.tick_params(axis='both', which='major', labelsize=FONTSIZE)

    #tamanho do incremento no eixo
    ax.xaxis.set_major_locator(ticker.MultipleLocator(1.0))

    # valores máximos de x e y
    ax.set_xlim(left=-0.4,right=5.0)
    ax.set_ylim(bottom=MIN_Y,top=MAX_Y)

    #numero de casas decimais nos eixos
    ax.yaxis.set_major_formatter(FormatStrFormatter("%.1f"))
    ax.xaxis.set_major_formatter(FormatStrFormatter("%.0f"))

    #tamanho do grafico
    # gráficos em tamanho 8.5 x 8.5, em inches = 3,34646
    width = 3.34646
    #width = 6.69292
    #height = 1.67323
    height = 3.34646
    fig.set_size_inches(width, height)

    ##posicao da legenda
    box = ax.get_position()

    #plt.figure()

    # Lê as informações do arquivo FILE em formato de tabela
    dados = pd.read_csv(file + ".csv", sep="\t")

    # Transforma os elementos de dados em float
    dados1 = list(dados.columns)
    x = [float(i) for i in dados1]
    energies = (dados.values)


    f = INITIAL_STATE
    colors = ['#363636','#6A5ACD','#DAA520','#00BFFF','#32CD32','#A0522D','#FF0000','#FA8072','#BDB76B']
    while (f <= EXCITED_STATES):
        plt.plot(x, energies[f], marker='.', label = 'S'+str(f), color=colors[f], linewidth=1.0, markersize=6)
        f += 1

    plt.xlabel("Relative distance ($\AA$)", fontsize=FONTSIZE)
    plt.ylabel(YLABEL, fontsize=FONTSIZE)

    ax.legend(frameon=False, fontsize=FONTSIZE, loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=4)
    fig.savefig(file +'mariana.png', dpi=600, transparent=True, bbox_inches='tight')
    fig.savefig(file +'mariana.svg', dpi=600, transparent=True, bbox_inches='tight')
    plt.close()


for file in FILES:
	plot_graph(file)
