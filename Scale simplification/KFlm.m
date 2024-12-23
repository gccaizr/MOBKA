function  validationRMSE=KFlm(t,response,K,param)
% clc;clear
% data=xlsread('肠镜量表数据.xlsx');
% t=data(:,1:4);
% K=5;
% param='interactions';
% response=data(:,51);
% rng('default') % For reproducibility
% 执行交叉验证
KFolds = K;
cvp = cvpartition(size(response, 1), 'KFold', KFolds);
% 将预测初始化为适当的大小
validationPredictions = response;
for fold = 1:KFolds
    trainingPredictors = t(cvp.training(fold), :);
    trainingResponse = response(cvp.training(fold), :);

    % 训练回归模型
    % 以下代码指定所有模型选项并训练模型。

    linearModel = fitlm(...
        trainingPredictors,trainingResponse, ...
        param, ...
        'RobustOpts', 'off');

    % 使用 predict 函数创建结果结构体
    linearModelPredictFcn = @(x) predict(linearModel, x);
    validationPredictFcn = @(x) linearModelPredictFcn(x);

    % 向结果结构体中添加字段

    % 计算验证预测
    validationPredictors = t(cvp.test(fold), :);
    foldPredictions = validationPredictFcn(validationPredictors);

    % 按原始顺序存储预测
    validationPredictions(cvp.test(fold), :) = foldPredictions;
end

% 计算验证 RMSE
isNotMissing = ~isnan(validationPredictions) & ~isnan(response);
validationRMSE = sqrt(nansum(( validationPredictions - response ).^2) / numel(response(isNotMissing) ));
% validationRMSE=rsquare(response,validationPredictions);
% end
