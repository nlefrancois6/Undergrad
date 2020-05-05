%Initialize frame, rho, and T as inputs to rayTracingImage, then visualize the
%output as a 2D RGB image


%Frame size & resolution
LX = 1;
LY = 1;
LZ = 1;

%32
NP = 8;

xLen = LX*NP+1; yLen = LY*NP+1; zLen = LZ*NP+1;

%%Generate density&temperature to input to ray tracer
cutoff = @(z) (abs(z)<1);
moll = @(z) exp(-1./(1-(z.*cutoff(z)).^2)).*cutoff(z).*exp(1); % compact support in [-1,1]
mollR = @(s, R) moll(2*s./R);

gauss = @(x, y, z, sig) exp(-(x.^2 + y.^2 + z.^2)./(sig.^2))./(4*pi*sig.^2); % gaussian centered at 0


cosbump1D = @(s, width) cos(pi/2.*s./width).*mollR(s, pi*width/2);
cosbumpz = @(x, y, z, width) cosbump1D(z, width);
cosbumpcirc = @(x, y, z, width) cosbump1D(sqrt(x.^2 + y.^2 + z.^2), width);

%Not yet sure how we'll get this info at each time step, will either have
%to use pullback coordinates as input to T0, rho0, or will have to take the
%arrays TP and RP as input which means we only have them defined at the
%grid points and not as a field. May affect my calling of TVox in
%trace2Scatter
Tmax = 1; 
Temp = @(x, y, z) Tmax.*cosbumpcirc(x-0.5, y-0.5, z-0.5, 0.5); 

rmax = 0.05;
rho = @(x, y, z) rmax*cosbumpz(x, y, z-0.5, 0.5);

%This is the actual script we'll use to visualize each frame of our
%simulation: sample, input pixel resolution, create image.
[TSamp, rhoSamp] = sampleFields(xLen, yLen, zLen, LX, LY, LZ, NP, Temp, Temp);

%256
pixels = 64;

[pixelGrid] = rayTracingImage(pixels, LX, LY, LZ, NP, TSamp, Tmax, rhoSamp, rmax);

image(pixelGrid)
drawnow


%{
subplot(2,2,2)
[X,Y,Z] = ndgrid(1:size(LGrid,1), 1:size(LGrid,2), 1:size(LGrid,3));
pointsize = 30;
scatter3(X(:), Y(:), Z(:), pointsize, LGrid(:), 'filled');
%}
