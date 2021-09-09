% Faklowy skrypt

% dane wejesciowe:
% A) sygna³ PCG
% B) wektor danych z podzia³em na fazy (segmentacja), czyli zmienn¹ assigned_states

% przetwarzanie danych: 
% A) obliczenie transformaty falkowej z jadrem Daubechies-2

% dane wyjsciowe: 
% 1) œrednia wartoœæ wspó³czynników transformaty dla fazy S1
% 2) dla fazy systole
% 3) dla fazy S2
% 4) dla fazy diastole.

function [meanCoefS1, meanCoefSystole, meanCoefS2, meanCoefDiastole, PCG_Hi_Hi] = falkowyFeature(PCG,assigned_states)
%% We just assume that the assigned_states cover at least 2 whole heart beat cycle
indx = find(abs(diff(assigned_states))>0); % find the locations with changed states
% PCGfiltered=movingMean(PCG,6);

% figure(222)
% hold on;
% plot(PCGfiltered-0.1, 'r-');
% plot(PCG,'b-');
% hold off;
% pause

if assigned_states(1)>0   % for some recordings, there are state zeros at the beginning of assigned_states
    switch assigned_states(1)
        case 4
            K=1;
        case 3
            K=2;
        case 2
            K=3;
        case 1
            K=4;
    end
else
    switch assigned_states(indx(1)+1)
        case 4
            K=1;
        case 3
            K=2;
        case 2
            K=3;
        case 1
            K=0;
    end
    K=K+1;
end

indx2                = indx(K:end);
rem                  = mod(length(indx2),4);
indx2(end-rem+1:end) = [];
A                    = reshape(indx2,4,length(indx2)/4)'; % A is N*4 matrix, the 4 columns save the beginnings of S1, systole, S2 and diastole in the same heart cycle respectively



PCG = butterworth_high_pass_filter(PCG,2,20,1000);
    % normalizacja do odchylen standardowych
%     PCG = PCG / std(PCG) ; 
    % poczatek transformaty falkowej
    falka = dbwavf('db2');
    falkaODW =-( (-1).^(1:length(falka)) ).*falka;
    % [PCG,Fs]=audioread(['a0001' '.wav']); %PCG = PCG(1:5000); %do testow 
    PCG_Lo = conv(PCG,falka); 
    PCG_Hi = conv(PCG,falkaODW); %wsp pierwszego rzedu 
    %  test 
%     plot(PCG)
%     hold on
%     plot(PCG_Lo,'r')
%     plot(PCG_Hi,'g')
    %test
    % odciac koncowke 
    PCG_Lo = PCG_Lo(1:end-length(falka)+1);
    % downlample
    PCG_Lo = PCG_Lo(1:2:end);
    % PCG 
%     PCG_Hi_Lo = conv(PCG_Lo(1:end-length(falka)+1),falka);
    PCG_Hi_Hi = conv(PCG_Lo(1:end-length(falka)+1),falkaODW); % to sá wspolczynniki 2 rzedu
    PCG_Hi_Hi = PCG_Hi_Hi(1:end-length(falka)+1);% pozbywamy sie oednowych wyrazow ze splotu
%     PCG_Hi_Hi=PCG_Hi_Hi/max(abs(PCG_Hi_Hi));

%     plot(PCG_Hi_Hi,'g')
%     hold on;
% %     plot(PCG_Hi_Lo,'r')
%     plot(PCG(1:2:end))
    %teraz trzeba wziac wartosci coef z PCG_Hi_Lo o odpowiadajacym im fazom
    % wazne ze teraz te coef sa downsamplowane - czyli indeksy z assigned
    % states trzeba / 2 i floor (tu ceil, zeby uniknac zera w wypadku jedynki) z tego. 
    A = ceil(A/2);
    % biore srednia moc wspolczynnikow drugiego rzedu (zgodnie z publikacja
    % Michai³a Mateuszova - mimo iz oni pisza ze te sa znaczace dla dzielenia na 3
    % grupy, a nie dwie jak u nas). 
    tempS1 = [];
    tempSystole = [];
    tempS2 = [];
    tempDiastole = [];
    for i = 1:size(A,1)-1 % odejmuje jeden, zeby sie faza diastole ostatnia policzyla bez problemu
        tempS1 = [tempS1; PCG_Hi_Hi(A(i,1):A(i,2)).^2];
        tempSystole = [tempSystole; PCG_Hi_Hi(A(i,2):A(i,3)).^2];
        tempS2 = [tempS2; PCG_Hi_Hi(A(i,3):A(i,4)).^2];
        tempDiastole = [tempDiastole; PCG_Hi_Hi(A(i,4):A(i+1,1)).^2]; %kombinacja z jedynka ma zalatwic zawijanie czwartej kolumny z pierwsza
    end
    meanCoefS1 = mean(tempS1);
    meanCoefSystole = mean(tempSystole);
    meanCoefS2 = mean(tempS2);
    meanCoefDiastole = mean(tempDiastole);
    
    PCG_Hi_Hi = interp(PCG_Hi_Hi,2);
    
end


% to tylko do testow - nie czytac! 

% [assigned_states] =dlmread(['a0001' '_annotation.txt']);
% 
% indx = find(abs(diff(assigned_states))>0); % find the locations with changed states
% 
% if assigned_states(1)>0   % for some recordings, there are state zeros at the beginning of assigned_states
%     switch assigned_states(1)
%         case 4
%             K=1;
%         case 3
%             K=2;
%         case 2
%             K=3;
%         case 1
%             K=4;
%     end
% else
%     switch assigned_states(indx(1)+1)
%         case 4
%             K=1;
%         case 3
%             K=2;
%         case 2
%             K=3;
%         case 1
%             K=0;
%     end
%     K=K+1;
% end
% 
% indx2                = indx(K:end);
% rem                  = mod(length(indx2),4);
% indx2(end-rem+1:end) = [];
% A                    = reshape(indx2,4,length(indx2)/4)'; % A is N*4 matrix, the 4 columns save the beginnings of S1, systole, S2 and diastole in the same heart cycle respectively
% 
