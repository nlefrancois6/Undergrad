function BMat = getBMatrix(N,L)
%Obtain the B matrix FACR where FFT(u_x)=(ik_x)FFT(u) and
%the resulting coefficients give B=(ik_x)

dx = L/N;

I=sqrt(-1);
% differentiation matrix
ik2=(dx^2)*(I*(mod((1:N)-ceil(N/2+1),N)-floor(N/2))*(2*pi)/L).^2;
ik2(1)=1;

ik2 = ik2.*ones(N,1);

BMat = ik2;
end

