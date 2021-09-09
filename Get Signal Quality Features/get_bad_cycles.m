function [percentage_bad_cycles_sys,percentage_bad_cycles_dia,...
    percentage_bad_cycles_s1,percentage_bad_cycles_s2,percentage_bad_cycles_overall]...
    =get_bad_cycles(assigned_states,signal_systole,signal_diastole,signal_s1,signal_s2)
%% Paper information
% Detection of pathological heart sounds
% https://iopscience.iop.org/article/10.1088/1361-6579/aa7840/pdf

%% Purpose
% To determine the percentage of bad segmentation cycles

%% Inputs
% assigned states and signal separted into them states

%% Outputs
% percentage of cycles considered bad

%% Method
% We just assume that the assigned_states cover at least 2 whole heart beat cycle
% find the locations with changed states
indx = find(abs(diff(assigned_states))>0); 

% for some recordings, there are state zeros at the beginning of assigned_states
if assigned_states(1)>0
    switch assigned_states(1)
        case 4
            K=1;
        case 3
            K=2;
        case 2
            K=3;
        case 1
            K=4;
    end
else
    switch assigned_states(indx(1)+1)
        case 4
            K=1;
        case 3
            K=2;
        case 2
            K=3;
        case 1
            K=0;
    end
    K=K+1;
end

indx2 = indx(K:end);
rem = mod(length(indx2),4);
indx2(end-rem+1:end) = [];
% a is N*4 matrix, the 4 columns save the beginnings of S1, systole, S2 and diastole in the same heart cycle respectively
A  = reshape(indx2,4,length(indx2)/4)';

for i=1:size(A,1)-1
    A(i,5)=A(i+1,1);
end

%% systole
j=1;
seperate_systoles=cell(size(A,1),1);
for i=1:size(A,1)
    seperate_systoles{j,1}=signal_systole(A(i,2):A(i,3));
    j=j+1;
end

m=1;
power_sys=zeros(1,size(A,1)); 
for k=1:size(A,1)
    power_sys(m)=bandpower(seperate_systoles{k,1});
    m=m+1;
end

% remove outliers for power_sys
z=zscore(power_sys);

indicies_p_s_f=find(z>1);
%% diastole
j=1;
seperate_diastoles=cell(size(A,1),1);
for i=1:size(A,1)
    seperate_diastoles{j,1}=signal_diastole(A(i,4):A(i,5));
    j=j+1;
end
m=1;
power_dias=zeros(1,size(A,1)); 
for k=1:size(A,1)
    power_dias(m)=bandpower(seperate_diastoles{k,1});
    m=m+1;
end

% remove outliers for power_dias
z=zscore(power_dias);

indicies_p_d_f=find(z>1);
%% finding bad s1
j=1;
seperate_s1=cell(size(A,1),1);

for i=1:size(A,1)
    seperate_s1{j,1}=signal_s1(A(i,1):A(i,2));
    j=j+1;
end

m=1;
power_s1=zeros(1,size(A,1));
for k=1:size(A,1)
    power_s1(m)=bandpower(seperate_s1{k,1});
    m=m+1;
end

% remove outliers for power_s1
z=zscore(power_s1);

indicies_p_s1_f=find(z<-1);
%% finding bad s2
j=1;
seperate_s2=cell(size(A,1),1);

for i=1:size(A,1)
    seperate_s2{j,1}=signal_s2(A(i,3):A(i,4));
    j=j+1;
    
end
m=1;
power_s2=zeros(1,size(A,1));
for k=1:size(A,1)
    power_s2(m)=bandpower(seperate_s2{k,1});
    m=m+1;
end

% remove outliers for power_s2
z=zscore(power_s2);

indicies_p_s2_f=find(z<-1); 

bad_cycles=[indicies_p_s_f, indicies_p_d_f,indicies_p_s1_f,indicies_p_s2_f];
bad_cycles=nonzeros(unique(sort(bad_cycles)))';

total_cycles=size(A,1);
percentage_bad_cycles_sys=length(indicies_p_s_f)/total_cycles*100;
percentage_bad_cycles_dia=length(indicies_p_d_f)/total_cycles*100;
percentage_bad_cycles_s1=length(indicies_p_s1_f)/total_cycles*100;
percentage_bad_cycles_s2=length(indicies_p_s2_f)/total_cycles*100;
percentage_bad_cycles_overall=length(bad_cycles)/total_cycles*100;
end