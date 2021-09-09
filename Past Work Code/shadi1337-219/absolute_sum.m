function [sum_matrix_mean]=absolute_sum(denoised_signal,a)

  sum1=0;
    sum2=0;
    sum3=0;
    sum4=0;
    sum5=0;
    sum6=0;
    sum7=0;
    sum8=0;
    sum9=0;
for i=1:size(a,1)
   
    beat=denoised_signal(a(i,1):a(i,5));
    [c,l]=wavedec(beat,10,'db2');
     d=detcoef(c,l,'db2',10);
      wt_d6=d{1,6};
      part=linspace(1,length(wt_d6),10);
  
for i=1:floor(part(2))
sum1=sum1+abs(wt_d6(i));
end
for i=floor(part(2)):floor(part(3))
sum2=sum2+abs(wt_d6(i));
end
for i=floor(part(3)):floor(part(4))
sum3=sum3+abs(wt_d6(i));
end
for i=floor(part(4)):floor(part(5))
sum4=sum4+abs(wt_d6(i));
end
for i=floor(part(5)):floor(part(6))
sum5=sum5+abs(wt_d6(i));
end
for i=floor(part(6)):floor(part(7))
sum6=sum6+abs(wt_d6(i));
end
for i=floor(part(7)):floor(part(8))
sum7=sum7+abs(wt_d6(i));
end
for i=floor(part(8)):floor(part(9))
sum8=sum8+abs(wt_d6(i));
end
for i=floor(part(9)):floor(part(10))
sum9=sum9+abs(wt_d6(i));
end

end
sum_matrix=[sum1,sum2,sum3,sum4,sum5,sum6,sum7,sum8,sum9];
 sum_matrix_mean=sum_matrix/size(a,1);
end