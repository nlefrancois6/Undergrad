# -*- coding: utf-8 -*-
"""
Created on Tue Sep 17 13:22:04 2019

@author: Max Molot
"""

# -*- coding: utf-8 -*-

import spinmob as sm
import mcphysics as mp
import numpy as np


d = mp.data.load_chn()
data = d[1];
counts = np.array(data)
marker = np.array(range(0,len(counts)))*3.9246 + 6.5528
f = sm.data.fitter()
f.set_functions('a*x+b + c*exp(-(x-x0)**2/(2*s**2))', 'a, b, c, x0, s')
f.set_data(marker,counts,(counts**0.5))

