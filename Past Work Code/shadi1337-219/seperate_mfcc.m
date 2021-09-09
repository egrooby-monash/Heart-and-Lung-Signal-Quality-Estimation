function[mfcc_s1,mfcc_s2,mfcc_sys,mfcc_dis]=seperate_mfcc(mean_mfcc)
for i=1:length(mean_mfcc)
a1=mean_mfcc{i};
mfcc_s1(:,i)=a1(:,1);
end
mfcc_s1=mfcc_s1';



for i=1:length(mean_mfcc)
a2=mean_mfcc{i};
mfcc_s2(:,i)=a2(:,2);
end
mfcc_s2=mfcc_s2';

for i=1:length(mean_mfcc)
a4=mean_mfcc{i};
mfcc_dis(:,i)=a4(:,4);
end
mfcc_dis=mfcc_dis';


for i=1:length(mean_mfcc)
a3=mean_mfcc{i};
mfcc_sys(:,i)=a3(:,3);
end
mfcc_sys=mfcc_sys';
