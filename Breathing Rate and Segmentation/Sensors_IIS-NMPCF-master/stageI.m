function [fwfmin,fwfmax,bmin,bmax] = stageI(Xabs,Xang,N,S,fs)
%
% Objetive:  The goal of this stage is to estimate the spectral interval, 
%            defined as band of interest (BOI), in which the probability 
%            to find wheeze sounds is maximum.
%
% Input: 
% - Xabs:       Magnitude mixture spectrogram
% - Xang:       Phase mixture spectrogram
% - N:          Hamming window sample length
% - S:          Overlap (between 0 and 1)
% - fs:         Sample rate (Hz)
%
% Output: 
% - fwfmin:     upper limit of BOI(Hz)
% - fwfmax:     lower limit of BOI (Hz)
% - bmin:       lower limit of BOI (bins)
% - bmax:       upper limit of BOI (bins)
%
%
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%%                      Relevant parameters
Hop_samples=round(S*N); 
window=hamming(N); 
noverlap=N-Hop_samples; 
nfft=2*N;
nf=size(Xabs,1); 
nt=size(Xabs,2);
Yinput = Xabs;
R=80;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Kullback Leibler (Normalization)
normaYn = sum(sum(Xabs));
Xnorm = Xabs/normaYn;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%%        Step I: Factorization of the basis matrix applying NMF
%--------------------------------------------------------------------------
X=Xnorm;
rh=R;
[F,T] = size(X);
%max_iter
max_iter = 100;
%W
W = rand(F,rh);
%H
H = rand(rh,T);
%----------------------------------W y H
v = sqrt(sum(W.^2));
W = bsxfun(@rdivide,W,v);
v = sqrt(sum(H.^2,2));
H = bsxfun(@rdivide,H,v);
e = ones(1,rh)/(rh);
%--------------------------------------------------------------------------
% Normalizations
Yn = W*diag(e)*H;
normaYn = sum(sum(Yn));
e = e/normaYn;
Yn = W*diag(e)*H;
% Update equations
for i = 1:max_iter,
        beta = 1;
%----------------------------------- basis matrix (W) 
        % Update
        KL_num_bas2 = ((Yn.^(beta-2)).*X) * ((diag(e)*H)');
        KL_den_bas2 = (Yn.^(beta-1)) * ((diag(e)*H)');
        delta_w=(KL_num_bas2)./(KL_den_bas2);
        delta_w(isinf(delta_w)) = 0;
        delta_w(isnan(delta_w)) = 0;                
        W = W .* delta_w;
        % Normalization
        v = sqrt(sum(W.^2));
        v(isinf(v)) = 1;
        v(isnan(v)) = 1;
        v((v==0))   = 1;
        W = bsxfun(@rdivide,W,v);
        W(isinf(W)) = 0;
        W(isnan(W)) = 0;
        e = e.*v;
    
        % Reconstruction
Yn = W*diag(e)*H;

%------------------------------------- activation matrix (H)
        % Update
        KL_num_act7 = ((W*diag(e))') * ((Yn.^(beta-2)).*X);
        KL_den_act7 = ((W*diag(e))') * (Yn.^(beta-1));
        delta_h=(KL_num_act7)./(KL_den_act7);
        delta_h(isinf(delta_h)) = 0;
        delta_h(isnan(delta_h)) = 0;                
        H = H .* delta_h;
        % Normalization
        v = sqrt(sum(H.^2,2));
        v(isinf(v)) = 1;
        v(isnan(v)) = 1;
        v((v==0))   = 1;
        H = bsxfun(@rdivide,H,v);
        H(isinf(H)) = 0;
        H(isnan(H)) = 0;
        e = e.*(v');
    
% Reconstruction
        Yn = W*diag(e)*H;
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%%         Step II: Clustering of bases based on the tonality principle
%--------------------------------------------------------------------------
Y = (W*diag(e)*H); Y =Y.*normaYn; y = invspecgram((Y).*exp(j*Xang),nfft,fs,window,noverlap);
L = length(xcorr(y));
cor = zeros(R,L);
dep = zeros(R,L);
for base=1:R
    Wb = zeros(nf,R);
    Hb = zeros(R,nt);
    eb = zeros(1,R);
    Wb(:,base) = W(:,base);
    Hb(base,:) = H(base,:);
    eb(1,base) = e(1,base);
    Yb(:,:,base) = (Wb*diag(eb)*Hb);
    Yb(:,:,base) =Yb(:,:,base).*normaYn;
    yb(:,base) = invspecgram((Yb(:,:,base)).*exp(j*Xang),nfft,fs,window,noverlap);
    % Correlation 
    cor(base,:) = xcorr(yb(:,base));
    % Power Spectral Density 
    dep(base,:) = abs(fft(cor(base,:)))/L;
end
densidad = dep(:,1:L/2+1);
for i=1:R
    SPE(i)=wentropy(densidad(i,:),'shannon');
end
% Selection of the wheezing basis
SPEw = find(SPE > median(SPE));
SPEr = find(SPE < median(SPE));
Ww=W;
Hw=H;
ew=e;
Ww(:,SPEr) = 0;
Hw(SPEr,:) = 0;
ew(1,SPEr) = 0;
Yw = Ww*diag(ew)*Hw;
Yw =Yw.*normaYn;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%%     Step III: Using energy distortion to select the spectral BOI
%--------------------------------------------------------------------------
difY =sqrt(sum(Yinput,2) - sum(Yw,2)); %diff o sqrt(diff)
Ywd = sum(Yw,2)./difY;
%Smoothing
Wind = 2;
densmooth=zeros(1,length(Ywd));
for i=1:length(Ywd)
    if i-floor(Wind)<1
        ini=1;
    else
        ini=i-floor(Wind);
    end
    
    if i+floor(Wind*2)>length(Ywd)
        fin=length(Ywd);
    else
        fin=i+floor(Wind);
    end
   densmooth(1,i)=median(Ywd(ini:fin,1));
end

% Location of spectral peaks
%Bins
[pks,locs,w,p] = findpeaks(densmooth,'MinPeakProminence',0.6*max(densmooth),'Annotate','extents');
fw = locs;
widths = w;
% Bandwith
Nbands = length(locs);
for band = 1:Nbands
    % Band limits
    Af(band) = ceil(widths(band)/2);
    fwmin(band) = fw(band) - Af(band);
    fwmax(band) = fw(band) + Af(band);
    Yba(:,:,band) = Yw;
    Yba(1:fwmin(band),:,band) = 0;
    Yba(fwmax(band):end,:,band) = 0;
    Yzcr =Yba.*normaYn;
    yzcr = invspecgram((Yzcr(:,:,band)).*exp(j*Xang),nfft,fs,window,noverlap);
    % Zero-crossing rate
    ZCR(band)=mean(abs(diff(sign(yzcr))));  
 end
% Identification of the band by Zero-Crossing-Rate.
[value, posi] = min(ZCR);
%Hz
[pksf,locsf,wf,pf] = findpeaks(densmooth,(0:nf-1)*(fs/2)/size(Yw,1),'MinPeakProminence',0.6*max(densmooth),'Annotate','extents');
fwf = locsf(posi);
widthsf = wf(posi);
Margf = 60; %Hz
Aff = ceil(widthsf/2) + Margf;
fwfmin = fwf - Aff;
fwfmax = fwf + Aff;
%Bins
bmin = round(fwfmin/((fs/2)/size(Yinput,1)));
bmax = round(fwfmax/((fs/2)/size(Yinput,1)));

