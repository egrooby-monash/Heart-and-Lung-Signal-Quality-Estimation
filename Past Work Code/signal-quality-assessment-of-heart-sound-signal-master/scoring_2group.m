function [score]=scoring_2group(T,E)
%  get the score for classification perforamnce
% T, the True labels
% E, Estmated labels

T1=min(T);   % get minimum
T2=max(T);   % get maximum

ind10=[];c10=0;
ind01=[];c01=0;
M=zeros(2,2);
for k=1:length(T)
    if (T(k)==T1 && E(k)==T1)
        M(1,1)=M(1,1)+1;
    elseif (T(k)==T1 && E(k)==T2)
        c01=c01+1;
        ind01=[ind01 k];
        M(1,2)=M(1,2)+1;
    elseif (T(k)==T2 && E(k)==T1)
        c10=c10+1;
        ind10=[ind10 k];
        M(2,1)=M(2,1)+1;
    elseif (T(k)==T2 && E(k)==T2)
        M(2,2)=M(2,2)+1;  
    end
end

score=[M(1,1)/sum(M(:,1)) M(2,2)/sum(M(:,2)) M(1,1)/sum(M(1,:)) M(2,2)/sum(M(2,:))];

% usuall accuracy rate        
acc=sum(T(:)==E(:))/length(T);

score=[score sum(score)/4  acc];


