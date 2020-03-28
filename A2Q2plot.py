#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Dec  1 19:59:56 2019

@author: noahlefrancois
"""

import numpy as np
import matplotlib.pyplot as plt



def s_k(x):
    #return np.log(np.exp(-1/x)+np.exp(1/x))+(7/9)/x
    return np.log(np.exp(-x)+np.exp(x))+(7/9)*x


x = np.linspace(-10,10,10)

sk = s_k(x)



plt.ylabel('S/k')
plt.xlabel('B')
plt.plot(x, sk, label='Transmission')
plt.legend()

