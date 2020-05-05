classdef grid3D
    % grid3D Defines a grid structure on a 2D computational domain.
    %   Takes care of all operations and change of variables between
    %   computational domain and reference space.
    %   The computational space is assumed to be [0, LX] x [0, LY] periodic.
    
   properties
      
       gridsize     % size of the matrix (may be obsolete, remove if ok)
       NX           % Number of cells in x-direction (for rectangular)
       NY           % Number of cells in y-direction (for rectangular)
       NZ           % Number of cells in z-direction (for rectangular)
       NG           % Number of grid points
       cellwidth    % Width of each cell [dx dy dz]
       type         % Type of grid (boundary conditions, currently only allows flat torus)
       boxsize      % rectangular prism
       
   end
    
   methods
      
       function obj = grid3D(nx, ny, nz, LX, LY, LZ, type)
           % Construct grid object. So far, only type = 'uniform-periodic'
           % with nx by ny by nz rectangular grid is implemented.
           
           if nargin == 6
              type = 'uniform-periodic';
           end
           
           obj.type = type;
           
           switch type
               case 'uniform-periodic'
                   obj.NX = nx;
                   obj.NY = ny;
                   obj.NZ = nz;
                   obj.gridsize = [ny nx nz];
                   obj.cellwidth = [LX/nx LY/ny LZ/nz];
                   obj.NG = nx*ny*nz;
                   obj.boxsize = [LX LY LZ];
                   
               otherwise
                   disp('grid type unavailable');
           end
           
       end
       
       
       
       function [cinds, xs, ys, zs, dx, dy, dz] = cellcoords(obj, xb, yb, zb, xq, yq, zq)
           % Maps coordinates in computation domain to the reference space
           % [0,1]^3 (unit cube). 
           % Input: (xb, yb, zb) n by 1 vectors which specify the which cell is
           % used. (xq, yq, zq) n by nsten vectors. Each row contain the
           % position of the nsten query points RELATIVE to the same row in
           % (xb, yb, zb).
           
           
           
           cw = obj.cellwidth;
           dx = cw(1); dy = cw(2); dz = cw(3);
           gsize = obj.gridsize;
           nx = obj.NX; ny = obj.NY; nz = obj.NZ;
           
           % use base points to choose cell
           xdiv = xb./dx;
           ydiv = yb./dy;
           zdiv = zb./dz;
           xfloor = floor(xdiv);
           yfloor = floor(ydiv);
           zfloor = floor(zdiv);
           
           xc = xdiv - xfloor;
           yc = ydiv - yfloor;
           zc = zdiv - zfloor;
           
           xgm = xfloor;
           xgp = xfloor+1;
           xgm = mod(xgm, nx) + 1;
           xgp = mod(xgp, nx) + 1;
           ygm = yfloor;
           ygp = yfloor+1;
           ygm = mod(ygm, ny) + 1;
           ygp = mod(ygp, ny) + 1;
           zgm = zfloor;
           zgp = zfloor+1;
           zgm = mod(zgm, nz) + 1;
           zgp = mod(zgp, nz) + 1;
           
           cmmm = sub2ind(gsize, ygm, xgm, zgm);
           cmmp = sub2ind(gsize, ygm, xgm, zgp);
           cmpm = sub2ind(gsize, ygp, xgm, zgm);
           cmpp = sub2ind(gsize, ygp, xgm, zgp);
           cpmm = sub2ind(gsize, ygm, xgp, zgm);
           cpmp = sub2ind(gsize, ygm, xgp, zgp);
           cppm = sub2ind(gsize, ygp, xgp, zgm);
           cppp = sub2ind(gsize, ygp, xgp, zgp);
           
           cinds = [cmmm cmmp cmpm cmpp cpmm cpmp cppm cppp];
           
           xs = xc + xq./dx;
           ys = yc + yq./dy;
           zs = zc + zq./dz;
           
           
       end
       
       
       
       % ADD A FUNCTION TO GENERATE THE FOURIER GRIDPOINTS FOR THIS GRID
       
       function [xg, yg, zg] = gridpoints(obj)
           % Lists all grid points in matrix form.
           
           cwidth = obj.cellwidth;
           nx = obj.NX;
           ny = obj.NY;
           nz = obj.NZ;
           dx = cwidth(1);
           dy = cwidth(2);
           dz = cwidth(3);
           
           [xg, yg, zg] = meshgrid(0:nx-1, 0:ny-1, 0:nz-1);
           xg = xg*dx;
           yg = yg*dy;
           zg = zg*dz;

       end
       
   end
    
    
end