%% calculate mean and std for entropy of systoles
function [mean_entropy_systole,std_entropy_systole,skewness_entropy_systole,kurtosis_entropy_systole,mean_entropy_diastole,std_entropy_diastole,kurtosis_entropy_diastole,skewness_entropy_diastole,mean_power_sys,std_power_sys,kurtosis_power_sys,skewness_power_sys,mean_power_dias,std_power_dias,kurtosis_power_dias,skewness_power_dias]=shadi_features(A,signal_systole,signal_diastole,signal_s1,signal_s2)
%% mean and std of entropy for systole
j=1
seperate_systoles=cell(size(A,1),1);
for i=1:size(A,1)
seperate_systoles{j,1}=signal_systole(A(i,2):A(i,3))
j=j+1

end

m=1;

entropy_systole=0;
power_sys=0;
for k=1:size(A,1)
entropy_systole(m)=wentropy(seperate_systoles{k,1},'shannon');
power_sys(m)=bandpower(seperate_systoles{k,1});

m=m+1
end 
%%remove outliers for entropy_systole 
z=zscore(entropy_systole);
indicies_e_s=find(abs(z)>2);
entropy_systole(indicies_e_s)=0;
ind=find(entropy_systole);
entropy_systole_new=entropy_systole(ind)

mean_entropy_systole=mean(entropy_systole_new);
std_entropy_systole=std(entropy_systole_new);
kurtosis_entropy_systole=kurtosis(entropy_systole_new);
skewness_entropy_systole=skewness(entropy_systole_new);
%%remove outliers for power_sys
z=zscore(power_sys);
indicies_p_s=find(abs(z)>1);
power_sys(indicies_p_s)=0;
ind=find(power_sys);
power_sys_new=power_sys(ind);

mean_power_sys=mean(power_sys);
std_power_sys=std(power_sys);
kurtosis_power_sys=kurtosis(power_sys);
skewness_power_sys=skewness(power_sys);
%% mean and std of entropy for diastole
j=1;
seperate_diastoles=cell(size(A,1),1);
for i=1:size(A,1)-1
seperate_diastoles{j,1}=signal_diastole(A(i:end-1,4):A(i+1:end,1));

seperate_diastoles{j,1}=seperate_diastoles{j,1}(1:end-30);
j=j+1
end
% payane diastole ha eshtebah mishe 30 ta sample akharesho bezan bere


m=1;

entropy_diastole=0;
power_dias=0;
for k=1:size(A,1)-1
entropy_diastole(m)=wentropy(seperate_diastoles{k,1},'shannon');
power_dias(m)=bandpower(seperate_diastoles{k,1});
m=m+1
end 
z=zscore(entropy_diastole);
indicies_e_d=find(abs(z)>2);
entropy_diastole(indicies_e_s)=0;
ind=find(entropy_diastole);
entropy_diastole_new=entropy_diastole(ind);
mean_entropy_diastole=mean(entropy_diastole_new);
std_entropy_diastole=std(entropy_diastole_new);
kurtosis_entropy_diastole=kurtosis(entropy_diastole_new);
skewness_entropy_diastole=skewness(entropy_diastole_new);

%%remove outliers for power_dias
z=zscore(power_dias);
indicies_p_d=find(abs(z)>1);
power_dias(indicies_p_d)=0;
ind=find(power_dias);
power_dias_new=power_dias(ind);

mean_power_dias=mean(power_sys_new);

std_power_dias=std(power_sys_new);

kurtosis_power_dias=kurtosis(power_sys_new);

skewness_power_dias=skewness(power_sys_new);
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

m=m+1
end 

%%remove outliers for power_s1
z=zscore(power_s1);
indicies_p_s1=find(abs(z)>1);
power_s1(indicies_p_s1)=0;
ind=find(power_s1);
power_s1_new=power_s1(ind);

%% finding bad s2
 j=1;
seperate_s2=cell(size(A,1),1);

for i=1:size(A,1)
seperate_s2{j,1}=signal_s2(A(i,3):A(i,4));
j=j+1;

end
m=1
power_s2=0;
for k=1:size(A,1)

 power_s2(m)=bandpower(seperate_s2{k,1});
%power_s2(m)=norm(seperate_s2{k,1},2)^2/numel(seperate_s2{k,1});

m=m+1
end 

%%remove outliers for power_s2
z=zscore(power_s2);
indicies_p_s2=find(abs(z)>1);
power_s2(indicies_p_s2)=0;
ind=find(power_s2);
power_s2_new=power_s2(ind);
bad_cycles=[indicies_p_s ,indicies_p_d ,indicies_p_s1];

end
