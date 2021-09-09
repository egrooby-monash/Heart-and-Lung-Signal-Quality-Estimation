% qufactorowy skrypt

% dane wejesciowe:
% A) sygna³ PCG
% B) wektor danych z podzia³em na fazy (segmentacja), czyli zmienn¹ assigned_states
% C) czestotliwosc probkowania

% przetwarzanie danych: 
% A) obliczenie transformaty fouriera dla kazdego cyklu, usrenienie ich i
% dopasowanie gaussa wraz z wyliczeniem qfactor

% dane wyjsciowe: 
% 1) qfactor - czestotliwosc piku glownego dzielona przez jego szerokosc
% 2) band - szerokosc piku glownego
% 3) ŒREDNIE moce w przedzia³ach x y (x_y) z konkretnej fazy. 


function [qfactorS1,qfactorS2, bandS1, bandS2, powS1_0_50, powS1_100_200, powSy_0_50, powSy_100_200, powS2_0_50, powS2_100_200, powDia_0_50, powDia_100_200] = qufaktoruj(PCG,A, Fs)
    %% 1. Normalizacja ze wzglêdu na zwracane œrednie moce. 
    PCG = PCG/(sum(PCG.^2));
    %% 2. Ka¿d¹ fazê transformujemy.
    for k = 1:4
        for g = 1:size(A,1)-1 %(bez ostatnich faz)
            if k == 4 % to po to, zeby sie zgadzalo
             s = PCG(A(g,k):A(g+1,1));
            else
            s = PCG(A(g,k):A(g,k+1));
            end
            ts = abs(fft(s)).^2;

            f = 0:Fs/length(s):Fs-Fs/length(s)'; %czestotliwosc pierwotna 
            %% 3. Ka¿d¹ transformate  dopróbkowaæ. (to pomo¿e przy uœrednianiu - punkty sie musza zgadzaæ) 
               % interpolacja na nowy wektor czestotliwosci 
               % valuenew = interp1(xold,valueold,xnew);
               ts =interp1(f,ts,0:1:Fs)';
                ts(isnan(ts))=0;%zabeznieczenie przed nanami
               %normalizacja  energii
               ts = ts/sum(ts);
              ts(isnan(ts))=0;%zabeznieczenie przed nanami
                % dopisanie do macierzy transformat
               Matrix(k,g,:) = ts; 
        end
    end
    %% 4. Ka¿d¹ transformatê dla danej fazy uœredniamy w sygnale. 
    % usrednienie macierzy transformat
    sr_matrix = squeeze(mean(Matrix,2));

    % teraz trzeba fitowac sr_matriks - wiersz 1 i 3
    % bierrzemy tylko polowe z transformaty, bo to przeciez odbicie
    % lustrzane
    %% 5. szukanie pików i wartoœci czêstotliwoœci w po³owie ich wysokoœci. 
    faza = 1; % wiersz 1
    sr_matrix = sr_matrix(:,1:floor(size(sr_matrix,2)/2)); % weŸ pol transformaty
    frq = linspace(0,Fs/2,length(sr_matrix));
    frqdodopasowania = linspace( -Fs/2,Fs/2, 4*length(sr_matrix));% sory, ale ten manewr pozwoli lepiej znalezc szerokosc dopasowania kiedy wybiega poza zero :( 
    [ sigma, mu ] =gaussfit( frq, sr_matrix(faza,:), 10, max(sr_matrix(faza,:)) ); %fit gausa ze stakcoverflow z prawami autorskimi jakimiœ niewiadomojakimi 
    dopas = 1/(sigma*sqrt(2*pi))*exp(-(frqdodopasowania-mu).^2/(2*sigma^2)); % oobliczenie dopasowania 
    
    
    [pikS1, indexpikuS1] = max(dopas); % szukam max
    % starodawny chiñski sposób na szukanie po³owy górki - 1 obni¿yæ górkê
    % o po³owê, wzi¹æ w bezwzglêdn¹ i z tego minimum - dzia³a! 
    [~, indekshalfs1_1] = min(abs(dopas(1:indexpikuS1)-pikS1/2)); % szukam pierwszej polowy 
    [~, indekshalfs1_2] = min(abs(dopas(indexpikuS1:end)-pikS1/2));
     indekshalfs1_2 = indekshalfs1_2 + indexpikuS1; 
            %testowe ogladanie 
%     plot(frq, sr_matrix(faza,:),'b');
%     hold on;
%     plot(frqdodopasowania, dopas ,'m');
%     plot(frqdodopasowania(indekshalfs1_1), dopas(indekshalfs1_1),'ro');
%     plot(frqdodopasowania(indekshalfs1_2), dopas(indekshalfs1_2),'ro');
%     plot(frqdodopasowania(indexpikuS1), dopas(indexpikuS1),'go');

    
    
    
    faza = 3; % wiersz 3 - faza s2
    sr_matrix = sr_matrix(:,1:floor(size(sr_matrix,2)/2)); % weŸ pol transformaty
    %wektory frq juz sa
    frq = linspace(0,Fs/2,length(sr_matrix));
    [ sigma, mu ] =gaussfit( frq, sr_matrix(faza,:), 10, max(sr_matrix(faza,:)) ); %fit gausa ze stakcoverflow z prawami autorskimi jakimiœ niewiadomojakimi 
    dopas = 1/(sigma*sqrt(2*pi))*exp(-(frqdodopasowania-mu).^2/(2*sigma^2)); % oobliczenie dopasowania 
    
    
    [pikS2, indexpikuS2] = max(dopas); % szukam max
    % starodawny chiñski sposób na szukanie po³owy górki - 1 obni¿yæ górkê
    % o po³owê, wzi¹æ w bezwzglêdn¹ i z tego minimum - dzia³a! 
    [~, indekshalfs2_1] = min(abs(dopas(1:indexpikuS2)-pikS2/2)); % szukam pierwszej polowy 
    [~, indekshalfs2_2] = min(abs(dopas(indexpikuS2:end)-pikS2/2));
    indekshalfs2_2 = indekshalfs2_2 + indexpikuS2; 
    
            %testowe ogladanie 
%     plot(frq, sr_matrix(faza,:));
%     hold on;
%     plot(frqdodopasowania, dopas);
%     plot(frqdodopasowania(indekshalfs2_1), dopas(indekshalfs2_1),'ro');
%     plot(frqdodopasowania(indekshalfs2_2), dopas(indekshalfs2_2),'ro');
%     plot(frqdodopasowania(indexpikuS2), dopas(indexpikuS2),'go');
    
    


%% liczenie cech zwracanych przez funkcjê 
    % liczenie cech 
    bandS1 = frqdodopasowania(indekshalfs1_2)-frqdodopasowania(indekshalfs1_1);
    qfactorS1 = frqdodopasowania(indexpikuS1)/bandS1;
    bandS2 = frqdodopasowania(indekshalfs2_2)-frqdodopasowania(indekshalfs2_1);
    qfactorS2 = frqdodopasowania(indexpikuS2)/bandS2;
    
    
    frq = linspace(0,Fs/2,length(sr_matrix));
    indx_0_50 = find(frq<50);
    indx_100_200 =  find(frq>100 & frq<200);
    
    powS1_0_50 = mean(sr_matrix(1,indx_0_50));
    powS1_100_200 = mean(sr_matrix(1,indx_100_200));
    powSy_0_50 = mean(sr_matrix(2,indx_0_50));
    powSy_100_200 = mean(sr_matrix(2,indx_100_200));
    powS2_0_50 = mean(sr_matrix(3,indx_0_50));
    powS2_100_200 = mean(sr_matrix(3,indx_100_200));
    powDia_0_50 = mean(sr_matrix(4,indx_0_50));
    powDia_100_200 =mean(sr_matrix(4,indx_100_200));
    
end


% %do testowania dzialania 
%   [PCG,Fs]=audioread(['C:\Users\jrosinski\Desktop\challange\training\training-a\a0001.wav']); %PCG = PCG(1:5000); %do testow 
%   
%   [assigned_states] =dlmread(['C:\Users\jrosinski\Desktop\challange\ann_ALL\a0001_annotation.txt']);
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
% 
% % PLOTING MODULE HHGGWWJHA 
% % plot(PCG)
% %     hold on
% %     plot(gaussPCG,'r')
% %     plot(poissonPCG,'g')
% 
