% function [trainedModel, validationRMSE] = KGRP(t,response,K,param1)

clc;clear
K=5;param1=4;param2=1.34;
data=xlsread('肠镜量表数据.xlsx');
t=data(:,1:4);
response=data(:,52);
rng('default') % For reproducibility
predictors=t;
% 训练回归模型
% 以下代码指定所有模型选项并训练模型。
regressionGP = fitrgp(...
    predictors, ...
    response, ...
    'BasisFunction', 'constant', ...
    'KernelFunction', 'ardrationalquadratic', ...
    'Sigma', param1, ...
    'Standardize', true);                %GRP训练模型

% 执行交叉验证
partitionedModel = crossval(regressionGP, 'KFold', K);

% 计算验证预测
validationPredictions = kfoldPredict(partitionedModel);

% 计算验证 RMSE
validationRMSE = sqrt(kfoldLoss(partitionedModel, 'LossFun', 'mse'));

% validationRMSE=rsquare(response,validationPredictions);
