function  [mdfint2, PCG] =PCG_filtering_iga(PCG,fs)
% used to be called qrs_detect2_PCG_modified
%% Paper Information
% PCG classification using a neural network approach
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7868946

%% Inputs
% PCG signal
% Fs: sampling frequency

%% Output
% mdfint2: envelope of PCG
% PCG: processed PCG signal

%% Methods
[a,b] = size(PCG);
if(a>b)
elseif(b>a)
    PCG=PCG';
end

% == constants
MED_SMOOTH_NB_COEFF = round(fs/100);
% length is 7 for fs=256Hz
INT_NB_COEFF = round(28*fs/256);


PCG = butterworth_low_pass_filter(PCG,2,80,fs, false);
PCG = butterworth_high_pass_filter(PCG,2,30,fs);
bpfPCG=PCG';
bpfPCGNew=[];
len=length(bpfPCG);
windowN=40;
for j=1:windowN
    bpfPCGNewtemp=bpfPCG(1+floor(len/windowN)*(j-1):j*floor(len/windowN));
    bpfPCGNew=[bpfPCGNew  (bpfPCGNewtemp-mean(bpfPCGNewtemp))/(max(bpfPCGNewtemp)-min(bpfPCGNewtemp))];
end

bpfPCG=bpfPCGNew;
% (5) square PCG
sqrPCG = bpfPCG'.*bpfPCG';
% (6) integrate
intPCG = filter(ones(1,INT_NB_COEFF),1,sqrPCG);
% (7) smooth
mdfint = medfilt1(intPCG,MED_SMOOTH_NB_COEFF);
delay  = ceil(INT_NB_COEFF/2);
% remove filter delay for scanning back through PCG
mdfint = circshift(mdfint,-delay);

mdfint2=movingAvgForwBack(mdfint, 40);
end