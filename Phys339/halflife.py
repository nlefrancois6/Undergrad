#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Feb 18 12:13:13 2019

@author: maureenpollard
"""
import numpy as np

lamb = 1/((30.2*10*4))*10**(-6)
tHalf = -np.log(0.5)/lamb
tY = tHalf/(60*60*24*365)
print(lamb)
print(tHalf)
print(tY)
