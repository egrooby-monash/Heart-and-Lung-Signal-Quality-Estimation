function decision=newClassifyResults_ALL(fcoeff)
% v6 tylko ENT

    %progi dla 4 wybranych cech
    th1=0.8;
    th2=0.8;
    th4=0.6;
%     th6=0.8;

    % procent binow, w ktorych po stwierdzeniu przekroczenia progu dla
    % cechy stwierdza sie abnormal 
    p1=0.8;
    p2=0.7;
    p4=0.8;
%     p6=0.2;
    
%     thALL=[th1 th2 th3 th4 th5 th6];
    thALL=[th1 th2 th4];
%     pALL=repmat([p1 p2 p3 p4 p5 p6],size(abnormalCountPart,2),1);
    pALL=[p1 p2 p4];
%     pALL=[p1 p2 p3 p4 p5 p6];
    
    % liczba beatow w ktorych cechy przekroczyly prog
    abnormalCount=sum(abs(fcoeff)>=repmat(thALL,size(fcoeff,1),1));
    
    % procent beatow w sygnale, w ktorym przekroczony zostal prog
    decPART=sum(abnormalCount/length(fcoeff) >= pALL);

    
    if(sum(decPART)>0)
        decision=1;
    else 
        decision=-1;
    end
    