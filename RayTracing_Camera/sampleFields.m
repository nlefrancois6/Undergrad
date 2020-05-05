function [TSamp, rhoSamp] = sampleFields(xLen, yLen, zLen, LX, LY, LZ, NP, Temp, rho)
%Sample the temperature and density fields onto the fixed grid we'll use
%for ray tracing

%Works for initial conditions but not sure how if it will need to take
%pullback coordinates for later steps

% TSamp = zeros(xLen, yLen, zLen);
% rhoSamp = zeros(xLen, yLen, zLen);
% dx = LX/(NP+1); dy = LY/(NP+1); dz = LZ/(NP+1);

sx = linspace(0, LX, xLen);
sy = linspace(0, LY, yLen);
sz = linspace(0, LZ, zLen);
[xg, yg, zg] = meshgrid(sx, sy, sz);

TSamp = Temp(xg, yg, zg);
rhoSamp = rho(xg, yg, zg);
% 
% for x=1:xLen
%     for y=1:yLen
%         for z=1:zLen
%             TSamp(x,y,z) = Temp(dx*(x-1),dy*(y-1),dz*(z-1));
%             rhoSamp(x,y,z) = rho(dx*(x-1),dy*(y-1),dz*(z-1));
%         end
%     end
% end

end

