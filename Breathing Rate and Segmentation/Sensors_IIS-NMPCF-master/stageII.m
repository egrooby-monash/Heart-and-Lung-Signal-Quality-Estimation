function [Xw] = stageII(fs,fwfmin,fwfmax,N,Xsabs)
%
%
% Objetive:  The main contribution of this stage is the development of a 
%            Wheezing/Normal breath sound separation based on a constrained 
%            tonal semi-supervised NMF approach using redundant information 
%            from the BOI obtained in the previous stage I.
%
% Input: 
% - fwfmin:     upper limit of BOI(Hz)
% - fwfmax:     lower limit of BOI (Hz)
% - Xabs:       Magnitude mixture spectrogram
% - N:          Hamming window sample length
% - fs:         Sample rate (Hz)
%
% Output: 
% - Xw:       Estimated wheezing spectrogram
%
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%%                     A tonal semi-supervised NMF
%--------------------------------------------------------------------------
% create dictionary Bw using the BOI
Rf = (fs/2)/size(Xsabs,1); % Hz
fr = fwfmin:Rf:fwfmax;
nfft=2*N; 
for ba = 1:length(fr)
ej = sin(2*pi*fr(ba)*(0:N-1)/fs);
vh = hamming(N).*ej';
vhf = abs(fft(vh,nfft));
vhfr = vhf(1:size(Xsabs,1));
Wtd(:,ba) = vhfr;
end
% Kullback Leibler (Normalization)
norm = sum(sum(Xsabs));
Xnorm = Xsabs/norm;
    
%--------------------------------------------------------------------------
%%                        Adding monophonic constraint
%--------------------------------------------------------------------------
X=Xnorm;
[F,T] = size(X);
%max_iter
max_iter = 100;
%beta
beta = 1.0;
%Wp
R = 80; 
rp = R;
Wp = rand(F,rp);
%Hp
Hp = rand(rp,T);
%Wh
Wh = Wtd;
rh = size(Wh,2);
%Hh
Hh = rand(rh,T);
%--------------------------------------------------------------------------
% Weight of the temporal monophonic constraint
wsp_hf0 = 0.02;
mon_e=(1/(rh*(rh-1)));
chf0 =wsp_hf0*mon_e;
% Normalization
%----------------------------------Wp y Hp
v = sqrt(sum(Wp.^2));
Wp = bsxfun(@rdivide,Wp,v);
v = sqrt(sum(Hp.^2,2));
Hp = bsxfun(@rdivide,Hp,v);
ep = ones(1,rp)/(rp); 
%----------------------------------Wh y Hh
v = sqrt(sum(Wh.^2));
Wh = bsxfun(@rdivide,Wh,v);
v = sqrt(sum(Hh.^2,2));
Hh = bsxfun(@rdivide,Hh,v);
eh = ones(1,rh)/(rh);
%--------------------------------------------------------------------------
% Normalization
Yn = [Wp*diag(ep) Wh*diag(eh)]*[Hp; Hh];
normaYn = sum(sum(Yn));
ep = ep/normaYn;
eh = eh/normaYn;
Yn = [Wp*diag(ep) Wh*diag(eh)]*[Hp; Hh];

%% Update equations
for i = 1:max_iter,
%--------------------------------------- Wp 
        % Update
        KL_num_bas1 = ((Yn.^(beta-2)).*X) * ((diag(ep)*Hp)');
        KL_den_bas1 = (Yn.^(beta-1)) * ((diag(ep)*Hp)');
        delta_wp=(KL_num_bas1)./(KL_den_bas1);
        delta_wp(isinf(delta_wp)) = 0;
        delta_wp(isnan(delta_wp)) = 0;
        Wp = Wp .* delta_wp;
        % Normalization
        v = sqrt(sum(Wp.^2));
        v(isinf(v)) = 1;
        v(isnan(v)) = 1;
        v((v==0))   = 1;
        Wp = bsxfun(@rdivide,Wp,v);
        Wp(isinf(Wp)) = 0;
        Wp(isnan(Wp)) = 0;
        ep = ep.*v;
        
        % Reconstruction
Yn = [Wp*diag(ep) Wh*diag(eh)]*[Hp; Hh];

%------------------------------------ Hp 
        % Update
        KL_num_act6 = ((Wp*diag(ep))') * ((Yn.^(beta-2)).*X); 
        KL_den_act6 = ((Wp*diag(ep))') * (Yn.^(beta-1));
        delta_hp=(KL_num_act6)./(KL_den_act6);
        delta_hp(isinf(delta_hp)) = 0;
        delta_hp(isnan(delta_hp)) = 0;                
        Hp = Hp .* delta_hp;
        % Normalization
        v = sqrt(sum(Hp.^2,2));
        v(isinf(v)) = 1;
        v(isnan(v)) = 1;
        v((v==0))   = 1;
        Hp = bsxfun(@rdivide,Hp,v);
        Hp(isinf(Hp)) = 0;
        Hp(isnan(Hp)) = 0;
        ep = ep.*(v');
%------------------------------------- Hh 
        % Update
        KL_num_act7 = ((Wh*diag(eh))') * ((Yn.^(beta-2)).*X); 
        KL_den_act7 = ((Wh*diag(eh))') * (Yn.^(beta-1));
        dnhf0 = (2 * Hh) ;
        dphf0 = 2 * ones(rh,rh) * Hh ;
        delta_hh=((KL_num_act7+(dnhf0*chf0))./(KL_den_act7+(dphf0*chf0)));
        delta_hh(isinf(delta_hh)) = 0;
        delta_hh(isnan(delta_hh)) = 0;                
        Hh = Hh .* delta_hh;
        % Normalization
        v = sqrt(sum(Hh.^2,2));
        v(isinf(v)) = 1;
        v(isnan(v)) = 1;
        v((v==0))   = 1;
        Hh = bsxfun(@rdivide,Hh,v);
        Hh(isinf(Hh)) = 0;
        Hh(isnan(Hh)) = 0;
        eh = eh.*(v');
    
% Reconstruction
        Yn = [Wp*diag(ep) Wh*diag(eh)]*[Hp; Hh];
 
%--------------------------------------------------------------------------
end
% Rename variables
Ws=Wh;
Wr=Wp;
es=eh;
er=ep;
Hs=Hh;
Hr=Hp;
Xs = (Ws*diag(es)*Hs);
Xr = (Wr*diag(er)*Hr);
Y = [Wr*diag(er) Ws*diag(es)]*[Hr; Hs];
Ypro = Xs.^2;
% spectral smoothing
Xw = medfilt2(Ypro, [3 3]);


