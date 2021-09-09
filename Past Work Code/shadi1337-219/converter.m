function [classifyresults]=converter(se)

if se(:,1)> 0.75
    classifyresults=1;
else  
    classifyresults=-1;
       
   end
end