function std_QT = stdQT(A)
%STDQT Summary of this function goes here
%   Detailed explanation goes here

S1=A(:,2)-A(:,1); %length of S1
sys=A(:,3)-A(:,2); %length of systole
S2=A(:,4)-A(:,3); % length of S2

QT=S1+sys+S2; %length of QT
std_QT=std(QT); %SD value of QT
%mean_QT=mean(QT); %mean value of QT

end

