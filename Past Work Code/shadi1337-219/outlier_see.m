clc;
clear;
close all;

data=load('fisheriris');

X=data.meas;
Y=data.species;

x{1}=X(1:50,:);
x{2}=X(51:100,:);
x{3}=X(101:150,:);
x=x';

n=zeros(size(x));
m=cell(size(x));
S=cell(size(x));
z=cell(size(x));
is_normal=cell(size(x));

alpha=5;

for i=1:numel(x)
    
    n(i)=size(x{i},1);
    m{i}=mean(x{i});
    S{i}=0;
    for j=1:n(i)
        S{i}=S{i}+(x{i}(j,:)-m{i})'*(x{i}(j,:)-m{i});
    end
    S{i}=S{i}/(n(i)-1);
    
    for j=1:n(i)
        z{i}(j,:)=(x{i}(j,:)-m{i})*inv(S{i})*(x{i}(j,:)-m{i})';
    end
        
    is_normal{i}=(z{i}<=alpha);
    
end

%% Plot Results

dim=2;
dim2=4;

figure;
%plot(x{1}(:,dim1),x{1}(:,dim2),'or','MarkerSize',10);
plot(x{1}(:,dim1),'or','MarkerSize',10);
hold on;
plot(x{2}(:,dim1),'ob','MarkerSize',10);
%plot(x{2}(:,dim1),x{2}(:,dim2),'ob','MarkerSize',10);
plot(x{3}(:,dim1),x{3}(:,dim2),'ok','MarkerSize',10);

plot(x{1}(~is_normal{1},dim1),x{1}(~is_normal{1},dim2),'xr','LineWidth',2,'MarkerSize',10);
plot(x{2}(~is_normal{2},dim1),x{2}(~is_normal{2},dim2),'xb','LineWidth',2,'MarkerSize',10);
plot(x{3}(~is_normal{3},dim1),x{3}(~is_normal{3},dim2),'xk','LineWidth',2,'MarkerSize',10);






