function [m_diff_RR,sd_diff_RR,mean_diff_IntS1,sd_diff_IntS1,mean_diff_IntS2,sd_diff_IntS2,mean_diff_IntSys,sd_diff_IntSys,mean_diff_IntDia,sd_diff_IntDia ]  = roznice( A )


m_diff_RR        = (mean(diff(diff(A(:,1)))));             % mean value of differences between consecutive RR intervals
sd_diff_RR       = (std(diff(diff(A(:,1)))));              % SD value for vector of differences between consecutive RR intervals
mean_diff_IntS1  = (mean(diff(A(:,2)-A(:,1))));            % mean value of differences between consecutive S1 intervals
sd_diff_IntS1    = (std(diff(A(:,2)-A(:,1))));             % SD value for vector of differences between consecutive S1 intervals
mean_diff_IntS2  = (mean(diff(A(:,4)-A(:,3))));            % mean value of differences between consecutive S2 intervals
sd_diff_IntS2    = (std(diff(A(:,4)-A(:,3))));             % SD value for vector of differences between consecutive  S2 intervals
mean_diff_IntSys = (mean(diff(A(:,3)-A(:,2))));            % mean value of differences between consecutive systole intervals
sd_diff_IntSys   = (std(diff(A(:,3)-A(:,2))));             % SD value for vector of differences between consecutive systole intervals
mean_diff_IntDia = (mean(diff(A(2:end,1)-A(1:end-1,4))));  % mean value of differences between consecutive diastole intervals
sd_diff_IntDia   = (std(diff(A(2:end,1)-A(1:end-1,4))));   % SD value for vectore of differences between consecutive  diastole intervals




end
