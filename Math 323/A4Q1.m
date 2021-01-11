y = 3:13;
p = [0.03 0.05 0.07 0.1 0.14 0.2 0.18 0.12 0.07 0.03 0.01];

Ey = 0;
for i=1:length(y)
    Ey = Ey + y(i)*p(i);
end

Ey2 = 0;
for i=1:length(y)
    Ey2 = Ey2 + y(i)^2*p(i);
end

STD = sqrt(Ey2 - Ey^2);
lower = Ey - 2*STD; upper = Ey + 2*STD;

cumP = 0;
for i=2:length(y)-1
    cumP = cumP + p(i);
end

plot(y,p)