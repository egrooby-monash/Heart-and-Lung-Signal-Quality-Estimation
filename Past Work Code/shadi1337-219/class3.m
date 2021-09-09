load('net_r_100.mat');
load('w_hame.mat');
load('net_R_hame_100.mat')
ye=net_r_100(all_features');
 classifyResult1=converter(ye');
 se=net_R_hame_100(all_features');
 classifyResult2=converter(se');
 
 if classifyResult1==classifyResult2
     
 classifyResult=classifyResult1;
 else 
     we=(se+ye)/2;
     
   classifyResult= converter(we');
 end