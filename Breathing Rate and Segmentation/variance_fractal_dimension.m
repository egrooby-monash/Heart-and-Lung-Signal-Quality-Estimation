function D_o=variance_fractal_dimension(audio_data,fs)
%% Paper Information
% Respiratory onset detection using variance fractal dimension
% https://ieeexplore.ieee.org/abstract/document/1020507/ 
%% Purpose
% variance fractal representation of the signal to easier detect breathing 
%% Inputs
% audio_data= lung sound
% fs= sampling frequency
%% Output
% D_o vairance fractal dimension

% D_e= embedding dimension which is equal to 1 for curves
D_e=1;
%D_o calculated using NT=128 (12.5ms) points with 50% overlap between adjacent segments fs=10240
% For fs=4000 this is 50 points, with 25 points overlap
NT=round(12.5/1000*fs);
Overlap=round(NT*0.6); %for rounding purposes changed to 60%
total=floor((length(audio_data)-NT)/(NT-Overlap)+1);
D_o=zeros(1,total);
for k=0:(total-1)
    segment=audio_data(k*(NT-Overlap)+1:k*(NT-Overlap)+NT);
    H=log(var(diff(segment,1)))/(2*log(1/fs));
    if H==inf
        H=2;
    end
    D_o(k+1)=D_e-1+H;
end
D_o= resample(D_o, fs, fs/(NT-Overlap));
end



