function [hr_aver,hr_std]=getStdHeartRate(enve,fs)
% to get standard deviation of time varying heart rate
%

win_Len=round(3*fs);  % sliding window length
step=round(1*fs);  % sliding step

th=win_Len/length(enve);    % ratio of the windown length to the signal length
T_Ener=sum(enve.^2);     % total energy

flag=0;
c=0;
while(flag==0)
    k1=c*step+1;      % starting point
    k2=k1+win_Len-1;  % end point
    if k2<=length(enve)
        
        cur_enve=enve(k1:k2);   % envelope in current window
        c=c+1;
        if sum(cur_enve.^2)/T_Ener< 0.05*th    % a cretira to judge current envelope is ok or not.
            Hr(c)=0;
        else
            cur_enve=cur_enve-mean(cur_enve);
            axcor_enve_double_side=xcorr(cur_enve,'coeff');
            axcor_enve_single_side=axcor_enve_double_side(length(cur_enve):end);            
            
            Hr(c)=fs/getCycleDur(axcor_enve_single_side,fs);   % to get heart rate in current window
        end

    else
        flag=1;
    end
    
end

hr_aver=mean(Hr);  % average heart rate
hr_std=std(Hr);     % standard deviation of heart rate