function score=scoring_3group(T,rE)
%  get the score for classification perforamnce
% T, the True labels
% rE, Estmated labels

M=zeros(3,3);

c1=0; c2=1; c3=2;    % quality label for unacceptable, good and excellent

for k=1:length(T)
    if (T(k)==c1 && rE(k)==c1)
        M(1,1)=M(1,1)+1;        
    elseif (T(k)==c1 && rE(k)==c2)
        M(1,2)=M(1,2)+1;        
    elseif (T(k)==c1 && rE(k)==c3)
        M(1,3)=M(1,3)+1;        
    elseif (T(k)==c2 && rE(k)==c1)
        M(2,1)=M(2,1)+1;        
    elseif (T(k)==c2 && rE(k)==c2)
        M(2,2)=M(2,2)+1;        
    elseif (T(k)==c2 && rE(k)==c3)
        M(2,3)=M(2,3)+1;        
    elseif (T(k)==c3 && rE(k)==c1)
        M(3,1)=M(3,1)+1;        
    elseif (T(k)==c3 && rE(k)==c2)
        M(3,2)=M(3,2)+1;        
    elseif (T(k)==c3 && rE(k)==c3)
        M(3,3)=M(3,3)+1; 
    end
end

score=[M(1,1)/sum(M(:,1))    M(2,2)/sum(M(:,2))    M(3,3)/sum(M(:,3)) ...
           M(1,1)/sum(M(1,:))     M(2,2)/sum(M(2,:))    M(3,3)/sum(M(3,:))];
 
% usuall accuracy rate        
acc=sum(T(:)==rE(:))/length(T);

score=[score sum(score)/6 acc];
        

