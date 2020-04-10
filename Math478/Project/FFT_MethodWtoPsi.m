function [Psi] = FFT_MethodWtoPsi(w, NP, dx)
%Fourier Transform method of solving the Poisson equation
Wfft = fft2(w);
Wfft(1,1) = 0;

[i,j]=meshgrid(1:NP+1,1:NP+1);
Psifft = (2*(cos(pi/(NP+1)*i)+cos(pi/(NP+1)*j)-2)/(dx^2)).*Wfft;


Psi = ifft2(Psifft, 'symmetric');

end

