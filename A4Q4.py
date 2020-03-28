#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 11 21:21:50 2020

@author: noahlefrancois
"""

h = 6.626*10**(-34)
c = 3*10**8
k = 1.381*10**(-23)

Tsun = 5778
Tearth = 288

LambdaS = h*c/(2.82*k*Tsun)
LambdaE = h*c/(2.82*k*Tearth)

print(LambdaS)
print(LambdaE)

C0 = 412*10**(-6)
e0 = 0.62

A = C0*(1-e0)/(e0)
B = 1-A

print(A)
print(B)

C = 2*C0

eps = C/(A+B*C)

print(eps)

TpInc = (1+eps)**0.25*255


