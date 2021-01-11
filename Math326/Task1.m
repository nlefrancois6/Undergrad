%xNew = @ (x, t) 1 + cos(2*(x+t));

x0 = 0.4;
r = 3.6;

x = zeros(11,1);
x(1) = x0;

for i=2:length(x)
   x(i) = r*x(i-1)*(1-x(i-1));
end

x