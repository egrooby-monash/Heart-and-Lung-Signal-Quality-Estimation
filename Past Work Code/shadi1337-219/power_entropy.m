%% calculate mean and std for entropy of systoles
%function [mean_entropy_systole,std_entropy_systole,skewness_entropy_systole,kurtosis_entropy_systole,mean_entropy_diastole,std_entropy_diastole,kurtosis_entropy_diastole,skewness_entropy_diastole,mean_power_sys,std_power_sys,kurtosis_power_sys,skewness_power_sys,mean_power_dias,std_power_dias,kurtosis_power_dias,skewness_power_dias]=power_entropy(a,signal_systole,signal_diastole)
function power_entropy_mean=power_entropy(a,signal_systole,signal_diastole)
%% mean and std of entropy for systole
j=1;
seperate_systoles=cell(size(a,1),1);
for i=1:size(a,1)
seperate_systoles{j,1}=signal_systole(a(i,2):a(i,3));
j=j+1;

end

m=1;

entropy_systole=0;
power_sys=0;
for k=1:size(a,1)
entropy_systole(m)=wentropy(seperate_systoles{k,1},'shannon');
power_sys(m)=bandpower(seperate_systoles{k,1});

m=m+1;
end 


mean_entropy_systole=mean(entropy_systole);
std_entropy_systole=std(entropy_systole);
kurtosis_entropy_systole=kurtosis(entropy_systole);
skewness_entropy_systole=skewness(entropy_systole);


mean_power_sys=mean(power_sys);
std_power_sys=std(power_sys);
kurtosis_power_sys=kurtosis(power_sys);
skewness_power_sys=skewness(power_sys);
%% mean and std of entropy for diastole
j=1;
seperate_diastoles=cell(size(a,1),1);
for i=1:size(a,1)
seperate_diastoles{j,1}=signal_diastole(a(i,4):a(i,5));

%seperate_diastoles{j,1}=seperate_diastoles{j,1}(1:end-30);
j=j+1;
end
m=1;
entropy_diastole=0;
power_dias=0;
for k=1:size(a,1)
entropy_diastole(m)=wentropy(seperate_diastoles{k,1},'shannon');
power_dias(m)=bandpower(seperate_diastoles{k,1});
m=m+1;
end 

mean_power_dias=mean(power_dias);
std_power_dias=std(power_dias);
kurtosis_power_dias=kurtosis(power_dias);
skewness_power_dias=skewness(power_dias);

mean_entropy_diastole=mean(entropy_diastole);
std_entropy_diastole=std(entropy_diastole);
kurtosis_entropy_diastole=kurtosis(entropy_diastole);
skewness_entropy_diastole=skewness(entropy_diastole);


power_entropy_mean=...
[mean_power_sys,...
std_power_sys,...
kurtosis_power_sys,...
skewness_power_sys,...
mean_power_dias,...
std_power_dias,...
kurtosis_power_dias,...
skewness_power_dias,...
mean_entropy_systole,...
std_entropy_systole,...
kurtosis_entropy_systole,...
skewness_entropy_systole, ...
mean_entropy_diastole,...
std_entropy_diastole,...
kurtosis_entropy_diastole,...
skewness_entropy_diastole];


end
