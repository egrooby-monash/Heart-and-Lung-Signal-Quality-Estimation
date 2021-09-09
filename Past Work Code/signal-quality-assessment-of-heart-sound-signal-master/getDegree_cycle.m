function [d,cfs,fz]=getDegree_cycle(rx,Min_cf,Max_cf,fs)
% To extract degree of periodicity from cycle frequency spectrum
% x input signal
% Max_cf  maximum cycle frequency considered 
% fs  sampling frequency
% fz  discret point in cycle frequency domain 
% cfs cycle frequency spectrum
% bcf basic cycle frequency
% welcome to cite the follwing works
% T Li, H Tang, T Qiu. Best subsequence selection of heart sound recording 
% based on degree of sound periodicity. Electronic letters, 2011, 47: 841-842.
% T Li, H Tang, T Qiu. Optimum heart sound signal selection 
% based on the cyclosationary property, Computers in biology and medicine. 2013, 43, 607-612.
% Written by Hong Tang, tanghong@dlut.edu.cn
% School of Biomedical Engineering, Dalian University of Technology, China
%  2010-05-19

    sz=size(rx);
    f_start = Min_cf;  % minimum cycle frequency considered
    f_end = Max_cf;     % in hertz
    M = 2e2;    % number of bins in cycle frequency domain
    
  % fast algorithm to reduce computation
    z=abs(fast_cfs(rx, M,f_start,f_end,fs));

    cfs=z;  
    fz = ((0:length(z)-1)'*(f_end-f_start)/length(z))+f_start;  % vector of cycle frequency

%     f_d=(f_end-f_start)/M;           % sampling interval in cycle frequency domain

%     L=max(sz)/fs;   % length, second

% the second indicator for degree of periodicity
% the high the peak is, the more periodic the signal is.
degree_peak=max(cfs)/median(cfs);

d= degree_peak;


