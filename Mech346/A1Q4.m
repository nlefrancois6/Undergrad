Ti = 293; To = 270; Lw = 0.03; Lg = 0.06; eps = 0.9; sig = 5.67*1e-8;
hci = 3; hco = 6; kw = 0.17; kg = 0.043;

hr = 4*eps*sig*To;

x = (1/hci + 2*Lw/kw + Lg/kg + 1/(hco + hr));

flux = (Ti-To)/x