function [e,se,A,B]=sampen(y,M,r,sflag,cflag,vflag)
%function e=sampen(y,M,r);
%
%Input Parameters
%
%y  input signal vector
%M  maximum template length (default M=5)
%r  matching threshold (default r=.2)
%
%Output Parameters
%
%e sample entropy estimates for m=0,1,...,M-1
%
%Full usage:
%
%[e,se,A,B]=sampen(y,m,r,sflag,cflag,vflag)
%
%Input Parameters
%
%sflag    flag to standardize signal(default yes/sflag=1) 
%cflag    flag to use fast C code (default yes/cflag=1) 
%vflag    flag to calculate standard errors (default no/vflag=0) 
%
%Output Parameters
%
%se standard error estimates for m=0,1,...,M-1
%A number of matches for m=1,...,M
%B number of matches for m=0,...,M-1
%  (excluding last point in Matlab version)

if ~exist('M')|isempty(M),M=5;end
if ~exist('r')|isempty(r),r=.2;end
if ~exist('sflag')|isempty(sflag),sflag=1;end
if ~exist('cflag')|isempty(cflag),cflag=1;end
if ~exist('vflag')|isempty(cflag),vflag=0;end
y=y(:);
n=length(y);
if sflag>0
   y=y-mean(y);
   s=sqrt(mean(y.^2));   
   y=y/s;
end
if nargout>1
    if vflag>0
        se=sampense(y,M,r);
    else
        se=[];
    end
end    
if cflag>0
   [match,R]=cmatches(y,n,r);
   match=double(match);
else
    try
   [e,A,B]=sampenc_mex(y,M,r);
    catch
        [e,A,B]=sampenc(y,M,r);
    end
   return
end
k=length(match);
if k<M
   match((k+1):M)=0;
end
N=n*(n-1)/2;
A=match(1:M);
B=[N;A(1:(M-1))];
N=n*(n-1)/2;
p=A./B;
e=-log(p);
