ca = 4000; cb = 2000; ma = 1; 
Tai = 400; Tao = 300; Tbi = 300;

dTa = Tai - Tao;

%dS = @(mb) mb.*cb.*(200./mb + Tbi)./(Tbi + 100./mb) - ma*ca*dTa/(Tai+Tao);
dS = @(mb) 2.*mb.*log((200./mb + 300)/300) - 1.15;

Tbo = @(mb) 200./mb + Tbi;

mb = linspace(0,5,100);

plot(mb, dS(mb))
xlabel('Mass Flow Rate of B (kg/s)');
ylabel('Rate of Entropy Generation (J/K.s)');
%Find the case dS = 0 for reversible process
%Numerically
Sint = fzero(dS, 2);
%Analytically
%[root1, root2] = Q1_quadratic(A,B,C);

%Find Tbo for reversible process
Tbo_reversible = Tbo(Sint);

function [quadRoots1, quadRoots2] = Q1_quadratic(a, b, c)

  d = b^2 - 4*a*c; % your number under the root sign in quad. formula

  % real numbered distinct roots?
  if d > 0
    quadRoots1 = (-b+sqrt(d))/(2*a);
    quadRoots2 = (-b-sqrt(d))/(2*a);
  % real numbered degenerate root?
  elseif d == 0 
    quadRoots1 = -b/(2*a);
    quadRoots2 = NaN;
  % complex roots, return NaN, NaN
  else
    quadRoots1 = NaN;
    quadRoots2 = NaN;
  end    
end