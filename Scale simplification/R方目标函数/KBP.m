function validationRMSE = KBP(t,response,K,param1,param2)
% clc;clear
% K=5;param1=3;param2=1.34;
% data=xlsread('肠镜量表数据.xlsx');
% t=data(:,7:9);
% response=data(:,52);


rng('default') % For reproducibility
% 训练回归模型
% 以下代码指定所有模型选项并训练模型。
regressionNeuralNetwork = fitrnet(...
    t, ...
    response, ...
    'LayerSizes', param1, ...
    'Activations', 'tanh', ...
    'Lambda', param2, ...
    'IterationLimit', 1000, ...
    'Standardize', true);

% 执行交叉验证
partitionedModel = crossval(regressionNeuralNetwork, 'KFold', K);

% 计算验证预测
validationPredictions = kfoldPredict(partitionedModel);

% 计算验证 RMSE
% validationRMSE = sqrt(kfoldLoss(partitionedModel, 'LossFun', 'mse'));

validationRMSE=rsquare(response,validationPredictions);
