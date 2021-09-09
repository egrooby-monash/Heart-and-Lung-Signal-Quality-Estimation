function [Xrr, Xss] = nmpcf_weight(Xabs,Yabs,L,div_segf, Kw, Kr, alpha ,lamR_0, lamR_1, lamW, C)
%
%
% Objetive:  The purpose of this function is to add weight into the NMPCF 
%            decomposition. This allows to enhance the quality of the WS 
%            by removing the RS that implicitly appear in the human 
%            breathing process.   
%
% Input: 
% - Xabs:            magnitude spectrogram X of the input mixture signal
% - Yabs:            magnitude spectrogram Y of the respiratory training signal
% - L:               number of segments
% - div_segf:        vector that indicates the separation frames between segments
% - Kw:              number of wheezing components
% - Kr:              number of respiratory components
% - C:               Indicator to distinguish between non-wheezing (C=0) and wheezing segments (C=1)
% Weighting factors:
%           - alpha
%           - lamR_0
%           - lamR_1
%           - lamW
%
% Output: 
% - Xrr:              estimated respiratory spectrograms
% - Xss:              estimated wheezing spectrograms
%
%
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%%      Vectors that contain the weighing factors
%-------------------------------------------------------------------------- 
lam = ones(1,L+1).*lamR_1; 
lam(1)=alpha; 
lam(find(C==0)+1)=lamR_0;
lamW = ones(1,L+1).*lamW; 
lamW(find(C==1)+1)=0.05;
lamW(1)=eps;               
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%%    Normalization process
%--------------------------------------------------------------------------
norm = sum(sum(Xabs));
Xnorm = Xabs/norm;
[Fx,Tx] = size(Xnorm);
norm = sum(sum(Yabs));
Ynorm = Yabs/norm;
[Fy,Ty] = size(Ynorm);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Segmentation of the input spectrogram X (L-segments)
%--------------------------------------------------------------------------
X = cell(1,L+1);
% Setting the respiratory training matrix
X{1}=Ynorm;
% L-segments
for seg=1:L
    if seg<L
    X{seg+1}=Xnorm(:,div_segf(seg):div_segf(seg+1)-1);
    else
    X{seg+1}=Xnorm(:,div_segf(seg):end);   
    end
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Initialization of the basis (U) and activation (V) matrices
%--------------------------------------------------------------------------
Ur = rand(Fx,Kr); 
Vr = cell(1,L+1);
Us = cell(1,L+1);
Vs = cell(1,L+1);
for uv = 1:L+1
   if uv==1
      Vr{uv} = rand(Kr,Ty);
      Us{uv} = zeros(Fx,Kw)+eps;          
      Vs{uv} = zeros(Kw,Ty)+eps;
   else
      tamu = size(X{uv},2);
      Vr{uv} = rand(Kr,tamu);        
      Us{uv} = rand(Fx,Kw); 
      Vs{uv} = rand(Kw,tamu); 
   end
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%%   Normalization process
%--------------------------------------------------------------------------
er=cell(1,6);
es=cell(1,6);
err=cell(1,6);
ess=cell(1,6);
v = sqrt(sum(Ur.^2));
Ur = bsxfun(@rdivide,Ur,v);
for nor = 1:L+1
er{nor} = ones(1,Kr)/(Kr);
es{nor} = ones(1,Kw)/(Kw);
err{nor} = ones(1,Kr)/(Kr);
ess{nor} = ones(1,Kw)/(Kw);
    if nor==1
v = sqrt(sum(Vr{nor}.^2,2));
Vr{nor} = bsxfun(@rdivide,Vr{nor},v);      
    else
v = sqrt(sum(Vr{nor}.^2,2));
Vr{nor} = bsxfun(@rdivide,Vr{nor},v);
v = sqrt(sum(Us{nor}.^2));
Us{nor} = bsxfun(@rdivide,Us{nor},v);
v = sqrt(sum(Vs{nor}.^2,2));
Vs{nor} = bsxfun(@rdivide,Vs{nor},v);        
    end
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%%                     Updating process
%--------------------------------------------------------------------------
max_iter = 50;
B = 1;
% Initial reconstruction
Xn = cell(1,L+1);
for r=1:L+1
   Xn{r} = [Ur*diag(er{r}) Us{r}*diag(es{r})]*[diag(err{r})*Vr{r}; diag(ess{r})*Vs{r}];
   normaXn = (sum(sum(Xn{r}.^B)).^(1/B));
   er{r} = er{r}/normaXn;
   es{r} = es{r}/normaXn;
   err{r} = err{r}/normaXn;
   ess{r} = ess{r}/normaXn;
   Xn{r} = [Ur*diag(er{r}) Us{r}*diag(es{r})]*[diag(err{r})*Vr{r}; diag(ess{r})*Vs{r}];
end
%--------------------------------------------------------------------------
for i = 1:max_iter
    %----------------->Ur  
    for l=1:L+1
       dnUr(:,:,l)=lam(l)*((Xn{l}.^(B-2)).*X{l}) * ((diag(err{l})*Vr{l})');
       dpUr(:,:,l)=lam(l)*(Xn{l}.^(B-1)) * ((diag(err{l})*Vr{l})');
    end
    Ur   = Ur.*(sum(dnUr,3)./(sum(dpUr,3)+2*1*(L+1)*Ur));
        % Normalization
        v = sqrt(sum(Ur.^2));
        v(isinf(v)) = 1;
        v(isnan(v)) = 1;
        v((v==0))   = 1;
        Ur = bsxfun(@rdivide,Ur,v);
        Ur(isinf(Ur)) = 0;
        Ur(isnan(Ur)) = 0;
        for l=1:L+1
        er{l} = er{l}.*v;
        end
    
    %----------------->Us 
    for l=1:L+1
       dnUs = ((lamW(l))*((Xn{l}.^(B-2)).*X{l}) * ((diag(ess{l})*Vs{l})'));
       dpUs = ((lamW(l))*(Xn{l}.^(B-1)) * ((diag(ess{l})*Vs{l})'));
       Us{l} = Us{l}.*((dnUs)./((dpUs+2*1*Us{l})));clear dnUs dpUs
        % Normalization
        v = sqrt(sum(Us{l}.^2));
        v(isinf(v)) = 1;
        v(isnan(v)) = 1;
        v((v==0))   = 1;
        Us{l} = bsxfun(@rdivide,Us{l},v);
        Us{l}(isinf(Us{l})) = 0;
        Us{l}(isnan(Us{l})) = 0;
        es{l} = es{l}.*v;
    end
%--------------------------------------------------------------------------
    for r=1:L+1
   Xn{r} = [Ur*diag(er{r}) Us{r}*diag(es{r})]*[diag(err{r})*Vr{r}; diag(ess{r})*Vs{r}];
    end
%--------------------------------------------------------------------------    
    %----------------->Vr  
    for l=1:L+1
       dnVr = ((Ur*diag(er{l}))' * ((Xn{l}.^(B-2)).*X{l}));
       dpVr = ((Ur*diag(er{l}))' * ((Xn{l}.^(B-1))));
       Vr{l} = Vr{l}.*((dnVr)./(dpVr));clear dnVr dpVr;
        % Normalization
        v = sqrt(sum(Vr{l}.^2,2));
        v(isinf(v)) = 1;
        v(isnan(v)) = 1;
        v((v==0))   = 1;
        Vr{l} = bsxfun(@rdivide,Vr{l},v);
        Vr{l}(isinf(Vr{l})) = 0;
        Vr{l}(isnan(Vr{l})) = 0;
        err{l} = err{l}.*v';       
    end

    %----------------->Vs    
    for l=1:L+1
       dnVs = ((Us{l}*diag(es{l}))'  * ((Xn{l}.^(B-2)).*X{l}));
       dpVs = ((Us{l}*diag(es{l}))' * ((Xn{l}.^(B-1))));
       Vs{l} = Vs{l}.*((dnVs)./(dpVs));clear dnVs dpVs;
        % Normalization
        v = sqrt(sum(Vs{l}.^2,2));
        v(isinf(v)) = 1;
        v(isnan(v)) = 1;
        v((v==0))   = 1;
        Vs{l} = bsxfun(@rdivide,Vs{l},v);
        Vs{l}(isinf(Vs{l})) = 0;
        Vs{l}(isnan(Vs{l})) = 0;
        ess{l} = ess{l}.*v';  
    end
%--------------------------------------------------------------------------
    for r=1:L+1
   Xn{r} = [Ur*diag(er{r}) Us{r}*diag(es{r})]*[diag(err{r})*Vr{r}; diag(ess{r})*Vs{r}];
    end
%--------------------------------------------------------------------------
end
%% Final reconstruction
Xr=cell(1,L+1);
Xs=cell(1,L+1);
for s=2:L+1
  Xr{s} = X{s}.*((Ur*diag(er{s})*diag(err{s})*Vr{s})./((Ur*diag(er{s})*diag(err{s})*Vr{s})+(Us{s}*diag(es{s})*diag(ess{s})*Vs{s})));
  Xs{s} = X{s}.*((Us{s}*diag(es{s})*diag(ess{s})*Vs{s})./((Us{s}*diag(es{s})*diag(ess{s})*Vs{s})+(Ur*diag(er{s})*diag(err{s})*Vr{s})));
end
for s=2:L+1
    if s==2
        Xrr = Xr{s};
        Xss = Xs{s};
    else
        Xrr = [Xrr Xr{s}];
        Xss = [Xss Xs{s}];
    end
end
%--------------------------------------------------------------------------


