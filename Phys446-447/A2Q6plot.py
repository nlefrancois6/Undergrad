#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Dec  1 19:59:56 2019

@author: noahlefrancois
"""

import numpy as np
import matplotlib.pyplot as plt

B=10
k=1
phi=0

t1magsq = 1/(1+B**2)
r1magsq = B**2/(1+B**2)

def Pt(L, t1magsq, r1magsq, phi, k):
    return t1magsq**2/(1 + r1magsq**2 - 2*r1magsq*np.cos(2*k*L + 2*phi))


L = np.linspace(0,10,10000)

Pt = Pt(L,t1magsq, r1magsq, phi, k)



plt.ylabel('Probability')
plt.xlabel('Cavity Length')
plt.plot(L, Pt, label='Transmission')
plt.legend()

