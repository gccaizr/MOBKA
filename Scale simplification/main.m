%% 多目标优化量表
% 优化目标1：机器学习预测结果精准度高
% 优化目标2：特征数量少
% 限制条件：1.每个维度至少保留2个以上条目；
%          2.Cronbach's alpha大于0.7。
close all;
clear ; 
clc;
addpath('./NSDBO/')  % 添加算法路径
D=xlsread('data.xlsx');               % 读取问卷数据

% data=readtable("肠镜量表数据.xlsx");
% 设置目标函数MultiObj
MultiObj.numOfObj=2;                         % 目标函数个数
MultiObj.fun=@(x)OBj(x,D);                   % 目标函数
MultiObj.nVar=106;                           % 自变量数量
MultiObj.name='简化量表';


MultiObj.var_min=zeros(1,106);                % 自变量下届
MultiObj.var_max=ones(1,106);                 % 自变量上届
MultiObj.var_max(51:57)=4.*ones(1,7);         % 模型选择变量
for i=0:6:36
% MultiObj.var_max(i+58)=
% SVM超参数
MultiObj.var_min(i+59)=0.001;
MultiObj.var_max(i+59)=1000;
MultiObj.var_min(i+60)=0.001;
MultiObj.var_max(i+60)=1000;
% BP超参数
MultiObj.var_min(i+61)=1;
MultiObj.var_max(i+61)=300;
MultiObj.var_min(i+62)=1e-08;
MultiObj.var_max(i+62)=100;
% RT
MultiObj.var_min(i+63)=1;
MultiObj.var_max(i+63)=50;
end

% Parameters
params.Np = 100;        % Population size
params.Nr = 200;        % Archive size
params.maxgen = 1000;    % Maximum number of iteration
params.ngrid = 50;      % Number of grids in each dimension
[Xbest,Fbest]  = MOBKA(params,MultiObj);

PlotCosts(Xbest,Fbest,'1')


