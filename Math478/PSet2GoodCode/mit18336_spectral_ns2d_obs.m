function mit18336_spectral_ns2d_obs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Navier-Stokes equations in vorticity/stream function formulation on the torus %
% Version 1.0                                                                   %
% (c) 2008 Jean-Christophe Nave - MIT Department of Mathematics                 %             
%  jcnave (at) mit (dot) edu                                                    %
%                                                                               %
%  Dw/Dt = nu.Laplacian(w)                                                      % 
%  Laplacian(psi) = -w                                                          %
%  u = psi_y                                                                    %
%  v =-psi_x                                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

nu=1e-3;  % viscosity
LX = 2*pi;  % x domain length
LY = 2*pi;  % y domain length
NX=128;     % resolution in x
NY=128;     % resolution in y
dt=2e-3;    % time step
TF=10;  % final time, originally 1000
TSCREEN=10; % screen update interval time (NOTE: plotting is usually slow)
method='crank_nicholson';       % 'forward_euler' or 'crank_nicholson'
obstacle='circle';  % 'circle'
xObs = 60; yObs = 60;   % Obstacle position
eta = 10^(-3);
initial_condition='vortices';   % 'vortices' or 'random'

I=sqrt(-1);
dx=LX/NX;
dy=LY/NY;
t=0.;

sxp = 1:NX; % Define the gridpoint locations
syp = 1:NY;
[xp, yp] = meshgrid(sxp,syp);

switch lower(method)
   case {'forward_euler'}
      disp('Forward Euler method')
      disp('WARNING: only conditionally stable !!! Lower the time step if unstable...')
   case {'crank_nicholson'}
      disp('Crank-Nicholson Method')
      disp('Unconditionally stable up to CFL Condition')
    otherwise
      disp('Unknown method!!!');
      return
end

% Define initial vorticity distribution
switch lower(initial_condition)
   case {'vortices'}
      w=exp(-((xp*dx-pi).^2+(yp*dy-pi+pi/4).^2)/(0.2))+exp(-((xp*dx-pi).^2+(yp*dy-pi-pi/4).^2)/(0.2))-0.5*exp(-((xp*dx-pi-pi/4).^2+(yp*dy-pi-pi/4).^2)/(0.4));
   case {'random'}
      w=random('unif',-1,1,NX,NY);
   otherwise
      disp('Unknown initial conditions !!!');
      return
end

% Define obstacle
switch lower(obstacle)
   case {'circle'}
       % Create level set function for circle, calculate its value on the
       % domain
       circ = @(x, y) sqrt(x.^2 + y.^2);
       phi = @(x, y) circ(x-xObs, y-yObs) - 10;
       phip = phi(xp, yp);
       
       % Smoothed Indicator Function, calculate its value on the domain
       sig = 10^(0.85);
       gauss = @(x, y, sig) exp(-(x.^2 + y.^2)./(sig.^2)); % gaussian centered at 0
       indFunc = gauss(mod(xp, NX)-xObs, mod(yp, NY)-yObs, sig);
       
       % Plot indicator function to compare with level set function
       contour(xp, yp, indFunc)
       hold on;
       contour(xp, yp, phip, [0 0], 'k')
       hold off;
       
       % We will remove vorticity inside the obstacle, where phip<0, later.
       % Calculate which points lie inside the obstacle for later use.
       inobst = phip<0;

   otherwise
      disp('Unknown obstacle type !!!');
      return
end

kx=I*ones(1,NY)'*(mod((1:NX)-ceil(NX/2+1),NX)-floor(NX/2)); % matrix of wavenumbers in x direction 
ky=I*(mod((1:NY)'-ceil(NY/2+1),NY)-floor(NY/2))*ones(1,NX); % matrix of wavenumbers in y direction 

dealias=kx<2/3*NX/2&ky<2/3*NY/2; % Cutting of frequencies using the 2/3 rule

ksquare_viscous=kx.^2+ky.^2;        % Laplacian in Fourier space
ksquare_poisson=ksquare_viscous;    
ksquare_poisson(1,1)=1;             % fixed Laplacian in Fourier space for Poisson's equation
%w_hat=fft2(w);

figure;
k=0;ts=0;
while t<TF
    % Modify w to remove vorticity inside the obstacle at the beginning of each step.
    
    % Multiply by 1-dt*indFunc/eta to remove most of w with the indicator function
    w(inobst) = w(inobst)-dt*indFunc(inobst).*w(inobst)./eta;
    % Correct components close to the centre which overshoot w=0 
    if w(inobst) < 0
        w(inobst) = 0;
    end
    w_hat = fft2(w);
    
    k=k+1;
    % Compute the stream function and get the velocity and gradient of vorticity
    psi_hat = -w_hat./ksquare_poisson;  % Solve Poisson's Equation
    u  =real(ifft2( ky.*psi_hat));      % Compute  y derivative of stream function ==> u
    v  =real(ifft2(-kx.*psi_hat));      % Compute -x derivative of stream function ==> v
    w_x=real(ifft2( kx.*w_hat  ));      % Compute  x derivative of vorticity
    w_y=real(ifft2( ky.*w_hat  ));      % Compute  y derivative of vorticity
    
    
    conv     = u.*w_x + v.*w_y;         % evaluate the convective derivative (u,v).grad(w)   
    conv_hat = fft2(conv);              % go back to Fourier space
    
    conv_hat = dealias.*conv_hat;   % Perform spherical dealiasing 2/3 rule
    
    % Compute Solution at the next step
    % We chose to modify the crank-nicholson scheme since the forward euler
    % scheme required extremely small time step to be stable with the
    % penalty method
    switch lower(method)
       case {'forward_euler'}
          w_hat_new = w_hat + dt*( nu*ksquare_viscous.*w_hat-conv_hat);
          %w_hat_new = w_hat + dt*( nu*ksquare_viscous.*w_hat-conv_hat-indFunc.*w_hat./eta);
       case {'crank_nicholson'}
          w_hat_new = ((1/dt + 0.5*nu*ksquare_viscous-0.5*indFunc/eta)./(1/dt - 0.5*nu*ksquare_viscous+0.5*indFunc/eta)).*w_hat - (1./(1/dt - 0.5*nu*ksquare_viscous+0.5*indFunc/eta)).*conv_hat;
    end
    
    t=t+dt;
    % Plotting the vorticity field
    if (k==TSCREEN) 
        % Go back in real space omega in real space for plotting
        w=real(ifft2(w_hat_new));
        contourf(w,100,'LineColor','none'); colorbar; shading flat;colormap('jet'); 
        hold on;
        contour(xp, yp, phip, [0 0], 'k', 'LineWidth', 2)
        hold off;
        title(num2str(t));
        drawnow
        %print('-dpng','-r0',num2str(ts))
        k=0;
        ts=ts+1;
    end
    w_hat=w_hat_new;
    w = ifft2(w_hat);

end