function Y=OBj(x,D)
rng('default') % For reproducibility
%% 1-数据D特点分析
% 维度1：1~6列
% 维度2：7~17列（分成两段：7~12，13~17）
% 维度3：18~22列
% 维度4：23~37列
% 维度5：38~44列
% 维度6：45~50列
% 维度1总分：51列
% 维度2总分：52列
% 维度3总分：53列
% 维度4总分：54列
% 维度5总分：55列
% 维度6总分：56列
% 维度7总分：57列
%% 2-可选模型包括：LR、SVM、BPNN、RT 四种常见机器学习模型
% 上述模型共有超参数5个
% ①LR逐步回归超参数param1
% ②SVM，可优化超参数2个
% （1）核尺度：param2（0.001~1000）
% （2）alpha系数的框约束：param3（0.001~1000）
% ③BP优化的超参数2个
% （1）隐含层节点数(整数)：param4(1~300)
% （2）正则化强度（Lambda）：param5(1e-08~100)
% ④RT回归树最小叶大小param6(1~50)
%% 3-x自变量设置
% 1~50：0-1编码
% 51~57：7个维度7个模型的选择,范围[0,3]
% 58~99：超参数优化6个一组7个模型共42个

%% 正式编码
% 各维度数据集对应
data1=D(:,1:6);
data2=D(:,7:12);
data3=D(:,13:17);
data4=D(:,18:22);
data5=D(:,23:37);
data6=D(:,38:44);
data7=D(:,45:50);
% 量表简化编码
p1=x(:,1:6);
p2=x(:,7:12);
p3=x(:,13:17);
p4=x(:,18:22);
p5=x(:,23:37);
p6=x(:,38:44);
p7=x(:,45:50);

% 筛选尺度
c1=x(100);c2=x(101);c3=x(102);c4=x(103);c5=x(104);c6=x(105);c7=x(106);

%% 计算特征数量
N=zeros(1,7);
N(1)=sum(p1>=c1);
N(2)=sum(p2>=c2);
N(3)=sum(p3>=c3);
N(4)=sum(p4>=c4);
N(5)=sum(p5>=c5);
N(6)=sum(p6>=c6);
N(7)=sum(p7>=c7);
y2=sum(N);

%第一个维度
if sum(p1>=c1)<2 || sum(p2>=c2)<2  || sum(p3>=c3)<2  || sum(p4>=c4)<2 || sum(p5>=c5)<2 || sum(p6>=c6)<2 || sum(p7>=c7)<2 % 确保每个维度保留2个条目(限制条件1)
    Y=[100;50];      % 这里需要把y1和y2值弄得很大
elseif y2==50

    Y=[100;50];      % 这里需要把y1和y2值弄得很大
else
    data1(:,p1<c1)=[];   % 正式简化
    a1=cronbach(data1);   % 筛选后的Cronbach's alpha系数

    data2(:,p2<c2)=[];   % 正式简化
    a2=cronbach(data2);   % 筛选后的Cronbach's alpha系数

    data3(:,p3<c3)=[];   % 正式简化
    a3=cronbach(data3);   % 筛选后的Cronbach's alpha系数

    data4(:,p4<c4)=[];   % 正式简化
    a4=cronbach(data4);   % 筛选后的Cronbach's alpha系数

    data5(:,p5<c5)=[];   % 正式简化
    a5=cronbach(data5);   % 筛选后的Cronbach's alpha系数

    data6(:,p6<c6)=[];   % 正式简化
    a6=cronbach(data6);   % 筛选后的Cronbach's alpha系数

    data7(:,p7<c7)=[];   % 正式简化
    a7=cronbach(data7);   % 筛选后的Cronbach's alpha系数

    if a1<0.7 || a2<0.7 || a3<0.7 || a4<0.7 || a5<0.7 || a6<0.7 || a7<0.7  % 如果存在维度得信度很低，失效（限制条件2）
        Y=[100;50];      % 这里需要把y1和y2值弄得很大
    else
        % 这里开始进行正式得预测模型构建
        % 首先需要判断模型选择x(58)
        %% 维度1简化
        switch floor(x(51))
            case 3  % 执行LR
                param1=x(58); % 自变量形式
                param1=prabow(param1);
                RMSE1=KFlm(data1,D(:,51),5,param1); % 计算交叉验证的RMSE
            case 2  % 执行SVM
                param2=x(59); % 核尺度
                param3=x(60); % 框约束
                RMSE1=KSVM(data1,D(:,51),5,param2,param3); % 计算交叉验证的RMSE
            case 1  % 执行BP
                param4=round(x(61)); % 隐含层节点数
                param5=x(62); % 正则化强度
                RMSE1=KBP(data1,D(:,51),5,param4,param5); % 计算交叉验证的RMSE
            case 0  % 执行RT
                param6=round(x(63)); % 最小叶大小
                RMSE1=KRT(data1,D(:,51),5,param6); % 计算交叉验证的RMSE
        end
        %% 维度2简化
        switch floor(x(52))
            case 3  % 执行LR
                param1=x(64); % 自变量形式
                param1=prabow(param1);
                RMSE2=KFlm(data2,D(:,52),5,param1); % 计算交叉验证的RMSE
            case 2  % 执行SVM
                param2=x(65); % 核尺度
                param3=x(66); % 框约束
                RMSE2=KSVM(data2,D(:,52),5,param2,param3); % 计算交叉验证的RMSE
            case 1  % 执行BP
                param4=round(x(67)); % 隐含层节点数
                param5=x(68); % 正则化强度
                RMSE2=KBP(data2,D(:,52),5,param4,param5); % 计算交叉验证的RMSE
            case 0  % 执行RT
                param6=round(x(69)); % 最小叶大小
                RMSE2=KRT(data2,D(:,52),5,param6); % 计算交叉验证的RMSE
        end
        %% 维度3简化
        switch floor(x(53))
            case 3  % 执行LR
                param1=x(70); % 自变量形式
                param1=prabow(param1);
                RMSE3=KFlm(data3,D(:,53),5,param1); % 计算交叉验证的RMSE
            case 2  % 执行SVM
                param2=x(71); % 核尺度
                param3=x(72); % 框约束
                RMSE3=KSVM(data3,D(:,53),5,param2,param3); % 计算交叉验证的RMSE
            case 1  % 执行BP
                param4=round(x(73)); % 隐含层节点数
                param5=x(74); % 正则化强度
                RMSE3=KBP(data3,D(:,53),5,param4,param5); % 计算交叉验证的RMSE
            case 0  % 执行RT
                param6=round(x(75)); % 最小叶大小
                RMSE3=KRT(data3,D(:,53),5,param6); % 计算交叉验证的RMSE
        end
        %% 维度4简化
        switch floor(x(54))
            case 3  % 执行LR
                param1=x(76); % 自变量形式
                param1=prabow(param1);
                RMSE4=KFlm(data4,D(:,54),5,param1); % 计算交叉验证的RMSE
            case 2  % 执行SVM
                param2=x(77); % 核尺度
                param3=x(78); % 框约束
                RMSE4=KSVM(data4,D(:,54),5,param2,param3); % 计算交叉验证的RMSE
            case 1  % 执行BP
                param4=round(x(79)); % 隐含层节点数
                param5=x(80); % 正则化强度
                RMSE4=KBP(data4,D(:,54),5,param4,param5); % 计算交叉验证的RMSE
            case 0  % 执行RT
                param6=round(x(81)); % 最小叶大小
                RMSE4=KRT(data4,D(:,54),5,param6); % 计算交叉验证的RMSE
        end
        %% 维度5简化
        switch floor(x(55))
            case 3  % 执行LR
                param1=x(82); % 自变量形式
                param1=prabow(param1);
                RMSE5=KFlm(data5,D(:,55),5,param1); % 计算交叉验证的RMSE
            case 2  % 执行SVM
                param2=x(83); % 核尺度
                param3=x(84); % 框约束
                RMSE5=KSVM(data5,D(:,55),5,param2,param3); % 计算交叉验证的RMSE
            case 1  % 执行BP
                param4=round(x(85)); % 隐含层节点数
                param5=x(86); % 正则化强度
                RMSE5=KBP(data5,D(:,55),5,param4,param5); % 计算交叉验证的RMSE
            case 0  % 执行RT
                param6=round(x(87)); % 最小叶大小
                RMSE5=KRT(data5,D(:,55),5,param6); % 计算交叉验证的RMSE
        end
        %% 维度6简化
        switch floor(x(56))
            case 3  % 执行LR
                param1=x(88); % 自变量形式
                param1=prabow(param1);
                RMSE6=KFlm(data6,D(:,56),5,param1); % 计算交叉验证的RMSE
            case 2  % 执行SVM
                param2=x(89); % 核尺度
                param3=x(90); % 框约束
                RMSE6=KSVM(data6,D(:,56),5,param2,param3); % 计算交叉验证的RMSE
            case 1  % 执行BP
                param4=round(x(91)); % 隐含层节点数
                param5=x(92); % 正则化强度
                RMSE6=KBP(data6,D(:,56),5,param4,param5); % 计算交叉验证的RMSE
            case 0  % 执行RT
                param6=round(x(93)); % 最小叶大小
                RMSE6=KRT(data6,D(:,56),5,param6); % 计算交叉验证的RMSE
        end
        %% 维度7简化
        switch floor(x(57))
            case 3  % 执行LR
                param1=x(94); % 自变量形式
                param1=prabow(param1);
                RMSE7=KFlm(data7,D(:,57),5,param1); % 计算交叉验证的RMSE
            case 2  % 执行SVM
                param2=x(95); % 核尺度
                param3=x(96); % 框约束
                RMSE7=KSVM(data7,D(:,57),5,param2,param3); % 计算交叉验证的RMSE
            case 1  % 执行BP
                param4=round(x(97)); % 隐含层节点数
                param5=x(98); % 正则化强度
                RMSE7=KBP(data7,D(:,57),5,param4,param5); % 计算交叉验证的RMSE
            case 0  % 执行RT
                param6=round(x(99)); % 最小叶大小
                RMSE7=KRT(data7,D(:,57),5,param6); % 计算交叉验证的RMSE
        end
        % y1=max([RMSE1 RMSE2 RMSE3 RMSE4 RMSE5 RMSE6 RMSE7]);
        y1=RMSE1+RMSE2+RMSE3+RMSE4+RMSE5+RMSE6+RMSE7;
        Y=[y1;y2];
    end
end

end

