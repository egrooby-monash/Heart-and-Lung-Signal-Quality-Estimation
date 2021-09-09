function [systole,diastole]=rozdzielaczfaz(PCG, A)

% [assigned_states] =dlmread(['C:\PNC2016\data\ann_ALL\' name '_annotation.txt']);
    
% 
%     indx = find(abs(diff(assigned_states))>0); % find the locations with changed states
%     if assigned_states(1)>0   % for some recordings, there are state zeros at the beginning of assigned_states
%         switch assigned_states(1)
%             case 4
%                 K=1;
%             case 3
%                 K=2;
%             case 2
%                 K=3;
%             case 1
%                 K=4;
%         end
%     else
%         switch assigned_states(indx(1)+1)
%             case 4
%                 K=1;
%             case 3
%                 K=2;
%             case 2
%                 K=3;
%             case 1
%                 K=0;
%         end
%         K=K+1;
%     end
%     
%     indx2                = indx(K:end);
%     rem                  = mod(length(indx2),4);
%     indx2(end-rem+1:end) = [];
%     A                    = reshape(indx2,4,length(indx2)/4)'; % A is N*4 matrix, the 4 columns save the beginnings of S1, systole, S2 and diastole in the same heart cycle respectively
%     
    %% 1- S1, 2-Systole, 3 - S2, 4 - Diastole
    systole=[1231432];
    k = 2;
    for g = 1:size(A,1)-1 %(bez ostatnich faz)
        if k == 4 % to po to, zeby sie zgadzalo
            s = PCG((A(g,k)-20):A(g+1,1));
%             s = s(20:end-20);
        else
            s = PCG((A(g,k)-20):A(g,k+1));
%             s = s(20:end-20);
        end
        systole(end:end+length(s)-1) = s(:,1);
        %size(s)
    end
    systole = systole(2:end);
    
    
    
    diastole=[1231432];
    k = 4;
    for g = 1:size(A,1)-1 %(bez ostatnich faz)
        if k == 4 % to po to, zeby sie zgadzalo
            d = PCG((A(g,k)-20):A(g+1,1));
            %d = d(20:end-20);
        else
            d = PCG((A(g,k)-20):A(g,k+1));
            %d = d(20:end-20);
        end
        diastole(end:end+length(d)-1) = d(:,1);
        %size(s)
    end
    diastole = diastole(2:end);
end