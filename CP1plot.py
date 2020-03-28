#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Dec  1 19:59:56 2019

@author: noahlefrancois
"""

import numpy as np
import matplotlib.pyplot as plt

N = 100

def lnW(N, x):
    return -N*((0.5+x)*np.log(0.5+x)+(0.5-x)*np.log(0.5-x))


x = np.linspace(-0.5,0.5,100)

lnW = lnW(N, x)/N



plt.ylabel('# of Microstates Normalized')
plt.xlabel('x=f-0.5')
plt.plot(x, lnW, label='W(x)')
plt.legend()

