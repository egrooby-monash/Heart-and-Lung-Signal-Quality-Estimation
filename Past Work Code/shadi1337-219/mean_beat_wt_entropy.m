function [entropy_matrix]=mean_beat_wt_entropy(denoised_signal,a)

for i=1:size(a,1)
   
    beat=denoised_signal(a(i,1):a(i,5));
    
    [c,l]=wavedec(beat,10,'db2');
    a_10=appcoef(c,l,'db2',10);
    E_a_10=wentropy( a_10,'shannon');
    matrix_E_a_10(i)=E_a_10;
    d=detcoef(c,l,'db2',10);
    E_d_10=wentropy( d{1,10},'shannon');
    matrix_E_d_10(i)=E_d_10;
%     d_9=detcoef(c,l,'db2',9);
    E_d_9=wentropy(d{1,9},'shannon');
    matrix_E_d_9(i)=E_d_9;
%     d_8=detcoef(c,l,'db2',8);
    E_d_8=wentropy( d{1,8},'shannon');
    matrix_E_d_8(i)=E_d_8;
%     d_7=detcoef(c,l,'db2',7);
    E_d_7=wentropy( d{1,7},'shannon');
    matrix_E_d_7(i)=E_d_7;
%     d_6=detcoef(c,l,'db2',6);
    E_d_6=wentropy( d{1,6},'shannon');
    matrix_E_d_6(i)=E_d_6;
%     d_5=detcoef(c,l,'db2',5);
    E_d_5=wentropy( d{1,5},'shannon');
    matrix_E_d_5(i)=E_d_5;
%     d_4=detcoef(c,l,'db2',4);
    E_d_4=wentropy( d{1,4},'shannon');
    matrix_E_d_4(i)=E_d_4;
%     d_3=detcoef(c,l,'db2',3);
    E_d_3=wentropy(d{1,3},'shannon');
    matrix_E_d_3(i)=E_d_3;
%     d_2=detcoef(c,l,'db2',2);
    E_d_2=wentropy( d{1,2},'shannon');
    matrix_E_d_2(i)=E_d_2;
%     d_1=detcoef(c,l,'db2',1);
    E_d_1=wentropy( d{1,1},'shannon');
    matrix_E_d_1(i)=E_d_1;
    
end


entropy_matrix=[mean(matrix_E_d_1),mean(matrix_E_d_2),mean(matrix_E_d_3),mean(matrix_E_d_4),...
    mean(matrix_E_d_5),mean(matrix_E_d_6),mean(matrix_E_d_7),mean(matrix_E_d_8),mean(matrix_E_d_9),...
    mean(matrix_E_d_10),mean(matrix_E_a_10)];

    


end