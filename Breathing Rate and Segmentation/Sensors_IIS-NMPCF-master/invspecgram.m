function res = invspecgram(B,NFFT,Fs,WINDOW,NOVERLAP)
% res = invspecgram(B,NFFT,Fs,WINDOW,NOVERLAP)
% All parameters are like SPECGRAM.


if ((nargin<2)|isempty(NFFT))
  NFFT=256;
end
if ((nargin<3)|isempty(Fs))
  Fs=2;
end
if ((nargin<4)|isempty(WINDOW))
  WINDOW=hanning(NFFT);
end
if ((nargin<5)|isempty(NOVERLAP))
  NOVERLAP=length(WINDOW)/2;
end
if ((nargin<6)|isempty(NR))
  NR=0;
end

if length(NFFT)==1
[N,M] = size(B);
Next=NFFT-N;
ext=conj(B(Next+1:-1:2,:));

Bfull = [B;ext];
%[size(Bfull) NOVERLAP]
idft = real(ifft(Bfull));

WL=length(WINDOW);

idft=idft(1:WL,:);

W=repmat(WINDOW,1,M);

SPACING=WL-NOVERLAP;

IDFT=zeros(M*SPACING+NOVERLAP,1);
Wind=IDFT;

for m=1:M
	idx=( (m-1)*SPACING+(1:WL))';
	IDFT(idx)=IDFT(idx)+idft(:,m);
	Wind(idx)=Wind(idx)+W(:,m);
end
Wind(1:round(WL/2))=max(1,Wind(1:round(WL/2)));
Wind(end-round(WL/2):end)=max(1,Wind(end-round(WL/2):end));
res=IDFT./Wind;
else
end

  