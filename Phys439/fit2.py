# -*- coding: utf-8 -*-
"""
Created on Tue Sep 17 13:24:43 2019

@author: Max Molot
"""

f.trim()
f.set(ymin=2, x0=(f['xmin'][0]+f['xmax'][0])/2, a = 0, b = 0, s = 20, c = 1000)
f.fit()
a = f.get_fit_results()

