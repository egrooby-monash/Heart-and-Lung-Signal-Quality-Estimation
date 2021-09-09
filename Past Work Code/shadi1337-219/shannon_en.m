%% Calculate Shannon Energy LFHS (low freq heart sound)
 function[shannon_matrix]=shannon_en(denoised_signal,A)


j=1;
%% finding separate cycles

% cycle=cell(size(A,1),1);
% for i=1:size(A,1)
% cycle{j,1}=denoised_signal(A(i,1):A(i+1,1));
% 
% j=j+1
% if j==size(A,1)
%     break 
% end
% 
% end
%% finding 9 places
for i=1:size(A,1)
    start_s1{j,1}=A(i,1);
    end_s1{j,1}=A(i,2);
    start_s2{j,1}=A(i,3);
    end_s2{j,1}=A(i,4);
    sys1{j,1}=A(i,2)+( 1/4 * (A(i,3)-A(i,2)));
    sys2{j,1}=A(i,2)+( 1/2 * (A(i,3)-A(i,2)));
    sys3{j,1}=A(i,2)+( 3/4 * (A(i,3)-A(i,2)));
    [~,peak_s1]=max(denoised_signal(A(i,1):A(i,2)));
    peak_s1=peak_s1+A(i,1);
    peak_s1_f(j,1)=peak_s1;
     [~,peak_s2]=max(denoised_signal(A(i,3):A(i,4)));
    peak_s2=peak_s2+A(i,3);
peak_s2_f(j,1)=peak_s2;


    
    
j=j+1;
end
j=1;
for i=1:size(A,1)
    x1=denoised_signal(start_s1{i,1});
    x2=denoised_signal(start_s2{i,1});
    x3=denoised_signal(end_s1{i,1});
    x4=denoised_signal(end_s2{i,1});
    x5=denoised_signal(peak_s1_f(i,1));
    x6=denoised_signal(peak_s2_f(i,1));
    x7=denoised_signal(sys1{i,1});
    x8=denoised_signal(sys2{i,1});
    x9=denoised_signal(sys3{i,1});
    
start_s1_e=norm(x1)^2*log10(norm(x1)^2);
start_s1_e_f(j,1)=start_s1_e;

start_s2_e=norm(x2)^2*log10(norm(x2)^2);
start_s2_e_f(j,1)=start_s2_e;

end_s1_e=norm(x3)^2*log10(norm(x3)^2);
end_s1_e_f(j,1)=end_s1_e;

end_s2_e=norm(x4)^2*log10(norm(x4)^2);
end_s2_e_f(j,1)=end_s2_e;

peak_s1_f_e=norm(x5)^2*log10(norm(x5)^2);
peak_s1_f_e_f(j,1)=peak_s1_f_e;

peak_s2_f_e=norm(x6)^2*log10(norm(x6)^2);
peak_s2_f_e_f(j,1)=peak_s2_f_e;

sys1_e=norm(x7)^2*log10(norm(x7)^2);
sys1_e_f(j,1)=sys1_e;

sys2_e=norm(x8)^2*log10(norm(x8)^2);
sys2_e_f(j,1)=sys2_e;

sys3_e=norm(x9)^2*log10(norm(x9)^2);
sys3_e_f(j,1)=sys3_e;
j=j+1;
end 

shannon_matrix=[mean(start_s1_e_f),mean(start_s2_e_f),mean(end_s1_e_f),mean(end_s2_e_f),mean(peak_s1_f_e_f),mean(peak_s2_f_e_f),mean(sys1_e_f),mean(sys2_e_f),mean(sys3_e_f)];

