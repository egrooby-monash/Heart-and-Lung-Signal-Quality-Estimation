%Funkcja odejmujaca od sygnalu ruchoma mediane. Jest to forma usuwania
%trendu z sygnalu. Podstawowa roznica w stosunku do ruchomej sredniej, to
%pozostawianie "waskich gorek" nietknietych, co w przypadku poszukiwania
%zalamkow R jest bardzo cenna cecha.


function [y]=movingMean(ECG,window) %pobiera surowe dane i szerokosc okna do oblicznia ruchomej mediany, a zwraca sygnal po jej odjeciu
   
        %[[1]] inicjalizacja wektora roboczego
              ECGtemp=zeros(size( ECG));
        %[[2]] Ze swej natury wektor ruchomej mediany jest krotszy od wektora dla ktorego jest wyliczany (-window+1). 
        %Dodajemy zera na poczatku i na koncu wektora danych, zeby
        %moc policzyc wektor ruchomej mediany o takiej samej dlugosci co
        %wejsciowy wektor danych.
        
              x=[zeros(floor(window*.5),1); ECG;zeros(floor(window*.5),1)];
              
        %[[3]] wyliczamy mediane
                 offset=(1:1:size(ECG)); %tworzymy wektor indeksow ECG
              id1=[0:window-1]'; %tworzymy wektor [0 1 2 ... window-1] - o dlugosci jednego okna 
              idx=bsxfun(@plus, id1, offset); %dzieki funkcji bsxfun powstaje tablica indeksow -  taka, ¿e w n-tej kolumnie znajduja sie kolejne probki z n-tego okna sygnalu
              wielkatablica=x(idx); %pobieramy wartosci dla indeksow sygnalu z tablicy

             
              ECGtemp=mean(wielkatablica, 1)'; % obliczamy mediane w kazdym oknie
        
        
        %[[4]] odejmujemy od surowych danych mediane i wstawiamy do wyniku
              y = ECG - ECGtemp;
  
end