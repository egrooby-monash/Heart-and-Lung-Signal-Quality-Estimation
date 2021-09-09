function [Pfb1, Pfb2, Pfb3, Pfb4, Pfb5, Pfb6, Pfb7, Pfb8, Pfb9, Pfb10] = get_spectral_composition(PSD,F)
%% Paper information 
% Heart sound anomaly and quality detection using ensemble of neural networks without segmentation
% https://ieeexplore.ieee.org/document/7868817
%% INPUT:
% x:Raw data
%
%% OUTPUT:
% Pfb8, Pfb9, Pfb10: 3 features extracted from frequency domain
%
%% Contact:
% Morteza Zabihi (morteza.zabihi@gmail.com) && Ali Bahrami Rad(abahramir@yahoo.com)
% Black Swan Team (April 2016)
% This code is released under the MIT License (MIT) (http://opensource.org/licenses/MIT)
%
%% Method
F=F/max(F);
fb1 =  [0 0.1];
fb2 =  [0.1 0.2];
fb3 =  [0.2 0.3];
fb4 =  [0.3 0.4];
fb5 =  [0.4 0.5];
fb6 =  [0.5 0.6];
fb7 =  [0.6 0.7];
fb8 =  [0.7 0.8];
fb9 =  [0.8 0.9];
fb10 = [0.9 1];
% find the indexes corresponding bands 
ifb1 = (F>=fb1(1)) & (F<=fb1(2));
ifb2 = (F>=fb2(1)) & (F<=fb2(2));
ifb3 = (F>=fb3(1)) & (F<=fb3(2));
ifb4 = (F>=fb4(1)) & (F<=fb4(2));
ifb5 = (F>=fb5(1)) & (F<=fb5(2));
ifb6 = (F>=fb6(1)) & (F<=fb6(2)); 
ifb7 = (F>=fb7(1)) & (F<=fb7(2));

ifb8 =  (F>=fb8(1))  & (F<=fb8(2));
ifb9 =  (F>=fb9(1))  & (F<=fb9(2));
ifb10 = (F>=fb10(1)) & (F<=fb10(2));

%calculate areas, within the freq bands (ms^2) 
Ifb1 = trapz(F(ifb1),PSD(ifb1));
Ifb2 = trapz(F(ifb2),PSD(ifb2));
Ifb3 = trapz(F(ifb3),PSD(ifb3));
Ifb4 = trapz(F(ifb4),PSD(ifb4));
Ifb5 = trapz(F(ifb5),PSD(ifb5));
Ifb6 = trapz(F(ifb6),PSD(ifb6));
Ifb7 = trapz(F(ifb7),PSD(ifb7));

Ifb8  = trapz(F(ifb8),PSD(ifb8));
Ifb9  = trapz(F(ifb9),PSD(ifb9));
Ifb10 = trapz(F(ifb10),PSD(ifb10));

aTotal = Ifb1+Ifb2+Ifb3+Ifb4+Ifb5+Ifb6+Ifb7+Ifb8+Ifb9+Ifb10;
% calculate areas relative to the total area (%)
Pfb1 =(Ifb1/aTotal)*100;
Pfb2 =(Ifb2/aTotal)*100;
Pfb3 =(Ifb3/aTotal)*100; 
Pfb4 =(Ifb4/aTotal)*100;
Pfb5 =(Ifb5/aTotal)*100;
Pfb6 =(Ifb6/aTotal)*100;
Pfb7 =(Ifb7/aTotal)*100;
Pfb8 =(Ifb8/aTotal)*100;
Pfb9 =(Ifb9/aTotal)*100;
Pfb10 =(Ifb10/aTotal)*100;
end
