function [T_n, g_n] = Tg_next(T_current, g_current, NP, dx)
%Update T & g to level n from the current level, n-1

T_n = 2*ones(NP,NP) - T_current.^2;


middleTerm = T_current.*g_current;

%Textbook says there should be a dx^2 in front of g_n, but this leads to
%instabilities and removing it gives the correct output. May be a mistake,
%or some other behaviour we don't know about affecting it.
g_n = (g_current(1:end-2,:) - middleTerm(2:end-1, :) + g_current(3:end,:));
g_n = [g_current(1,:); g_n; g_current(end, :)];

end