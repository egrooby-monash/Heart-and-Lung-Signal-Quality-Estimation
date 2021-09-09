function [C] = stageIII(Xw,bmin,bmax)
%
%
% Objetive:  The main goal of this stage is to define the subject's 
%            condition, that is, healthy or unhealthy motivated by 
%            the presence or absence of WS.
%
% Input: 
% - Xw:         Estimated wheezing spectrogram
% - bmin:       lower limit of BOI (bins)
% - bmax:       upper limit of BOI (bins)
%
% Output: 
% - C: Indicator to distinguish between non-wheezing (C=0) and wheezing segments (C=1).
%
%
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%% Step I: Determining the optimal candidate for wheezing temporal interval
%--------------------------------------------------------------------------
% Normalization
Ymednn=Xw/max(max(Xw));
Ymedn=Ymednn(bmin:bmax,:);
% spectral energy
E_Ymedn=sum(Ymedn,1);
% threshold
V_Ymedn = E_Ymedn; 
miv = min(E_Ymedn);
mav = max(E_Ymedn);
Tu =  miv + ((mav-miv)*0.10);
V_Ymedn(V_Ymedn>=Tu) = 1;
V_Ymedn(V_Ymedn~=1) = 0;
% Select the optimal candidate (OCW)
flancos = [ 0; V_Ymedn(2:end)'-V_Ymedn(1:(end-1))' ];
inicios = (find(flancos==1));
finales = (find(flancos==-1)); 
if (finales(1) < inicios(1))
    inicios = [1; inicios];
end
if (finales(end) < inicios(end))
    finales = [finales; length(V_Ymedn)+1];
end
ventanas = ([inicios finales]-1);
tam_ven = ventanas(:,2)-ventanas(:,1);
[v_vent, p_vent]  = max(tam_ven);
margen=1;
Y_vent = Ymedn(:,ventanas(p_vent,1)+margen:ventanas(p_vent,2)-margen);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%%  Step II: Smoothness related to the spectral trajectories contained in OCW
%--------------------------------------------------------------------------
% Initializations
posP_h=ones(size(Y_vent,2),5).*1000;
for i=1:size(Y_vent,2)
% Spectral trajectories
      [val,pos]=findpeaks(Y_vent(:,i),'MinPeakProminence',0.1*max(Y_vent(:,i)),'Annotate','extents'); 
      val = val+(ones(1,length(val))+(1:length(val)).*0.0001)';
      if length(pos)==1
      posP_h(i,1)=pos;
      end
      if length(pos)==2
      vals=sort(val,'descend');
      tmp1=find(val==vals(1)); 
      posP_h(i,1)=pos(tmp1);
      tmp2=find(val==vals(2)); 
      posP_h(i,2)=pos(tmp2);
      end
      if length(pos)==3
      vals=sort(val,'descend');
      tmp1=find(val==vals(1));
      posP_h(i,1)=pos(tmp1);
      tmp2=find(val==vals(2));
      posP_h(i,2)=pos(tmp2);
      tmp3=find(val==vals(3));
      posP_h(i,3)=pos(tmp3);
      end
      if length(pos)==4
      vals=sort(val,'descend');
      tmp1=find(val==vals(1));
      posP_h(i,1)=pos(tmp1);
      tmp2=find(val==vals(2));
      posP_h(i,2)=pos(tmp2);
      tmp3=find(val==vals(3));
      posP_h(i,3)=pos(tmp3);
      tmp4=find(val==vals(4));
      posP_h(i,4)=pos(tmp4);
      end
      if length(pos)>4
      vals=sort(val,'descend');
      tmp1=find(val==vals(1));
      posP_h(i,1)=pos(tmp1);
      tmp2=find(val==vals(2));
      posP_h(i,2)=pos(tmp2);
      tmp3=find(val==vals(3));
      posP_h(i,3)=pos(tmp3);
      tmp4=find(val==vals(4));
      posP_h(i,4)=pos(tmp4);
      tmp5=find(val==vals(5));
      posP_h(i,5)=pos(tmp5);
      end      
end
% smoothness of each spectral trajectory
[comprf_h, comprc_h] = find(posP_h<1000);
post5_h=find(comprc_h==5);
cont5_h=length(post5_h);
post4_h=find(comprc_h==4);
cont4_h=length(post4_h);
post3_h=find(comprc_h==3);
cont3_h=length(post3_h);
post2_h=find(comprc_h==2);
cont2_h=length(post2_h);
if cont2_h<=2
    d1_h=sum(diff(posP_h(:,1)).^2)/length(posP_h(:,1)); 
    dt_h = d1_h;
end
if cont2_h>2 & cont3_h<=2
    d1_h = sum(diff(posP_h(:,1)).^2)/length(posP_h(:,1));     
    d2_h = sum(diff(posP_h(comprf_h(post2_h),2)).^2)/length(posP_h(comprf_h(post2_h),2)); 
    dt_h = d1_h+d2_h;
end
if cont3_h>2 & cont4_h<=2
    d1_h=sum(diff(posP_h(:,1)).^2)/length(posP_h(:,1));     
    d2_h=sum(diff(posP_h(comprf_h(post2_h),2)).^2)/length(posP_h(comprf_h(post2_h),2)); 
    d3_h=sum(diff(posP_h(comprf_h(post3_h),3)).^2)/length(posP_h(comprf_h(post3_h),3)); 
    dt_h = d1_h+d2_h+d3_h;
end
if cont4_h>2 & cont5_h<=2
    d1_h=sum(diff(posP_h(:,1)).^2)/length(posP_h(:,1));     
    d2_h=sum(diff(posP_h(comprf_h(post2_h),2)).^2)/length(posP_h(comprf_h(post2_h),2)); 
    d3_h=sum(diff(posP_h(comprf_h(post3_h),3)).^2)/length(posP_h(comprf_h(post3_h),3));
    d4_h=sum(diff(posP_h(comprf_h(post4_h),4)).^2)/length(posP_h(comprf_h(post4_h),4));
    dt_h = d1_h+d2_h+d3_h+d4_h;
end
if cont5_h>2
    d1_h=sum(diff(posP_h(:,1)).^2)/length(posP_h(:,1));     
    d2_h=sum(diff(posP_h(comprf_h(post2_h),2)).^2)/length(posP_h(comprf_h(post2_h),2)); 
    d3_h=sum(diff(posP_h(comprf_h(post3_h),3)).^2)/length(posP_h(comprf_h(post3_h),3));
    d4_h=sum(diff(posP_h(comprf_h(post4_h),4)).^2)/length(posP_h(comprf_h(post4_h),4));
    d5_h=sum(diff(posP_h(comprf_h(post5_h),5)).^2)/length(posP_h(comprf_h(post5_h),5));
    dt_h = d1_h+d2_h+d3_h+d4_h+d5_h;
end
umb=10;
C=dt_h;
C(C<=umb)=1;
C(C>=umb)=0;
%0--> healthy (WS are not active)
%1--> unhealthy (Ws are active)