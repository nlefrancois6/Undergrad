# -*- coding: utf-8 -*-
"""
Created on Thu Mar 28 18:09:22 2019

@author: bufft shady
"""

import serial
import time as t
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter

def CheckArrFull(image,xyLim,completeness):
    count = 0
    for i in range(xyLim[0]):
        for q in range(xyLim[1]):
            if (image[i][q] > 0):
                count+=1
    if (count >= xyLim[0]*xyLim[0]*completeness):
        return 0
    else:
        return 1

dataSize=3
xyLim = [256,256]
image = np.zeros(shape = (xyLim[0],xyLim[1]))
completeness = 0.10



serialPort=serial.Serial()
serialPort.baudrate=9600
serialPort.port="/dev/cu.usbmodem1411"   #Set port name to that of Arduino-need to replace ? with correct COM port number
#print(serialPort)

while (CheckArrFull(image,xyLim,completeness) > 0):

    serialPort.open()
    dataRead=False
    xyz=[]
    while (dataRead==False):
        serialPort.write(chr(100))
        t.sleep(0.1)
        inByte=serialPort.inWaiting()
        #This loop reads in data from the array until byteCount reaches the array size (dataSize)
        byteCount=0
        while ((inBtye>0)&(byteCount<dataSize)):
            dataByte=serialPort.read()
            byteCount=byteCount+1
            xyz=xyz+[dataByte]
            print(ord(xyz))
            print("Hello")
            if (byteCount==dataSize):
                dataRead=True
    serialPort.close()
    """
    dataOut=np.zeros(dataSize)
    for i in range(dataSize):
        dataOut[i]=ord(xyz[i])
    image[dataOut[0],dataOut[1]] = dataOut[2]
    """
    print(ord(xyz[0]))
    image[ord(xyz[0]),ord(xyz[1])] = ord(xyz[2])


lev = np.arange(0,256,4)
#norml = matplotlib.colors.BoundaryNorm(lev, 256)


fig = plt.figure()
ax = fig.gca(projection='3d')
# Plot the surface.
xdat,ydat = np.meshgrid(range(xyLim[0]),range(xyLim[1]))
object = ax.plot_surface(xdat, ydat, image, cmap=cm.jet,linewidth=0, norm = matplotlib.colors.BoundaryNorm(lev, 64), antialiased=False, shade=False)

# Customize the z axis.
ax.set_zlim(0, 256)
ax.set_xlim(0,xyLim[0])
ax.set_ylim(0,xyLim[1])
#ax.zaxis.set_major_locator(LinearLocator(10))
#ax.zaxis.set_major_formatter(FormatStrFormatter('%.02f'))

# Add a color bar which maps values to colors.
fig.colorbar(object, shrink=0.5, aspect=5)
      
"""
f1=plt.figure()
plt.plot(arrayIndex, dataOut, 'o')
plt.xlabel("array index")
plt.ylabel("8-bit rounded voltage reading")
print('mean:', np.mean(dataOut))
"""