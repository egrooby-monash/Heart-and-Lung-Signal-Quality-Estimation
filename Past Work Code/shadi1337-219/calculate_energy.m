function [Es_nn]=calculate_energy(denoised_signal,Fs1,figures)

sig=denoised_signal;
X=denoised_signal;
Time = 0:1/Fs1:(length(X)/Fs1)-(1/Fs1);
seg = 0.02; %length (in sec) of analyzed segment - 20ms window
overlap = 0.01; %overlap of segments in seconds - 10ms overlap
N = Fs1*seg; %Number of samples per segment
Es = [0];
index = 1;
% sig = fhs_fin/max(fhs_fin);

for i=1:1:(2*(length(X)/N))-1
    xsq = sig(index:(index+N)-1).^2;
    for j = 0:1:N-1
        if (sig(index+j))~=0
            logxsq(j+1) = log10(xsq(j+1));
        else
            logxsq(j+1) = 0;
        end;
    end;
    mult = xsq'.*logxsq;
    somme = sum(mult);
    E = -1/N.*somme;
    index = index + floor(N/2);
    if i==1
        Es = E;
    else
        Es = [Es;E];
    end;
end;
if figures
    figure
T_es = seg-overlap; % T_es est la division de l'axe du temps (=10ms)
Es_n = Es - mean(Es); % Baisse le signal verticalement pour pouvoir trouver les zeros
Es_nn = Es_n/max(Es_n); % Normalized
Time2 = 0:1*T_es:(length(Es_n)-1)*T_es;
Time3 = 0:(length(Es_n)/length(sig))*T_es:(length(Es_n)-(length(Es_n)/length(sig)))*T_es;
figure,
plot(Time2,Es_nn,'r',Time3,sig,'g');
end 
end 