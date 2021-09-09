function [a]=mofify_A(A,signal_systole,signal_diastole,signal_s1,signal_s2)
for i=1:size(A,1)-1
    A(i,5)=A(i+1,1);
end
%%
indicies_p_s_f=0;
indicies_p_d_f=0;
indicies_p_s1_f=0;
indicies_p_s2_f=0;
%% systole
j=1;
seperate_systoles=cell(size(A,1),1);
for i=1:size(A,1)
seperate_systoles{j,1}=signal_systole(A(i,2):A(i,3));
j=j+1;

end

m=1;

power_sys=0;

for k=1:size(A,1)
power_sys(m)=bandpower(seperate_systoles{k,1});
m=m+1;
end 

%%remove outliers for power_sys
j=1;
z=zscore(power_sys);
indicies_p_s=find(abs(z)>1);
for i=1:length(indicies_p_s)
    if power_sys(indicies_p_s(i))>=mean(power_sys)
        j
indicies_p_s_f(j)=indicies_p_s(i);
j=j+1;
    end
end
%% diastole
j=1;
seperate_diastoles=cell(size(A,1),1);
for i=1:size(A,1)
seperate_diastoles{j,1}=signal_diastole(A(i,4):A(i,5));

%seperate_diastoles{j,1}=seperate_diastoles{j,1}(1:end-30);
j=j+1;
end
m=1;
power_dias=0;
for k=1:size(A,1)
power_dias(m)=bandpower(seperate_diastoles{k,1});
m=m+1;
end 
%%remove outliers for power_dias
j=1;
z=zscore(power_dias);
indicies_p_d=find(abs(z)>1);
for i=1:length(indicies_p_d)
    if power_dias(indicies_p_d(i))>=mean(power_dias)
        j
indicies_p_d_f(j)=indicies_p_d(i);
j=j+1;
    end
end
%% finding bad s1
 j=1;
seperate_s1=cell(size(A,1),1);

for i=1:size(A,1)
seperate_s1{j,1}=signal_s1(A(i,1):A(i,2));
j=j+1;

end

m=1;


power_s1=0;
for k=1:size(A,1)

 power_s1(m)=bandpower(seperate_s1{k,1});
%power_s1(m)=norm(seperate_s1{k,1},2)^2/numel(seperate_s1{k,1});

m=m+1;
end 
indicies_p_s1_f=0;
j=1;
%%remove outliers for power_s1
z=zscore(power_s1);
indicies_p_s1=find(abs(z)>1);
for i=1:length(indicies_p_s1)
    if power_s1(indicies_p_s1(i))<=mean(power_s1)
        j
indicies_p_s1_f(j)=indicies_p_s1(i);
j=j+1;
    end
end
        
     
%%finding bad s2
 j=1;
seperate_s2=cell(size(A,1),1);

for i=1:size(A,1)
seperate_s2{j,1}=signal_s2(A(i,3):A(i,4));
j=j+1;

end
m=1;
power_s2=0;
for k=1:size(A,1)

 power_s2(m)=bandpower(seperate_s2{k,1});
%power_s2(m)=norm(seperate_s2{k,1},2)^2/numel(seperate_s2{k,1});

m=m+1;
end 

j=1;
indicies_p_s2_f=0;
%%remove outliers for power_s2
z=zscore(power_s2);
indicies_p_s2=find(abs(z)>1);
for i=1:length(indicies_p_s2)
    if power_s2(indicies_p_s2(i))<=mean(power_s2)
        j
indicies_p_s2_f(j)=indicies_p_s2(i);
j=j+1;
    end
end

%%

bad_cycles=[indicies_p_s_f, indicies_p_d_f,indicies_p_s1_f,indicies_p_s2_f];
bad_cycles=nonzeros(unique(sort(bad_cycles)))';

%% A_MODIFY
a=A;
 a(bad_cycles,:)=[];
  
    

end