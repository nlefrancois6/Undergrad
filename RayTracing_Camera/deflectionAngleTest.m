%Test deflectionAngle function
g = 0.7;
CDF = @(angle) ((1-g.^2)./2*g)*((1+g.^2-2.*g.*cos(angle)).^(-0.5)-(1+g).^(-1));
angles = (1:179);
cdfPhi = CDF(angles.*pi./180);
cdfTheta = CDF(angles.*pi./180);


%{
for x=1:179
    cdfPhi(x) = CDF(-32*pi/180)
    cdfTheta(x) = CDF(pi*(x-90)/180)
end
%}

phi = 35; theta = 36;

[theta, phi] = deflectionAngle(theta, phi, cdfPhi, cdfTheta);