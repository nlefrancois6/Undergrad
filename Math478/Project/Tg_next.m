function [T_n, g_n] = Tg_next(T_current, g_current, NP, dx, xLen, yLen)
%Update T & g to level n from the current level, n-1

T_n = 2*eye(NP) - T_current.^2;

g_n = zeros(xLen,yLen);

%Boundary values remain zero.
g_n(1,:) = g_current(1,:);
g_n(end,:) = g_current(end,:);
for i=2:xLen-1
g_n = (dx^2)*(g_current(i-1) - T_current(i)*g_current(i) + g_current(i+1));
end

end