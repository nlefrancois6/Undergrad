v0 = 2.2*10^5;

fun = @(v) (v.^2).*exp(-(v./v0).^2);

v1 = 1.1*10^5;
v2 = 5.3*10^5;
N1 = 4/(sqrt(pi)*v0^3)

N = 1/integral(fun, v1, v2);
q = integral(fun,v1,v2);
N*q;
