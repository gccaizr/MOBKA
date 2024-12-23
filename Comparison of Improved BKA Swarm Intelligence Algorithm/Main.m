close all;
clear ; 
clc;
%%
addpath(genpath('MOPSO'));
addpath(genpath('MOBKA'));
addpath(genpath('MSSA'));
% TestProblem测试问题说明：
%一共46个多目标测试函数，详情如下：
%1-5:ZDT1、ZDT2、ZDT3、ZDT4、ZDT6
%6-12：DZDT1-DZDT7
%13-22：wfg1-wfg10
%23-32：uf1-uf10
%33-42：cf1-cf10
%43-46:Kursawe、Poloni、Viennet2、Viennet3
%47 盘式制动器设计 温泽宇,谢珺,谢刚,续欣莹.基于新型拥挤度距离的多目标麻雀搜索算法[J].计算机工程与应用,2021,57(22):102-109.
%%
% for ww=2:46
% close all;
TestProblem=22;%1-47
MultiObj = GetFunInfo(TestProblem);
MultiObjFnc=MultiObj.name;%问题名
% Parameters
params.Np = 50;        % Population size
params.Nr = 100;        % Repository size
params.maxgen=50;    % Maximum number of generations
numOfObj=MultiObj.numOfObj;%目标函数个数
D=MultiObj.nVar;%维度

%% 第一种算法
for i=1:30  % 运行30次(第一种)
f = MOBKA(params,MultiObj);
disp(['第1种算法运行第' num2str(i) '次'])
X=f(:,1:D);%PS
Obtained_Pareto=f(:,D+1:D+numOfObj);%PF
if(isfield(MultiObj,'truePF'))%判断是否有参考的PF
True_Pareto=MultiObj.truePF;
%  Metric Value
% ResultData的值分别是IGD、GD、HV、Spacing  (HV越大越好，其他指标越小越好)
ResultData=[IGD(Obtained_Pareto,True_Pareto),GD(Obtained_Pareto,True_Pareto),HV(Obtained_Pareto,True_Pareto),Spacing(Obtained_Pareto)];
else
    %计算每个算法的Spacing，Spacing越小说明解集分布越均匀
    ResultData=Spacing(Obtained_Pareto);%计算的Spacing
end
results1(i,:)=ResultData;
% f2 = NSWOA(params,MultiObj);
% f3 = MOPSO(params,MultiObj);
% f4 = MOMSA(params,MultiObj);
% f5 = MSSA(params,MultiObj);
end

%% 第二种算法
for i=1:30  % 运行30次(第二种)
f = NSDBO(params,MultiObj);
disp(['第2种算法运行第' num2str(i) '次'])
X=f(:,1:D);%PS
Obtained_Pareto=f(:,D+1:D+numOfObj);%PF
if(isfield(MultiObj,'truePF'))%判断是否有参考的PF
True_Pareto=MultiObj.truePF;
%  Metric Value
% ResultData的值分别是IGD、GD、HV、Spacing  (HV越大越好，其他指标越小越好)
ResultData=[IGD(Obtained_Pareto,True_Pareto),GD(Obtained_Pareto,True_Pareto),HV(Obtained_Pareto,True_Pareto),Spacing(Obtained_Pareto)];
else
    %计算每个算法的Spacing，Spacing越小说明解集分布越均匀
    ResultData=Spacing(Obtained_Pareto);%计算的Spacing
end
results2(i,:)=ResultData;
% f2 = NSWOA(params,MultiObj);
% f3 = MOPSO(params,MultiObj);
% f4 = MOMSA(params,MultiObj);
% f5 = MSSA(params,MultiObj);
end

%% 第三种算法
for i=1:30  % 运行30次(第三种)
f = MOPSO(params,MultiObj);
disp(['第3种算法运行第' num2str(i) '次'])
X=f(:,1:D);%PS
Obtained_Pareto=f(:,D+1:D+numOfObj);%PF
if(isfield(MultiObj,'truePF'))%判断是否有参考的PF
True_Pareto=MultiObj.truePF;
%  Metric Value
% ResultData的值分别是IGD、GD、HV、Spacing  (HV越大越好，其他指标越小越好)
ResultData=[IGD(Obtained_Pareto,True_Pareto),GD(Obtained_Pareto,True_Pareto),HV(Obtained_Pareto,True_Pareto),Spacing(Obtained_Pareto)];
else
    %计算每个算法的Spacing，Spacing越小说明解集分布越均匀
    ResultData=Spacing(Obtained_Pareto);%计算的Spacing
end
results3(i,:)=ResultData;
% f2 = NSWOA(params,MultiObj);
% f3 = MOPSO(params,MultiObj);
% f4 = MOMSA(params,MultiObj);
% f5 = MSSA(params,MultiObj);
end

%% 第四种算法
for i=1:30  % 运行30次(第四种)
f = MOMSA(params,MultiObj);
disp(['第4种算法运行第' num2str(i) '次'])
X=f(:,1:D);%PS
Obtained_Pareto=f(:,D+1:D+numOfObj);%PF
if(isfield(MultiObj,'truePF'))%判断是否有参考的PF
True_Pareto=MultiObj.truePF;
%  Metric Value
% ResultData的值分别是IGD、GD、HV、Spacing  (HV越大越好，其他指标越小越好)
ResultData=[IGD(Obtained_Pareto,True_Pareto),GD(Obtained_Pareto,True_Pareto),HV(Obtained_Pareto,True_Pareto),Spacing(Obtained_Pareto)];
else
    %计算每个算法的Spacing，Spacing越小说明解集分布越均匀
    ResultData=Spacing(Obtained_Pareto);%计算的Spacing
end
results4(i,:)=ResultData;
% f2 = NSWOA(params,MultiObj);
% f3 = MOPSO(params,MultiObj);
% f4 = MOMSA(params,MultiObj);
% f5 = MSSA(params,MultiObj);
end


%% 第五种算法
for i=1:30  % 运行30次(第五种)
f = MSSA(params,MultiObj);
f=real(f);
disp(['第5种算法运行第' num2str(i) '次'])
X=f(:,1:D);%PS
Obtained_Pareto=f(:,D+1:D+numOfObj);%PF
if(isfield(MultiObj,'truePF'))%判断是否有参考的PF
True_Pareto=MultiObj.truePF;
%  Metric Value
% ResultData的值分别是IGD、GD、HV、Spacing  (HV越大越好，其他指标越小越好)
ResultData=[IGD(Obtained_Pareto,True_Pareto),GD(Obtained_Pareto,True_Pareto),HV(Obtained_Pareto,True_Pareto),Spacing(Obtained_Pareto)];
else
    %计算每个算法的Spacing，Spacing越小说明解集分布越均匀
    ResultData=Spacing(Obtained_Pareto);%计算的Spacing
end
results5(i,:)=ResultData;
% f2 = NSWOA(params,MultiObj);
% f3 = MOPSO(params,MultiObj);
% f4 = MOMSA(params,MultiObj);
% f5 = MSSA(params,MultiObj);
end

Boxplot{1}=[results1(:,1) results2(:,1) results3(:,1) results4(:,1) results5(:,1)];
Boxplot{2}=[results1(:,2) results2(:,2) results3(:,2) results4(:,2) results5(:,2)];
Boxplot{3}=[results1(:,3) results2(:,3) results3(:,3) results4(:,3) results5(:,3)];
Boxplot{4}=[results1(:,4) results2(:,4) results3(:,4) results4(:,4) results5(:,4)];
%% 绘制箱式图

Name{1}='IGD';
Name{2}='GD';
Name{3}='HV';
Name{4}='SP';

load 科研绘画桶.mat
figure('Position', [25, 25, 1650, 450]);
for i=1:4
subplot(1,4,i);
box_figure = boxplot(Boxplot{i},'color',[0 0 0],'Symbol','.');
set(box_figure,'Linewidth',1.2);
boxobj = findobj(gca,'Tag','Box');
for k = 1:5   %因为总共有5个算法，这里记者根据自身实际情况更改！
    patch(get(boxobj(k),'XData'),get(boxobj(k),'YData'),Color(3*k+k,:)./255,'FaceAlpha',0.5,'LineWidth',0.7);
end
axis square; % 设置轴为正方形
set(gca,'XTickLabel',{'MOBKA','NSDBO','MOPSO','MOMSA','MSSA'});
title(Name{i})
set(gca,'FontName','Times New Rome','Box','on','FontSize',12,'LineWidth',1.5);
end

set(gcf, 'PaperPositionMode', 'auto'); % 确保打印输出与屏幕显示一致
set(gcf, 'Renderer', 'painters'); % 使用高质量渲染器
% 保存图片为TIFF格式，分辨率为600 DPI
print(gcf, MultiObj.name, '-dtiff', '-r600');
% 保存图形窗口为.fig文件
savefig(MultiObj.name);

% end


%% 绘制最终结果图
M=numOfObj;
if(M==2)
    pl_data= Obtained_Pareto; % extract data to plot
    POS_fit=sortrows(pl_data,2);
    figure(1);

    h_par = plot(POS_fit(:,1),POS_fit(:,2),'ok'); hold on;
    if(isfield(MultiObj,'truePF'))

        h_pf = plot(MultiObj.truePF(:,1),MultiObj.truePF(:,2),'.r'); hold on;
    end
    title(MultiObjFnc);
    grid on; xlabel('f1'); ylabel('f2');
    drawnow;
    hold off
end
if(M==3)
    pl_data=  Obtained_Pareto; % extract data to plot
    POS_fit=sortrows(pl_data,3);
    figure(1);
    h_par = plot3(POS_fit(:,1),POS_fit(:,2),POS_fit(:,3),'ok'); hold on;
    if(isfield(MultiObj,'truePF'))
        h_pf = plot3(MultiObj.truePF(:,1),MultiObj.truePF(:,2),MultiObj.truePF(:,3),'.r'); hold on;
    end
    title(MultiObjFnc);
    grid on; xlabel('f1'); ylabel('f2'); zlabel('f3');
    drawnow;
    hold off
end



%% 绘制箱线图+结果图
% figure(1) % 创建窗口 
% subplot(2,3,1); % 

