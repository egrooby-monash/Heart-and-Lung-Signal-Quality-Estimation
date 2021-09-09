function Ma=getMaxAxcorCoef(x,fs)
% get maximum coeffcient after 0.3 seconds
% input: x, auto corelation function, single side
%           fs,sampling frequency

start_point=round(0.3*fs);
end_point=round(2*fs);

% get the maximum amplitude of the auto corelation 
Ma=max(x(start_point:end_point));
