function BMat = getBMatrix(N,L)
%Obtain the B matrix for cyclic reduction where FFT(u_y)=(ik_y)FFT(u) and
%the resulting coefficients give B=(ik_y)

I=sqrt(-1);
% differentiation matrix
ik=I*(mod((1:N)-ceil(N/2+1),N)-floor(N/2))*L/(2*pi);
ik(1)=1;

BMat = diag(ik);
end

