function [fi_tot,GMM_parameters]=get_gmm(pxx,f)
%% Purpose
% get gaussian mixture model parameters
%% Inputs
% Pxx= power spectral density
% f= frequency
%% Outputs
% GMM_parameters= Gaussian mixture model paramters
%% Gaussian Mixture Model (GMM)
% -- Fitting Gaussians to the spectrum
fi = fit(f,pxx,'gauss4');
fi1=fi.a1*exp(-((f-fi.b1)./fi.c1).^2);
fi2=fi.a2*exp(-((f-fi.b2)./fi.c2).^2);
fi3=fi.a3*exp(-((f-fi.b3)./fi.c3).^2);
fi4=fi.a4*exp(-((f-fi.b4)./fi.c4).^2);
fi_tot=fi1+fi2+fi3+fi4;

% -- Gaussian parameters
a=[fi.a1, fi.a2, fi.a3, fi.a4];
b=[fi.b1, fi.b2, fi.b3, fi.b4];
c=[fi.c1, fi.c2, fi.c3, fi.c4];

GMM_parameters=[a, b, c];
end

