function [d,cfs,fz,HR]=getDegree_cycle_modified(x,Min_cf,Max_cf,fs)
%% Paper Information
% Automated Signal Quality Assessment for Heart Sound Signal by Novel Features and Evaluation in Open Public Datasets
% https://downloads.hindawi.com/journals/bmri/2021/7565398.pdf

%% Purpose
% To extract degree of periodicity from cycle frequency spectrum
% x input signal

%% Inputs
% x: audio signal
% Min_cf: minimum cycle frequency in Hz
% Max_cf: maximum cycle frequency in Hz
% fs: sampling frequency

%% Outputs
% d: degree of periodicity of best peak
% cfs: cycle frequency spectrum
% fz: discrente point in cycle frequency domain
% HR: heart rate estimation

%% Other variables
% bcf basic cycle frequency

%% Other information
% welcome to cite the follwing works
% T Li, H Tang, T Qiu. Best subsequence selection of heart sound recording
% based on degree of sound periodicity. Electronic letters, 2011, 47: 841-842.
% T Li, H Tang, T Qiu. Optimum heart sound signal selection
% based on the cyclosationary property, Computers in biology and medicine. 2013, 43, 607-612.
% Written by Hong Tang, tanghong@dlut.edu.cn
% School of Biomedical Engineering, Dalian University of Technology, China
%  2010-05-19

% minimum cycle frequency considered in hertz
f_start = Min_cf;
% maximum cycle frequency considered in hertz
f_end = Max_cf;
% number of bins in cycle frequency domain
M = 2e2;

% fast algorithm to reduce computation
z=abs(fast_cfs_modified(x, M,f_start,f_end,fs));

% Cycle frequency spectral density
cfs=z;
% Discreate point in cycle frequency domain
fz = ((0:length(z)-1)'*(f_end-f_start)/length(z))+f_start;  % vector of cycle frequency

% the second indicator for degree of periodicity
% the high the peak is, the more periodic the signal is.
[max_cfs,loc]=max(cfs);
degree_peak=max_cfs/median(cfs);

d= degree_peak;

HR=60/fz(loc); 

end
