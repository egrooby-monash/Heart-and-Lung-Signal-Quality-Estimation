function [hr_aver,hr_std]=getStdHeartRate_modified(enve,max_HR,min_HR,fs)
%% Paper Information
% Automated Signal Quality Assessment for Heart Sound Signal by Novel Features and Evaluation in Open Public Datasets
% https://downloads.hindawi.com/journals/bmri/2021/7565398.pdf

%% Inputs
% enve: envelope of audio
% max_HR: maximum heart rate
% min_HR: minimum heart rate 
% fs: sample frequency

%% Output
% hr_aver: average heart rate
% hr_std: standard deviation of heart rate

%% Methods
% to get standard deviation of time varying heart rate

% sliding window length
win_Len=round(3*fs);  
% sliding step
step=round(1*fs);  

% ratio of the windown length to the signal length
th=win_Len/length(enve);    
% total energy
T_Ener=sum(enve.^2);     

flag=0;
c=0;
while(flag==0)
    % starting point
    k1=c*step+1;      
    % end point
    k2=k1+win_Len-1;  
    if k2<=length(enve)
        % envelope in current window
        cur_enve=enve(k1:k2);   
        c=c+1;
        % a criteria to judge current envelope is ok or not.
        if sum(cur_enve.^2)/T_Ener< 0.05*th    
            Hr(c)=0;
        else
            cur_enve=cur_enve-mean(cur_enve);
            axcor_enve_double_side=xcorr(cur_enve,'coeff');
            axcor_enve_single_side=axcor_enve_double_side(length(cur_enve):end);            
            % to get heart rate in current window
            Hr(c)=fs/getCycleDur_modified(axcor_enve_single_side,max_HR,min_HR,fs);   
        end
    else
        flag=1;
    end
end

hr_aver=mean(Hr);  % average heart rate
hr_std=std(Hr);     % standard deviation of heart rate
end