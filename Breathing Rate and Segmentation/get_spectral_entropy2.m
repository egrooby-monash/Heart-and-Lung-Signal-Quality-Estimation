function E=get_spectral_entropy2(s,fs)
%% Paper Information
% Automatic Multi-Level In-Exhale Segmentation and Enhanced Generalized S-Transform for wheezing detection
% https://www.sciencedirect.com/science/article/pii/S0169260719305048 
%% Inputs
% s= lung sound
% fs= sampling frequency
%% Output
% E= sepctral entropy


%Artifacts removal
%7.5Hz first order butterworth high pass- remove DC offset
[b,a] = butter(1,7.5/(fs/2),'high');
s = filter(b,a,s);
%s = butterworth_high_pass_filter(s,1,7.5,fs);

%4th order bandpass filter 150-2000Hz (i.e. lowpass 150)
%s = butterworth_low_pass_filter(s,2,150,fs);
[b,a] = butter(2,150/(fs/2));
s = filter(b,a,s);

%% Assigned values myself
%number of samples of the frame  %25ms window
L_w=round(25/1000*fs); 
%overlap %50% overlap changed to 60% overlap for rounding purposes
o=0.6; 
 %number of samples per frame
win_width=L_w;
window=hann(L_w,'periodic');
%% Step 1
%number of samples of s(n)
L=length(s); 
 %shift of frame
inc=round((1-o)*win_width);
%number of frames
I= floor((L-L_w)/inc+1);

E=zeros(1,I);

if size(window,2)~=size(s,2)
    window=window';
end
for i=1:I-1
    %frame shift
    T=inc; 
    %window length
    N=L_w; 
    k=(i+2)*T;
    fin=k;
    start=k-N+1;
    E(i)=sum((s(start:fin).*window).^2);
end

E = resample(E, fs, fs/(inc));
end