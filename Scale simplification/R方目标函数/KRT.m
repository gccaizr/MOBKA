function validationRMSE = KRT(t,response,K,param1)

% clc;clear
% K=5;param1=4;param2=1.34;
% data=xlsread('肠镜量表数据.xlsx');
% t=data(:,1:4);
% response=data(:,51);

rng('default') % For reproducibility
predictors=t;
% 训练回归模型
% 以下代码指定所有模型选项并训练模型。
regressionTree = fitrtree(...
    predictors, ...
    response, ...
    'MinLeafSize', param1, ...
    'Surrogate', 'off');

% 执行交叉验证
partitionedModel = crossval(regressionTree, 'KFold', K);

% 计算验证预测
validationPredictions = kfoldPredict(partitionedModel);

% 计算验证 RMSE
% validationRMSE = sqrt(kfoldLoss(partitionedModel, 'LossFun', 'mse'));
validationRMSE=rsquare(response,validationPredictions);
