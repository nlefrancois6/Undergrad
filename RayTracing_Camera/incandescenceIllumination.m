function [IGrid] = incandescenceIllumination(Temp, tmax, IGrid)
%Add the normalized temperature to the illumination grid as well as the
%radiance grid

%{
for x=1:xLen
    for y=1:yLen
        for z=1:zLen
            IGrid(x,y,z) = IGrid(x,y,z) + Temp(x,y,z)/tmax;
            %LGrid(x,y,z) = Temp(x,y,z)/tmax;
        end
    end
end
%}

IGrid(:,:,:) = IGrid(:,:,:) + Temp(:,:,:)./tmax;

end

