function [Grid] = normGrid(Grid)
%Normalize an nxnxdim grid. For now not sure if it works for dim != 1

normGrid = Grid - min(Grid(:));
Grid = normGrid ./ max(normGrid(:));


end

