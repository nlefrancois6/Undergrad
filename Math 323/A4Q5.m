n = 100000; Re = 2.4; p = Re/n;

p = @(x) nchoosek(n,x).*p.^x.*(1-p).^(n-x);

xs = 0:5;
prob = zeros(6,1);
for i=0:5
    prob(i+1) = p(i);
end
%plot(xs, prob)
sum(prob)