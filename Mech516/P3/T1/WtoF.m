function [F] = WtoF(W, gamma)
%Get flux vector F=(rho*u, rho*u^2+p, (rho*E+p)*u) from primitive vector W=(rho, u, p)
if size(W,2)>3
    rho = W(1,:); u = W(2,:); p = W(3,:);
else
    rho = W(1); u = W(2); p = W(3);
end
E = p./(rho.*(gamma-1)) + u.^2/2;

f1 = rho.*u;
f2 = rho.*u.^2 + p;
f3 = (rho.*E + p).*u;

F = [f1; f2; f3];
end

