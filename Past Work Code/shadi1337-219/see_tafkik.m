%% Plot Results

dim1=1;
dim2=2;

figure;
%plot(f_shadi_validation_n(:,dim1),f_shadi_validation_n(:,dim2),'or','MarkerSize',10);

plot(f_shadi_validation_n(:,dim1),'or','MarkerSize',10);
hold on;
% plot(f_shadi_validation_ab(:,dim1),f_shadi_validation_ab(:,dim2),'ob','MarkerSize',10);
plot(f_shadi_validation_ab(:,dim1),'ob','MarkerSize',10);
axis([0 160 0 max(f_shadi_validation_n(:,dim1),f_shadi_validation_ab(:,dim1))])


plot(x{1}(~is_normal{1},dim1),x{1}(~is_normal{1},dim2),'xr','LineWidth',2,'MarkerSize',10);
plot(x{2}(~is_normal{2},dim1),x{2}(~is_normal{2},dim2),'xb','LineWidth',2,'MarkerSize',10);
plot(x{3}(~is_normal{3},dim1),x{3}(~is_normal{3},dim2),'xk','LineWidth',2,'MarkerSize',10);

