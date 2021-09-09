function [yo,fo,to] = sg(x,nfft,Fs,WINDOW,noverlap)
% S = sg(B,NFFT,Fs,WINDOW,NOVERLAP)
% WINDOW must be created like WINDOW = hanning(Nsamples)
% All parameters like SPECGRAM

nx = length(x);
nwind = length(WINDOW);
if nx < nwind    % zero-pad x if it has length less than the window length
    x(nwind)=0;  nx=nwind;
end
x = x(:); % make a column vector for ease later
WINDOW = WINDOW(:); % be consistent with data set

ncol = fix((nx-noverlap)/(nwind-noverlap));
colindex = 1 + (0:(ncol-1))*(nwind-noverlap);
rowindex = (1:nwind)';
if length(x)<(nwind+colindex(ncol)-1)
    x(nwind+colindex(ncol)-1) = 0;   % zero-pad x
end
y = zeros(nwind,ncol);
y(:) = x(rowindex(:,ones(1,ncol))+colindex(ones(nwind,1),:)-1);
y = WINDOW(:,ones(1,ncol)).*y;

y = fft(y,nfft);
if ~any(any(imag(x)))    % x purely real
    if rem(nfft,2)   % nfft odd
        select = [1:(nfft+1)/2];
    else
        select = [1:nfft/2+1];
    end
    y = y(select,:);
else
    select = 1:nfft;
end
f = (select - 1)'*Fs/nfft;
t = (colindex-1)'/Fs;
if nargout == 1
    yo = y;
elseif nargout == 2
    yo = y;
    fo = f;
elseif nargout == 3
    yo = y;
    fo = f;
    to = t;
end


