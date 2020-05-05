function [IGrid] = trace2Source(xLen, yLen, zLen, sxp, syp, szp, dx, denGrid, lightSource, stepSize, TVox)
%Find the direct illumination for each vertex of our cubic grid by tracing
%a ray to the source and attenuate exponentially as a function of density
%at a fixed interval that scales with stepSize


IGrid = zeros(xLen, yLen, zLen);
%{
if denGrid == 1
    %will just use hitting the ceiling as termination condition for now
    r = [sxp(x) syp(y) szp(z)];
    TRay = 1;
    %Define unit vector towards source
    [u] = directionUnitLists(r, lightSource);
                
    %first step
    r = r + u*stepSize;
                
    while(r(3) < lightSource(3))
        %{
                    need to move one step towards source 
                    
                    %will need to use some kind of cross-section for
                    %denGrid collisions big enough to make sure the ray
                    %doesnt just go straight between all the pts
                    
                    %OR just take a fixed distance step and calculate each
                    time
                    %}
        %March one step and update the ray transparency
        [ivx, ivy, ivz, ~, ~, ~] = findAdjVertex(r(1), r(2), r(3), dx);
        TRay = TRay*TVox(ivx, ivy, ivz); 
        r = r + u*stepSize;
    end
                
    IGrid(x, y, z) = TRay;
%}


for x=1:xLen
    for y=1:yLen
        for z=1:zLen
            if denGrid(x, y, z) == 1
                %will just use hitting the ceiling as termination condition for now
                r = [sxp(x) syp(y) szp(z)];
                TRay = 1;
                %Define unit vector towards source
                [u] = directionUnitLists(r, lightSource);
                
                %first step
                r = r + u*stepSize;
                
                while(r(3) < lightSource(3))
                    %{
                    need to move one step towards source 
                    
                    %will need to use some kind of cross-section for
                    %denGrid collisions big enough to make sure the ray
                    %doesnt just go straight between all the pts
                    
                    %OR just take a fixed distance step and calculate each
                    time
                    %}
                    %March one step and update the ray transparency
                    [ivx, ivy, ivz, ~, ~, ~] = findAdjVertex(r(1), r(2), r(3), dx);
                    TRay = TRay*TVox(ivx, ivy, ivz); 
                    r = r + u*stepSize;
                end
                
                IGrid(x, y, z) = TRay;
                
            end
        end
    end
end


%{
%"Requested 4913x4913x4913 (110.4GB) array exceeds maximum array size preference. Creation
%of arrays greater than this limit may take a long time and cause MATLAB to become
%unresponsive. See array size limit or preference panel for more information."

[x,y,z]=meshgrid(1:xLen,1:yLen,1:zLen);
if denGrid(x, y, z) == 1
    %will just use hitting the ceiling as termination condition for now
    r = [sxp(x) syp(y) szp(z)];
    TRay = 1;
    %Define unit vector towards source
    [u] = directionUnitLists(r, lightSource);
                
    %first step
    r = r + u*stepSize;
                
    while(r(3) < lightSource(3))
        %{
        need to move one step towards source 
                    
        %will need to use some kind of cross-section for
        %denGrid collisions big enough to make sure the ray
        %doesnt just go straight between all the pts
                    
        %OR just take a fixed distance step and calculate each
        time
        %}
        %March one step and update the ray transparency
        [ivx, ivy, ivz, ~, ~, ~] = findAdjVertex(r(1), r(2), r(3), dx);
        TRay = TRay*TVox(ivx, ivy, ivz); 
        r = r + u*stepSize;
     end
                
     IGrid(x, y, z) = TRay;
                
end
%}

end

