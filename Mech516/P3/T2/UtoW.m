function [W] = UtoW(U, gamma)
%Convert U vector to primitive vector
W1 = U(1,:); 
W2 = U(2,:)./U(1,:); 
%W3 = (U(3,:)-W2.^2/2).*W1*(gamma-1);
W3 = (gamma - 1)*(U(3,:) - .5 * U(2,:).^2 ./ U(1,:));

W = [W1; W2; W3];
end