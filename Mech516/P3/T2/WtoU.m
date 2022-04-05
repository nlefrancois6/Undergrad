function [U] = WtoU(W, gamma)
%Convert primitive vector to U vector
U1 = W(1,:); 
U2 = W(1,:).*W(2,:); 
U3 = W(1,:).*(W(3,:)./(W(1,:).*(gamma-1)) + W(2,:).^2/2);
U = [U1; U2; U3];
end