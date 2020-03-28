N=10;

L = 2*pi;

BMat = getBMatrix(N,L);

%imagesc(abs(BMat))

TMat = BMat - 2*eye(N);
%imagesc(abs(TMat));

f=4;
yLen = 2^f;
disp(['f = ', num2str(f)])
%Level f
denom = 2;
disp(['Denom = ', num2str(denom)])
pos = yLen/denom;
disp(['Pos = ', num2str(pos/yLen)])
disp(['Lower BC = ', num2str((pos - yLen/denom)/yLen)])
disp(['Upper BC = ', num2str((pos + yLen/denom)/yLen)])
%Lower levels 1, 2, ..., f-1
for level=2:f
    denom = denom*2;
    disp(['Denom = ', num2str(denom)])
    %2*level works up to f=4
    for splits=0:2*level
        lev = f+1-level;
        pos = yLen/denom + 2*splits*yLen/denom;
        if pos/yLen<1
            disp(['f = ', num2str(lev)])
            disp(['Pos = ', num2str(pos/yLen)])
            disp(['Lower BC = ', num2str((pos - yLen/denom))])
            disp(['Upper BC = ', num2str((pos + yLen/denom))])
        end
    end
end
