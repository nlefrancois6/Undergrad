x = 100;
N = 5000;
%a = 1.444668;
as = 0.99:0.02:1.2;

x_store = zeros(N+1,size(as,2));
a_ind = 0;

for a=0.99:0.02:1.2
    a_ind = a_ind + 1;
    x = 100;
    x_store(1,a_ind) = x;
    for n=1:N
        x = a.^x;
        x_store(n+1,a_ind) = x;
    end
end
%figure;
%plot(x_store(:,1))
%figure;
%plot(imag(x_store))
%disp(x)

figure;
fps = x_store(end,:);
plot(as, fps)
xlabel('a')
ylabel('Fixed point x*')