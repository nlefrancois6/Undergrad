function [hit, wall] = checkWallHit(rx, ry, rz, LX, LY, LZ, walls)
%check whether the ray has hit a wall

hit = false;
wall = [0 0 0];

if (ry < 0) || (ry > LY)
    hit = true;
    %wall = [50 0 0]./256;
    wall = walls(4:6);
elseif (rx < 0) || (rx > LX)
    hit = true;
    %wall = [0 0 0]./256;
    wall = walls(1:3);
elseif (rz > LZ)
    hit = true;
    %wall = [30 20 40]./256;
    wall = walls(10:12);
elseif (rz < 0)
    hit = true;
    wall = walls(7:9);
end
    
end

