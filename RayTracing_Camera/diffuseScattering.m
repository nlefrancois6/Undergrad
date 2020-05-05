function [LGrid, CGrid] = diffuseScattering(N, alb, cdfPhi, cdfTheta, sourceBright, camPos, TVox, IGrid, hitTol, stepSize, lightSource, LX, LY, LZ, xLen, yLen, zLen, dx, walls)
%Simulate scattering of N photons from the camera position, illuminating
%each vertex it hits and being scattered randomly; the photon then travels
%a random distance scaled by stepSize before the next impact; this occurs
%until the photon reaches the light source (for now just using an
%open-topped box)

LGrid = zeros(xLen, yLen, zLen);
CGrid = zeros(xLen, yLen, zLen, 3);

raysCompleted = 0;
%Counters for total number of steps and wall terminations from all rays, to be averaged
stepNumTot = 0;
wallTerminationTot = 0;

while raysCompleted < N
    
    %Wall hit counter
    hits = 0;
    %Scattering step counter
    stepNum = 0;
    TRay = 1;
    %Generate gaussian dist angles in the forward facing hemisphere from
    %camera
    %phi = normrnd(90, 40); theta = normrnd(0,40);
    minPhi = 1; maxPhi = 179; minTheta = -89; maxTheta = 89;
    phi = (maxPhi-minPhi)*rand + minPhi;
    theta = (maxTheta-minTheta)*rand + minTheta;
    rx = camPos(1); ry = camPos(2); rz = camPos(3);
    
    while rz < lightSource(3)
        %ray marching and update L, C
        [rx, ry, rz, theta, phi, LGrid, CGrid, TRay, hits] = trace2Scatter(LX, LY, LZ, rx, ry, rz, LGrid, CGrid, IGrid, stepSize, TVox, phi, theta, TRay, alb, sourceBright, hits, dx, lightSource, walls);
        if hits == hitTol
            rz = lightSource(3);
            wallTerminationTot = wallTerminationTot + 1;
        end
        %generate deflection angle
        [theta, phi] = deflectionAngle(theta, phi, cdfPhi, cdfTheta);
        stepNum = stepNum + 1;
    end
    
    raysCompleted = raysCompleted + 1;
    stepNumTot = stepNumTot + stepNum;
    
end

a = ['Avg # of Steps Taken: ', num2str(stepNumTot/N)];
b = ['# of Wall Terminations: ', num2str(wallTerminationTot)];
disp(a)
disp(b)

end

