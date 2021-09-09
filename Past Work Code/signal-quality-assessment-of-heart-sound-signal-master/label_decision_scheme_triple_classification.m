function qual=label_decision_scheme_triple_classification(GB,GE,BE)
%
%

L=length(GB);
% B 0;G 1;E 2

for k=1:L
    if (GB(k)==0 && GE(k)==1 && BE(k)==0)
        qual(k,1)=0;
    elseif (GB(k)==0 && GE(k)==1 && BE(k)==2)
        qual(k,1)=2;   % ?
    elseif (GB(k)==0 && GE(k)==2 && BE(k)==0)
        qual(k,1)=0;   
    elseif (GB(k)==0 && GE(k)==2 && BE(k)==2)
        qual(k,1)=2;   
    elseif (GB(k)==1 && GE(k)==1 && BE(k)==0)
        qual(k,1)=1;  
    elseif (GB(k)==1 && GE(k)==1 && BE(k)==2)
        qual(k,1)=1;   
    elseif (GB(k)==1 && GE(k)==2 && BE(k)==0)
        qual(k,1)=0;   % ?
    elseif (GB(k)==1 && GE(k)==2 && BE(k)==2)
        qual(k,1)=2;   
    end
end

