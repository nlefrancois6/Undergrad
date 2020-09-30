Tb = 353; Te = 293; h = 10; k = 16; R = 0.025; d = 0.005;
L = pi*R;
P = pi*d; A = pi*(d/2)^2;

B = sqrt(h*P/(k*A));

T = @(x) (Tb-Te)*(sinh(B*x)+sinh(B*(L-x)))/sinh(B*L) + Te;

Tc = T(L/2)