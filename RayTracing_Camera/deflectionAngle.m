function [theta, phi] = deflectionAngle(theta, phi, cdfPhi, cdfTheta)
%Generate deflected angle for theta and phi according to Henyey-Greenstein
%Phase function


rPhi = (cdfPhi(1))*rand; rTheta = (cdfTheta(1))*rand;

phiBool = rPhi > cdfPhi;
thetaBool = rTheta > cdfTheta;

indPhi = find(phiBool, 1, 'first');
phi = phi + indPhi-90;

indTheta = find(thetaBool, 1, 'first');
theta = theta + indTheta-90;


%{
%Not sure how to vectorize this while maintaining my break so that I stop
%at the first x value s.t. rPhi > cdfPhi(x)
for x=1:179
    if rPhi > cdfPhi(x)
        phi = phi + x-90;
        break;
    end
end

for x=1:179
    if rTheta > cdfTheta(x)
        theta = theta + x-90;
        break;
    end
end
%}


end

