function g=fast_cfs(y, k,f1,f2,fs)
% cycle frequency spectrum by fast algorithm
% y : input signal 
% k : number of bins in cycle frequency domain
% f1 : left boundary of cycle frequency
% f2 : right boundary
% fs : sampling frequency
% g  : cycle frequency spectrum


w = exp(-j*2*pi*(f2-f1)/(k*fs));
a = exp(j*2*pi*f1/fs);

% x=y.^2;
x=sqrt((abs(hilbert(y))).^2);
x=x-mean(x);

[m, n] = size(x); oldm = m;
if m == 1, x = x(:); [m, n] = size(x); end

if nargin < 2, k = length(x); end
if nargin < 3, w = exp(-i .* 2 .* pi ./ k); end
if nargin < 4, a = 1; end

if any([size(k) size(w) size(a)]~=1),
	error(generatemsgid('InvalidDimensions'),'Inputs M, W and A must be scalars.')
end

nfft = 2^nextpow2(m+k-1);

kk = ( (-m+1):max(k-1,m-1) ).';
kk2 = (kk .^ 2) ./ 2;
ww = w .^ (kk2);   
nn = (0:(m-1))';
aa = a .^ ( -nn );
aa = aa.*ww(m+nn);
y = x .* aa(:,ones(1,n));

%------- FFT fast convolution.

fy = fft(  y, nfft );
fv = fft( 1 ./ ww(1:(k-1+m)), nfft );   % <-----linear chirp filtering.
fy = fy .* fv(:,ones(1, n));
g  = ifft( fy );

%------- multiply

g = g( m:(m+k-1), : ) .* ww( m:(m+k-1),ones(1, n) );

if oldm == 1, g = g.'; end
