# -*- coding: utf-8 -*-
"""
Created on Mon Apr  8 19:51:14 2019

@author: me
"""

import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import curve_fit

def linear(X,a,b):
    return [a*x + b for x in X]


d3 = np.loadtxt('SoS_d3cm.csv' , delimiter = ',')
d5 = np.loadtxt('SoS_d5cm.csv' , delimiter = ',')
d10 = np.loadtxt('SoS_d10cm.csv' , delimiter = ',')
d15 = np.loadtxt('SoS_d15cm.csv' , delimiter = ',')
d20 = np.loadtxt('SoS_d20cm.csv' , delimiter = ',')
d25 = np.loadtxt('SoS_d25cm.csv' , delimiter = ',')      # FIRST RUN HAS BAD DATA
d30 = np.loadtxt('SoS_d30cm.csv' , delimiter = ',')
d50 = np.loadtxt('SoS_d50cm.csv' , delimiter = ',')
d80 = np.loadtxt('SoS_d80cm.csv' , delimiter = ',')

dist = np.array([3,5,10,15,20,25,30,50,80])
relerr = np.zeros(9)

sumForErr3 = 0
sumForErr5 = 0
sumForErr10 = 0
sumForErr15 = 0
sumForErr20 = 0
sumForErr25 = 0
sumForErr30 = 0
sumForErr50 = 0
sumForErr80 = 0

sumForMean3 = 0
sumForMean5 = 0
sumForMean10 = 0
sumForMean15 = 0
sumForMean20 = 0
sumForMean25 = 0
sumForMean30 = 0
sumForMean50 = 0
sumForMean80 = 0

sumForRelM3 = 0
sumForRelM5 = 0
sumForRelM10 = 0
sumForRelM15 = 0
sumForRelM20 = 0
sumForRelM25 = 0
sumForRelM30 = 0
sumForRelM50 = 0
sumForRelM80 = 0

sumForRelU3 = 0
sumForRelU5 = 0
sumForRelU10 = 0
sumForRelU15 = 0
sumForRelU20 = 0
sumForRelU25 = 0
sumForRelU30 = 0
sumForRelU50 = 0
sumForRelU80 = 0

for i in range(10):
    
    if (i > 0):
        sumForErr25 += 1/(d25[i][1])**2
        sumForMean25 += d25[i][0]/(d25[i][1])**2
        sumForRelM25 += d25[i][1]/d25[i][0]
        
    sumForErr3 += 1/(d3[i][1])**2
    sumForErr5 += 1/(d5[i][1])**2
    sumForErr10 += 1/(d10[i][1])**2
    sumForErr15 += 1/(d15[i][1])**2
    sumForErr20 += 1/(d20[i][1])**2
    sumForErr30 += 1/(d30[i][1])**2
    sumForErr50 += 1/(d50[i][1])**2
    sumForErr80 += 1/(d80[i][1])**2
    
    sumForMean3 += d3[i][0]/(d3[i][1])**2
    sumForMean5 += d5[i][0]/(d5[i][1])**2
    sumForMean10 += d10[i][0]/(d10[i][1])**2
    sumForMean15 += d15[i][0]/(d15[i][1])**2
    sumForMean20 += d20[i][0]/(d20[i][1])**2
    sumForMean30 += d30[i][0]/(d30[i][1])**2
    sumForMean50 += d50[i][0]/(d50[i][1])**2
    sumForMean80 += d80[i][0]/(d80[i][1])**2
    
    sumForRelM3 += d3[i][1]/d3[i][0]
    sumForRelM5 += d5[i][1]/d5[i][0]
    sumForRelM10 += d10[i][1]/d10[i][0]
    sumForRelM15 += d15[i][1]/d15[i][0]
    sumForRelM20 += d20[i][1]/d20[i][0]
    sumForRelM30 += d30[i][1]/d30[i][0]
    sumForRelM50 += d50[i][1]/d50[i][0]
    sumForRelM80 += d80[i][1]/d80[i][0]
    
    
mean3 = (1/sumForErr3)*sumForMean3
mean5 = (1/sumForErr5)*sumForMean5
mean10 = (1/sumForErr10)*sumForMean10
mean15 = (1/sumForErr15)*sumForMean15
mean20 = (1/sumForErr20)*sumForMean20
mean25 = (1/sumForErr25)*sumForMean25
mean30 = (1/sumForErr30)*sumForMean30
mean50 = (1/sumForErr50)*sumForMean50
mean80 = (1/sumForErr80)*sumForMean80

err3 = np.sqrt(1/sumForErr3)
err5 = np.sqrt(1/sumForErr5)
err10 = np.sqrt(1/sumForErr10)
err15 = np.sqrt(1/sumForErr15)
err20 = np.sqrt(1/sumForErr20)
err25 = np.sqrt(1/sumForErr25)
err30 = np.sqrt(1/sumForErr30)
err50 = np.sqrt(1/sumForErr50)
err80 = np.sqrt(1/sumForErr80)

print("Mean for 3cm = ",mean3," +/- ",err3)
print("Mean for 5cm = ",mean5," +/- ",err5)
print("Mean for 10cm = ",mean10," +/- ",err10)
print("Mean for 15cm = ",mean15," +/- ",err15)
print("Mean for 20cm = ",mean20," +/- ",err20)
print("Mean for 25cm = ",mean25," +/- ",err25)
print("Mean for 30cm = ",mean30," +/- ",err30)
print("Mean for 50cm = ",mean50," +/- ",err50)
print("Mean for 80cm = ",mean80," +/- ",err80)



RelM3 = sumForRelM3/10
RelM5 = sumForRelM5/10  
RelM10 = sumForRelM10/10  
RelM15 = sumForRelM15/10  
RelM20 = sumForRelM20/10  
RelM25 = sumForRelM25/9  
RelM30 = sumForRelM30/10
RelM50 = sumForRelM50/10  
RelM80 = sumForRelM80/10

for i in range(10):
    print(i)
    if (i > 0):
        sumForRelU25 += (d25[i][1]/d25[i][0] - RelM25)**2
        
    sumForRelU3 += (d3[i][1]/d3[i][0] - RelM3)**2
    sumForRelU5 += (d5[i][1]/d5[i][0] - RelM5)**2
    sumForRelU10 += (d10[i][1]/d10[i][0] - RelM10)**2
    sumForRelU15 += (d15[i][1]/d15[i][0] - RelM15)**2
    sumForRelU20 += (d20[i][1]/d20[i][0] - RelM20)**2
    sumForRelU30 += (d30[i][1]/d30[i][0] - RelM30)**2
    sumForRelU50 += (d50[i][1]/d50[i][0] - RelM50)**2
    sumForRelU80 += (d80[i][1]/d80[i][0] - RelM80)**2

RelU3 = np.sqrt(sumForRelU3/90)
RelU5 = np.sqrt(sumForRelU5/90)
RelU10 = np.sqrt(sumForRelU10/90)
RelU15 = np.sqrt(sumForRelU15/90)
RelU20 = np.sqrt(sumForRelU20/90)
RelU25 = np.sqrt(sumForRelU25/72)
RelU30 = np.sqrt(sumForRelU30/90)
RelU50 = np.sqrt(sumForRelU50/90)
RelU80 = np.sqrt(sumForRelU80/90)

relerr[0] = RelM3
relerr[1] = RelM5
relerr[2] = RelM10
relerr[3] = RelM15
relerr[4] = RelM20
relerr[5] = RelM25
relerr[6] = RelM30
relerr[7] = RelM50
relerr[8] = RelM80

relerrU = np.zeros(9)
relerrU[0] = RelU3
relerrU[1] = RelU5
relerrU[2] = RelU10
relerrU[3] = RelU15
relerrU[4] = RelU20
relerrU[5] = RelU25
relerrU[6] = RelU30
relerrU[7] = RelU50
relerrU[8] = RelU80


plot = plt.figure()
plt.errorbar(dist , relerr , yerr = relerrU)
plt.xlabel("Distance Between Ultrasonic Sensor and Flat Surface (cm)")
plt.ylabel("Relative Error in the Time Pulse Measured")
plt.title("Relative Error in Time Pulse Measurements vs. Distance From Sensor")

# OR CAN DO THIS:
meanz = np.zeros(9)
errmeanz = np.zeros(9)

meanz[0] = mean3
meanz[1] = mean5
meanz[2] = mean10
meanz[3] = mean15
meanz[4] = mean20
meanz[5] = mean25
meanz[6] = mean30
meanz[7] = mean50
meanz[8] = mean80

errmeanz[0] = err3
errmeanz[1] = err5
errmeanz[2] = err10
errmeanz[3] = err15
errmeanz[4] = err20
errmeanz[5] = err25
errmeanz[6] = err30
errmeanz[7] = err50
errmeanz[8] = err80

params = np.polyfit(meanz,2*dist,1)
fit = params[0]*meanz + params[1]

par,cov = curve_fit(linear , meanz , 2*dist)

delta = 9*sum(meanz**2) - (sum(meanz))**2
offset = (sum(meanz**2)*sum(2*dist) - sum(meanz)*sum(meanz*2*dist))/delta
slope = (9*sum(meanz*2*dist) - sum(meanz)*sum(dist*2))/delta

dum = np.zeros(9)
for t in range(9):
    dum[t] = (2*dist[t] - offset - slope*meanz[t])**2
siggy = np.sqrt(sum(dum)/7)

errS = siggy*np.sqrt(9/delta)
errO = siggy*np.sqrt(sum(meanz**2)/delta)
fitty = slope*meanz + offset

print(slope)
print(params[0])
print(par[0])
print(errS)

plotty = plt.figure()
plt.subplot(2,1,1)
plt.errorbar(meanz , 2*dist , yerr = 0.1 , xerr = errmeanz , fmt = '.')
plt.plot(meanz,fitty, '-')
plt.ylabel("Distance Travelled (cm)")
plt.title("Distance Travelled by Ultrasonic Wave vs. Time of Travel")
plt.text(500,140,"Slope = ({0} +/- {1})m/s".format(351,1),bbox=dict(facecolor='orange', alpha=0.5))

plt.subplot(2,1,2)
plt.errorbar(meanz , fitty - 2*dist , yerr = 0.1 , xerr = errmeanz , fmt = '.')
plt.plot(meanz , np.full(9,0))
plt.xlabel("Time Taken For Wave To Reach Sensor (10^-6 s)")
plt.ylabel("Residuals")
     