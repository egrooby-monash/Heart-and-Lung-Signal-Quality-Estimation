 function dur=getCycleDur_modified(x,max_HR,min_HR,fs)
%% Purpose
% get cardiac cycle duration from auto corelation function
%% Inputs
% x, auto corelation function of an envelope, single side
% fs, sampling frequency
% min_HR and max_HR= minimum and maximum heart rate range

%% Set the max and min search indices
        
start_point = round((60/max_HR)*fs);
end_point = round((60/min_HR)*fs); 

% get the maximum amplitude of the auto corelation 
[~, locs]=max(x(start_point:end_point));

dur=locs+start_point;

end