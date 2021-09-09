function [pxx_mean, band_mean, PR_mean, f, p25_section, p75_section]=power_ratio_band( pass_band, fn, pure_sections, band_width)
%POWER RATIO:  Calculate the power ratio of NCS/CS (depending on flag_section) of a signal

%% INPUTS AND OUTPUTS
%  -- Inputs --
% xss: Signal without treatment on CS/NCS
% signal_n: Number of the signal
% fn: Sampling frequency
% window: Window used for labelling
% overlap: Overlap used for labelling
% label_final: Annotated labels of the signal bank
% flag_section: 1=CS; 0=NCS
% -- Outputs --

%% INITIALISATION
pxx_section=[]; % Stores the periodogram of every NCS/CS of a signal
p25_section=[]; % Stores the first interquartile of every NCS/CS of a signal
p75_section=[]; % Stores the third interquartile of every NCS/CS of a signal

for s=1: size(pure_sections,1)
    section=pure_sections(s, :);
    
    %% WELCH PERIODOGRAM
    [pxx,f] = Welch_periodogram(section, fn, pass_band); % Welch Periodogram of the section
    pxx_section=[pxx, pxx_section];
    
    %% p25
    p25=percentilefreq(pxx((f~=0)),f(f~=0),25);
    p25_section=[p25, p25_section];
    
    %%  P75
    p75=percentilefreq(pxx((f~=0)),f(f~=0),75);
    p75_section=[p75, p75_section];
    
    %% POWER RATIO for each band
    % -- Parameters
    f_interval=length(f)*band_width/(pass_band(end)-pass_band(1)); % Interval of frequencies in the vector f
    end_band=length(f);
    band_mean_section=[]; % Means of the periodogram in the frequency bands
    
    % For each frequency band
    for n_band = 1 : length(f)/f_interval
        start_band=end_band-(floor(f_interval)); % Beginning of the band
        pxx_band=pxx(start_band:end_band); % Periodogram in the band
        band_mean_section=[ band_mean_section, mean(pxx_band)]; % Mean of this periodogram
        end_band=start_band; % End of the band
    end
    
    band_mean_signal(s,:)=band_mean_section; % Periodogram means in each frequency bands, for each section NCS/CS of a signal. Matrix shaped like this: (section, frequency bands)
    PR=band_mean_signal/sum(pxx); % Power ratio in each frequency bands, for each section NCS/CS of a signal
    
end

%% OUTPUTS
band_mean=band_mean_signal; % For a signal, mean of the means of frequency bands periodogram, for all NCS/CS sections
pxx_mean=pxx_section'; % For a signal, mean of the periodograms of all NCS/CS sections
PR_mean=PR; % For a signal, mean of power ratios of all NCS/CS sections

end


