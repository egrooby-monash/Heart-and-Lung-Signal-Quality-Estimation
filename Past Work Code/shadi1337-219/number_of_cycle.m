function [beat_cell,N]=number_of_cycle(assigned_states)
a=find(assigned_states==1);
c=a(1);
j=1;
for i=2:length(a)
    b=a(i)-a(i-1);
    if b ~= 1
        j=j+1;
        c(j)=a(i+1);
    end
end
N=length(c)-1;
beat_cell=cell(N-2,1);
for i=1:N-2
    beat_cell{i,1}=[c(i+1):c(i+2)];
end
N=N-2;
end