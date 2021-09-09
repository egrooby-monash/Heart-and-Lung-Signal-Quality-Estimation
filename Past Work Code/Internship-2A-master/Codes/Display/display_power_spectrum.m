function [] = display_power_spectrum( P1, P2, ff )
% display_power_spectrum: Display power spectrum with its deviation (p25 and p75)

errtyp=1; 

%% Plot the results

%%% Power median and confidence interval:
Pav1=median(P1,2);
Pav2=median(P2,2);

if errtyp==0
    dev1=std(P1,0,2);
    dev2=std(P2,0,2);
elseif errtyp==1
    dev1=[prctile(P1',75)'-Pav1 Pav1-prctile(P1',25)'];
    dev2=[prctile(P2',75)'-Pav2 Pav2-prctile(P2',25)'];
elseif errtyp==2
    dev1=signerr(P1',0);
    dev2=signerr(P2',0);
end


% figure; 
% shadedErrorBar(ff,Pav1',dev1','lineprops','-b','transparent',1);
% hold on
% shadedErrorBar(ff,Pav2',dev2','lineprops','-r','transparent',1);
% hold off
% title('Power Spectrum');
% legend('CS', 'NCS')
% xlabel('Frequency [Hz}'); ylabel('Power [db]')

%%% log of median:

%%% median of logs:
P1=10*log10(P1);
P2=10*log10(P2);

Pav1=median(P1,2);
Pav2=median(P2,2);

if errtyp==0
    dev1=std(P1,0,2);
    dev2=std(P2,0,2);
elseif errtyp==1
    dev1=[prctile(Pav1',75)'-Pav1 Pav1-prctile(P1',25)'];
    dev2=[prctile(Pav2',75)'-Pav2 Pav2-prctile(P2',25)'];
elseif errtyp==2
    dev1=signerr(P1',0);
    dev2=signerr(P2',0);
end

figure; 
plot(ff,Pav1, 'Color', 'r'); hold on
plot(ff , dev1, 'LineStyle', '--', 'Color', 'r'); % std


plot(ff,Pav2, 'Color', 'b');
plot(ff , dev2, 'LineStyle', '--', 'Color', 'b'); % std
hold off

title('Logarithm of Average Power Spectrum');
legend('CS', 'NCS')
xlabel('Frequency [Hz]'); ylabel('Power [db]')


%%% median of logs:
P1=10*log10(P1);
P2=10*log10(P2);

Pav1=median(P1,2);
Pav2=median(P2,2);

if errtyp==0
    dev1=std(P1,0,2);
    dev2=std(P2,0,2);
elseif errtyp==1
    dev1=[prctile(P1',75)'-Pav1 Pav1-prctile(P1',25)'];
    dev2=[prctile(P2',75)'-Pav2 Pav2-prctile(P2',25)'];
elseif errtyp==2
    dev1=signerr(P1',0);
    dev2=signerr(P2',0);
end


figure; 
shadedErrorBar(ff,Pav1',dev1','lineprops','-b','transparent',1);
hold on
shadedErrorBar(ff,Pav2',dev2','lineprops','-r','transparent',1);
hold off
title('Power Spectrum');
legend('pre term', 'full term')
xlabel('frequency (Hz)'); ylabel('Power (db)')

end

