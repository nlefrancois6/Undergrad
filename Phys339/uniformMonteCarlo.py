# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import matplotlib.pyplot as plt
import random as r
import numpy as np
import math

"""
Nsamp = 100

data = np.zeros(Nsamp)
trials = range(Nsamp)
values = np.zeros(Nsamp)
A = 4


for i in trials:
    data[i] = r.random()
    if (data[i] <= 0.5):
        values[i] = (data[i]/2)**(1/2)
    else:
        a=-2
        b=4
        c=-(2+data[i])
        #print(b**2-4*a*c)
        values[i] = (-b+(-(b**2-4*a*c))**(1/2))/(2*a)

binNumber = 20
cumBinNumber = 100
print(values)



histValues, binEdges = np.histogram(values, cumBinNumber)
cumHistValues = np.cumsum(histValues)/float(Nsamp)

binCenter = np.zeros(len(binEdges)-1)

for i in range(len(binEdges)-1):
    binCenter[i] = 0.5 * (binEdges[i] + binEdges[i+1])


f1 = plt.figure


plt.subplot(1,3,1)
plt.plot(data, values, 'o')

plt.subplot(1,3,2)
plt.hist(values, bins=binNumber)

plt.subplot(1,3,3)
plt.plot(binCenter, cumHistValues, 'o')
"""


"""
#Example Program to test random number generation in Python
Nsamp = 10

values = np.zeros(Nsamp)
trials = range(Nsamp)

for i in trials:
    values[i] = r.random()

print('mean', np.mean(values))
print('std', np.std(values))

binNumber = 20

f1 = plt.figure
#make a subplot array w 1 col, 2 rows. 3rd int is this subplot's position in the array
plt.subplot(1,2,1)
plt.plot(trials,values, 'o')
plt.xlabel('trials')
plt.ylabel('values')
plt.subplot(1,2,2)
plt.hist(values, bins=binNumber)
plt.xlabel('value')
plt.ylabel('counts')
"""

"""
#Monte Carlo to Simulate an Unfair Coin
nsamp = 100
probCoin = 0.8

values = np.zeros(nsamp)
trials = range(nsamp)
coinFlips = np.zeros(nsamp)

for i in trials:
    values[i] = r.random()
    if(values[i]<probCoin):
        coinFlips[i] = 0
    else:
        coinFlips[i] = 1

numTails = sum(coinFlips)

print('coin flips mean', np.mean(coinFlips))
print('coin flips std', np.std(coinFlips))

binNumber = 20
binNumberFlips = 10

f1 = plt.figure
plt.subplot(2,2,1)
plt.plot(trials, values, 'o')
plt.xlabel('trials')
plt.ylabel('values')

plt.subplot(2,2,2)
plt.hist(values, bins=binNumber)
plt.xlabel('value')
plt.ylabel('counts')

plt.subplot(2,2,3)
plt.plot(trials, coinFlips, 'o')
plt.xlabel('trials')
plt.ylabel('flips')

plt.subplot(2,2,4)
tailsPercent = 100 * (numTails/nsamp)
headsPercent = 100 - tailsPercent
plt.bar([0,1], [headsPercent,tailsPercent], width = 0.8)
plt.xlabel('flips')
plt.ylabel('counts')
"""

"""
#Monte Carlo to simulate an unfair die
Nsamp = 10
p0 = 1/6.0
bias = 0.05

p6 = p0 + bias
p=(1-p6)/5.0

probVect = [p,p,p,p,p,p6]
cumVect = np.cumsum(probVect)

values = np.zeros(Nsamp)
trials = range(Nsamp)
dieToss = np.zeros(Nsamp)

for i in trials:
    values[i] = r.random()
    if (values[i]<cumVect[0]):
        dieToss[i] = 1
    elif (cumVect[0]<=values[i]<cumVect[1]):
        dieToss[i] = 2
    elif (cumVect[1]<=values[i]<cumVect[2]):
        dieToss[i] = 3
    elif (cumVect[2]<=values[i]<cumVect[3]):
        dieToss[i] = 4
    elif (cumVect[3]<=values[i]<cumVect[4]):
        dieToss[i] = 5
    elif (cumVect[4]<=values[i]<cumVect[5]):
        dieToss[i] = 6
numToss = np.zeros(6)
for i in range(1,7):
    numToss[i-1] = sum(dieToss==i)

numTossPercent = 100*(numToss/Nsamp)

f1 = plt.figure

plt.subplot(1,2,1)
plt.plot(trials, dieToss, 'o')
plt.xlabel('toss trials')
plt.ylabel('toss value')

plt.subplot(1,2,2)
plt.bar(range(1,7), numTossPercent, width = 0.8)
plt.xlabel('toss value')
plt.ylabel('counts')
"""

"""
#Monte Carlo to generate exponentially distributed random values
Nsamp = 100
binNumber = 20
cumBinNumber = 100
a = 1

def cumExpModel(a, x):
    x = np.array(x)
    return 1-np.exp(-a*x)

values = np.zeros(Nsamp)
trials = range(Nsamp)

for i in trials:
    ro = r.random()
    values[i] = -(1/a) * np.log(1-ro)

print('mean', np.mean(values))
print('std', np.std(values))

histValues, binEdges = np.histogram(values, cumBinNumber)
cumHistValues = np.cumsum(histValues)/float(Nsamp)

binCenter = np.zeros(len(binEdges)-1)

#convert bin edges to bin center position
#note len() gives number of elements in array
for i in range(len(binEdges)-1):
    binCenter[i] = 0.5 * (binEdges[i] + binEdges[i + 1])

f1 = plt.figure

plt.subplot(2,2,1)
plt.plot(trials, values, 'o')
plt.xlabel('trials')
plt.ylabel('values')

plt.subplot(2,2,2)
plt.hist(values,bins = binNumber)
plt.xlabel('values')
plt.ylabel('counts')

plt.subplot(2,2,3)
plt.plot(binCenter, cumHistValues, 'o')
plt.xlabel('value')
plt.ylabel('cumulative co')

plt.subplot(2,2,4)
plt.plot(binCenter, cumExpModel(a,binCenter),'o')
plt.xlabel('value')
plt.ylabel('cumulative counts')

np.savetxt('nonuniform.csv', np.transpose([binCenter, cumHistValues]), delimiter = ",")
"""






