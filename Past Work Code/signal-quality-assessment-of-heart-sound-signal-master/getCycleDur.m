function dur=getCycleDur(x,fs)
% get cardiac cycle duration from auto corelation function
% input: x, auto corelation function of an envelope, single side
%           fs, sampling frequency

start_point=round(0.3*fs);
end_point=round(2*fs);

% get the maximum amplitude of the auto corelation 
[~, locs]=max(x(start_point:end_point));

dur=locs+start_point;

