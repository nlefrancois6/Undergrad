lam = 2;

R = @(y) 1600-50*y^2;
p = @(y) 2.^y.*exp(-2)./factorial(y);

E_R = 0;
for i=0:24
    E_R = E_R + R(i)*p(i);
end

plot(0:24, p(0:24))
