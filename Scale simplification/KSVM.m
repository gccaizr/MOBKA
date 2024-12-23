function validationRMSE = KSVM(t,response,K,param1,param2)
% clc;clear
% K=5;param1=0.01;param2=1.34;
% data=xlsread('肠镜量表数据.xlsx');
% t=data(:,1:4);
% response=data(:,51);
rng('default') % For reproducibility
predictors=t;
% 执行交叉验证
KFolds = K;
cvp = cvpartition(size(response, 1), 'KFold', KFolds);
% 将预测初始化为适当的大小
validationPredictions = response;
for fold = 1:KFolds
    trainingPredictors = predictors(cvp.training(fold), :);
    trainingResponse = response(cvp.training(fold), :);
    

    % 训练回归模型
    % 以下代码指定所有模型选项并训练模型。
    responseScale = iqr(trainingResponse);
    if ~isfinite(responseScale) || responseScale == 0.0
        responseScale = 1.0;
    end
    
    epsilon = responseScale/13.49;
    regressionSVM = fitrsvm(...
        trainingPredictors, ...
        trainingResponse, ...
        'KernelFunction', 'gaussian', ...
        'PolynomialOrder', [], ...
        'KernelScale', param1, ...
        'BoxConstraint', param2, ...
        'Epsilon', epsilon, ...
        'Standardize', true);

    % 使用 predict 函数创建结果结构体
    svmPredictFcn = @(x) predict(regressionSVM, x);
    validationPredictFcn = @(x) svmPredictFcn(x);

    % 向结果结构体中添加字段

    % 计算验证预测
    validationPredictors = predictors(cvp.test(fold), :);
    foldPredictions = validationPredictFcn(validationPredictors);

    % 按原始顺序存储预测
    validationPredictions(cvp.test(fold), :) = foldPredictions;
end

% 计算验证 RMSE
isNotMissing = ~isnan(validationPredictions) & ~isnan(response);
validationRMSE = sqrt(nansum(( validationPredictions - response ).^2) / numel(response(isNotMissing) ));

% validationRMSE=rsquare(response,validationPredictions);
