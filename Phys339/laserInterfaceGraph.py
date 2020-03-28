#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
This is only an example, it requires the LASER_2018.ino to be loaded on the Arduino
and it should be in the same folder as Arduino.py.

It does not imply what you need to do, merely implements a simple exerpiment that
gives an example interaction with the Arduino.
"""

import numpy as np
import string
import matplotlib.pyplot as p
import laserClass
import datetime


a = laserClass.Arduino() 
steps = 720
sebber = np.zeros(steps)
degsPerStep = 1           # This has to be calibrated by you       
a.send("LASER 3450")        # Laser control voltage (DETERMINED TO BE OPTIMAL AROUND THE 3300-3400 RANGE)
a.send("STEPS %d"%(steps))  # Total number of steps
a.send("DELAY 10")         # Delay time before reading value (ms), >4 recommended
a.send("START")             # Start the stepping/reading
a.send("STOP")
vector = np.zeros(steps)
weakAF = np.zeros(steps)
index = -1
for k in range(steps):
    resp = a.getResp()
    if 9 == len(resp) and resp[4] == ':':
        words = string.split(resp,":")
        step = int(words[0])
        adc = int(words[1])
        if 0 == step:
            p.ion()
            fig = p.figure()
            p.xlabel("Step index")
            p.ylabel("ADC reading")
            ax = fig.add_subplot(111)
            lines, = ax.plot(range(k+1),vector[:k+1])  
            p.axis([0,steps,0,max(vector)])
            #lines, = ax.plot(np.array(range(k+1))*degsPerStep,vector[:k+1])  
            #p.axis([0,steps*degsPerStep,0,max(vector)])
            p.pause(0.01)
            index += 1
        vector[step] = adc
        weakAF[step] = adc
        sebber[step] = step
        lines.set_data(range(k+1),vector[:k+1])
        p.axis([0,steps,0,max(vector)])
        #lines.set_data(np.array(range(k+1))*degsPerStep,vector[:k+1])
        #p.axis([0,steps*degsPerStep,0,max(vector)])
        p.pause(0.01)      
    else:
        print("Unexpected response: %s"%(resp))
        print("Length: %d"%(len(resp)))
    if 10 == index:
        break
a.send("LASER 0")
a.closePort()
#print(sebber)
saveFileName="NewLaser_2_2_3450_Polar_"+datetime.datetime.now().strftime("%Y_%m_%d_%H_%M_%S")+".csv"
np.savetxt(saveFileName , np.transpose([sebber,weakAF]) , delimiter=',')


