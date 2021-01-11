n = 20; p = 0.8;

xp = 0:1:n;

Py = @(y) binopdf(y, n, p);
sum_terms = xp.*Py(xp);
Ey = sum(sum_terms);
Ey_squ = Ey^2;
E_ysq = sum(xp.^2.*Py(xp));
myVar = E_ysq - Ey_squ
eqVar = n*p*(1-p)
