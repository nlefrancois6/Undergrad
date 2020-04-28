function [u] = CR_SolveLevels(g_ni, T_ni, u, f, dx, yLen, printTest)
%Solve for u values at each of the f levels

denom = 2;
yLenEven = yLen-1;

%Level f
pos = yLenEven/denom;
if printTest == true
    disp(['f = ', num2str(f)])
    disp(['Denom = ', num2str(denom)])
    disp(['Pos = ', num2str(pos + 1)])
    disp(['Lower BC = ', num2str((pos - yLenEven/denom + 1))])
    disp(['Upper BC = ', num2str((pos + yLenEven/denom + 1))])
end
%Solving T_ni(:,f).*u(yLenEven/2,:) = (dx^2)*g_ni(yLenEven/2, :, f) - u(1,:) - u(yLen,:);
RHS = (dx^2)*g_ni(pos + 1, :, f) - u(1,:) - u(yLen,:);
A = T_ni(yLenEven/denom+1,:,f); b = RHS;
u(pos + 1,:) = A.\b;

%Lower levels 1, 2, ..., f-1
for level=2:f
    denom = denom*2;
    %If oscillations occur in top half of u it's because the upper limit
    %  of splits isnt big enough to reach the top line. (I was 
    %having this problem when I was originally using splits=0:8*levels).
    %This shouldn't occur any more using splits=0:2^(level-1)-1, since it
    %will keep up as the number of rows grows.
    for splits=0:2^(level-1)-1
        pos = yLenEven/denom + 2*splits*yLenEven/denom;
        if pos<yLen
            %Unless we overshoot the s upper BC, solve for u(pos+1)
            if (pos + yLenEven/denom)/yLenEven <= 1
                    if printTest == true
                        disp(['f = ', num2str(f+1-level)])
                        disp(['Pos = ', num2str(pos + 1)])
                        disp(['Lower BC = ', num2str((pos - yLenEven/denom + 1))])
                        disp(['Upper BC = ', num2str((pos + yLenEven/denom + 1))])
                    end
                    RHS = (dx^2)*g_ni(pos + 1, :, f+1-level) - u(pos - yLenEven/denom + 1,:) - u(pos + yLenEven/denom + 1,:);
                    A = T_ni(pos + 1,:,f+1-level); b = RHS;
                    u(pos + 1,:) = A.\b;
            end
        else
            disp('POS>LEN')
        end
    end
end


end

