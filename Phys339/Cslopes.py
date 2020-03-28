#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 22 12:56:11 2019

@author: noahlefrancois
"""
import numpy as np
import matplotlib.pyplot as plt

#Load raw data, convert to time and temperature arrays
T330 = np.loadtxt('Tslope_fan_T330.csv', delimiter = ',', unpack = True)
T350 = np.loadtxt('Tslope_fan_T350.csv', delimiter = ',', unpack = True)
T370 = np.loadtxt('Tslope_fan_T370.csv', delimiter = ',', unpack = True)


time330 = T330[5,246:890]
temp330 = T330[4,246:890]

time350 = T350[5,173:381]
temp350 = T350[4,173:381]

time370 = T370[5,120:270]
temp370 = T370[4,120:270]


#Find slope of each line of zero power input, calculate uncertainty
fit330, cov330 = np.polyfit(time330,temp330,1, cov=True)
fit350, cov350  = np.polyfit(time350,temp350,1,cov=True)
fit370, cov370  = np.polyfit(time370,temp370,1,cov=True)
slopes = [10*fit330[0],10*fit350[0],10*fit370[0]]

err330 = np.sqrt(cov330[0,0])
err350 = np.sqrt(cov350[0,0])
err370 = np.sqrt(cov370[0,0])
errs = [err330, err350, err370]
#print(slopes)
#print(errs)

#plt.plot(time330,temp330)
#plt.plot(time350,temp350)
#plt.plot(time370,temp370)

#Calculate Power=Rcool
R = 22
Is = [0.28,0.33,0.47]
P330 = R*Is[0]**2
P350 = R*Is[1]**2
P370 = R*Is[2]**2

Rcools = [P330, P350, P370]
#print(Rcools)

#Calculate Heat Capacity
C330 = -Rcools[0]/slopes[0]
C350 = -Rcools[1]/slopes[1]
C370 = -Rcools[2]/slopes[2]
#print(C330)
#print(C350)
#print(C370)

#Calculate Expected Aluminum Mass
c = 0.900
errc = 0.001
m330 = C330/c
m350 = C350/c
m370 = C370/c
mass = [m330,m350,m370]
print(mass)

#Error Propogation
errIs = [0.02,0.03,0.03]
errR = 3
errdTs = [0.0002,0.001,0.001]

errIsq30 = (Is[0]**2)*2*(errIs[0]/Is[0])
errIsq50 = (Is[1]**2)*2*(errIs[1]/Is[1])
errIsq70 = (Is[2]**2)*2*(errIs[2]/Is[2])
errIsqs = [errIsq30,errIsq50,errIsq70]
#print(errIsqs)

errP330 = P330*np.sqrt((errIsqs[0]/(Is[0]**2))**2+(errR/R)**2)
errP350 = P350*np.sqrt((errIsqs[1]/(Is[1]**2))**2+(errR/R)**2)
errP370 = P370*np.sqrt((errIsqs[2]/(Is[2]**2))**2+(errR/R)**2)
#print(errP370)

errC330 = C330*np.sqrt((errP330/P330)**2+(errdTs[0]/slopes[0])**2)
errC350 = C350*np.sqrt((errP350/P350)**2+(errdTs[1]/slopes[1])**2)
errC370 = C370*np.sqrt((errP370/P370)**2+(errdTs[2]/slopes[2])**2)
#print(errC370)

errM330 = mass[0]*np.sqrt((errC330/C330)**2+(errc/c)**2)
errM350 = mass[1]*np.sqrt((errC350/C350)**2+(errc/c)**2)
errM370 = mass[2]*np.sqrt((errC370/C370)**2+(errc/c)**2)
print(errM350)




