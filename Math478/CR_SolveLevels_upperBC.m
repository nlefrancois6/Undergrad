function [u] = CR_SolveLevels_upperBC(g_ni, T_ni, u, f, dx, yLen, printTest)
%Solve for u values at each of the f levels

denom = 2;

%Level f
pos = yLen/denom;
if printTest == true
    disp(['f = ', num2str(f)])
    disp(['Denom = ', num2str(denom)])
    disp(['Pos = ', num2str(pos)])
    disp(['Lower BC = ', num2str((pos - yLen/denom))])
    disp(['Upper BC = ', num2str((pos + yLen/denom))])
end
%T_ni(:,f).*u(yLen/2,:) = (dx^2)*g_nj(yLen/2, :, f) - u(1,:) - u(yLen,:);
RHS = (dx^2)*g_ni(yLen/denom, :, f) - u(1,:) - u(yLen,:);
%Get the three diagonal vectors a,b,c
a = diag(T_ni(:,f),-1); b = diag(T_ni(:,f)); c = diag(T_ni(:,f),1);
u(yLen/denom,:) = tridiag( a, b, c, RHS);


%Lower levels 1, 2, ..., f-1
for level=2:f
    denom = denom*2;
    for splits=0:2*level 
        pos = yLen/denom + 2*splits*yLen/denom;
        if pos<yLen
            if (pos + yLen/denom)/yLen <= 1
                %if (pos - yLen/denom > 0)
                    if printTest == true
                        disp(['f = ', num2str(f+1-level)])
                        disp(['Pos = ', num2str(pos)])
                        disp(['Lower BC = ', num2str((pos - yLen/denom))])
                        disp(['Upper BC = ', num2str((pos + yLen/denom))])
                    end
                    %RHS = (dx^2)*g_ni(pos, :, f+1-level) - u(pos - yLen/denom,:) - u(pos + yLen/denom,:);
                    %a = diag(T_ni(:,f+1-level),-1); b = diag(T_ni(:,f+1-level)); c = diag(T_ni(:,f+1-level),1);
                    %u(pos,:) = tridiag( a, b, c, RHS);
                %{
                else
                    if printTest == true
                        disp(['f = ', num2str(f+1-level)])
                        disp(['Pos = ', num2str(pos)])
                        disp(['Lower BC = ', num2str((1))])
                        disp(['Upper BC = ', num2str((pos + yLen/denom))])
                    end                    
                    RHS = (dx^2)*g_ni(pos, :, f+1-level) - u(1,:) - u(pos + yLen/denom,:);
                    a = diag(T_ni(:,f+1-level),-1); b = diag(T_ni(:,f+1-level)); c = diag(T_ni(:,f+1-level),1);
                    u(pos,:) = tridiag( a, b, c, RHS);
                end
                %}
            else
                %c = u(pos + splits*yLen/denom,:);
                if printTest == true
                    disp(['f = ', num2str(f+1-level)])
                    disp(['Pos = ', num2str(pos)])
                    disp(['Upper BC = ', num2str(yLen)])
                end
                %RHS = (dx^2)*g_ni(pos, :, f+1-level) - u(pos - yLen/denom,:) - u(yLen,:);
                %a = diag(T_ni(:,f+1-level),-1); b = diag(T_ni(:,f+1-level)); c = diag(T_ni(:,f+1-level),1);
                %u(pos,:) = tridiag( a, b, c, RHS);
            end
        end
    end
end


end

