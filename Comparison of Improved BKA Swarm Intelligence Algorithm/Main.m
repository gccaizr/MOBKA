close all;
clear ; 
clc;
%%
addpath(genpath('MOPSO'));
addpath(genpath('MOBKA'));
addpath(genpath('MSSA'));
% TestProblem��������˵����
%һ��46����Ŀ����Ժ������������£�
%1-5:ZDT1��ZDT2��ZDT3��ZDT4��ZDT6
%6-12��DZDT1-DZDT7
%13-22��wfg1-wfg10
%23-32��uf1-uf10
%33-42��cf1-cf10
%43-46:Kursawe��Poloni��Viennet2��Viennet3
%47 ��ʽ�ƶ������ ������,л�B,л��,����Ө.��������ӵ���Ⱦ���Ķ�Ŀ����ȸ�����㷨[J].�����������Ӧ��,2021,57(22):102-109.
%%
% for ww=2:46
% close all;
TestProblem=22;%1-47
MultiObj = GetFunInfo(TestProblem);
MultiObjFnc=MultiObj.name;%������
% Parameters
params.Np = 50;        % Population size
params.Nr = 100;        % Repository size
params.maxgen=50;    % Maximum number of generations
numOfObj=MultiObj.numOfObj;%Ŀ�꺯������
D=MultiObj.nVar;%ά��

%% ��һ���㷨
for i=1:30  % ����30��(��һ��)
f = MOBKA(params,MultiObj);
disp(['��1���㷨���е�' num2str(i) '��'])
X=f(:,1:D);%PS
Obtained_Pareto=f(:,D+1:D+numOfObj);%PF
if(isfield(MultiObj,'truePF'))%�ж��Ƿ��вο���PF
True_Pareto=MultiObj.truePF;
%  Metric Value
% ResultData��ֵ�ֱ���IGD��GD��HV��Spacing  (HVԽ��Խ�ã�����ָ��ԽСԽ��)
ResultData=[IGD(Obtained_Pareto,True_Pareto),GD(Obtained_Pareto,True_Pareto),HV(Obtained_Pareto,True_Pareto),Spacing(Obtained_Pareto)];
else
    %����ÿ���㷨��Spacing��SpacingԽС˵���⼯�ֲ�Խ����
    ResultData=Spacing(Obtained_Pareto);%�����Spacing
end
results1(i,:)=ResultData;
% f2 = NSWOA(params,MultiObj);
% f3 = MOPSO(params,MultiObj);
% f4 = MOMSA(params,MultiObj);
% f5 = MSSA(params,MultiObj);
end

%% �ڶ����㷨
for i=1:30  % ����30��(�ڶ���)
f = NSDBO(params,MultiObj);
disp(['��2���㷨���е�' num2str(i) '��'])
X=f(:,1:D);%PS
Obtained_Pareto=f(:,D+1:D+numOfObj);%PF
if(isfield(MultiObj,'truePF'))%�ж��Ƿ��вο���PF
True_Pareto=MultiObj.truePF;
%  Metric Value
% ResultData��ֵ�ֱ���IGD��GD��HV��Spacing  (HVԽ��Խ�ã�����ָ��ԽСԽ��)
ResultData=[IGD(Obtained_Pareto,True_Pareto),GD(Obtained_Pareto,True_Pareto),HV(Obtained_Pareto,True_Pareto),Spacing(Obtained_Pareto)];
else
    %����ÿ���㷨��Spacing��SpacingԽС˵���⼯�ֲ�Խ����
    ResultData=Spacing(Obtained_Pareto);%�����Spacing
end
results2(i,:)=ResultData;
% f2 = NSWOA(params,MultiObj);
% f3 = MOPSO(params,MultiObj);
% f4 = MOMSA(params,MultiObj);
% f5 = MSSA(params,MultiObj);
end

%% �������㷨
for i=1:30  % ����30��(������)
f = MOPSO(params,MultiObj);
disp(['��3���㷨���е�' num2str(i) '��'])
X=f(:,1:D);%PS
Obtained_Pareto=f(:,D+1:D+numOfObj);%PF
if(isfield(MultiObj,'truePF'))%�ж��Ƿ��вο���PF
True_Pareto=MultiObj.truePF;
%  Metric Value
% ResultData��ֵ�ֱ���IGD��GD��HV��Spacing  (HVԽ��Խ�ã�����ָ��ԽСԽ��)
ResultData=[IGD(Obtained_Pareto,True_Pareto),GD(Obtained_Pareto,True_Pareto),HV(Obtained_Pareto,True_Pareto),Spacing(Obtained_Pareto)];
else
    %����ÿ���㷨��Spacing��SpacingԽС˵���⼯�ֲ�Խ����
    ResultData=Spacing(Obtained_Pareto);%�����Spacing
end
results3(i,:)=ResultData;
% f2 = NSWOA(params,MultiObj);
% f3 = MOPSO(params,MultiObj);
% f4 = MOMSA(params,MultiObj);
% f5 = MSSA(params,MultiObj);
end

%% �������㷨
for i=1:30  % ����30��(������)
f = MOMSA(params,MultiObj);
disp(['��4���㷨���е�' num2str(i) '��'])
X=f(:,1:D);%PS
Obtained_Pareto=f(:,D+1:D+numOfObj);%PF
if(isfield(MultiObj,'truePF'))%�ж��Ƿ��вο���PF
True_Pareto=MultiObj.truePF;
%  Metric Value
% ResultData��ֵ�ֱ���IGD��GD��HV��Spacing  (HVԽ��Խ�ã�����ָ��ԽСԽ��)
ResultData=[IGD(Obtained_Pareto,True_Pareto),GD(Obtained_Pareto,True_Pareto),HV(Obtained_Pareto,True_Pareto),Spacing(Obtained_Pareto)];
else
    %����ÿ���㷨��Spacing��SpacingԽС˵���⼯�ֲ�Խ����
    ResultData=Spacing(Obtained_Pareto);%�����Spacing
end
results4(i,:)=ResultData;
% f2 = NSWOA(params,MultiObj);
% f3 = MOPSO(params,MultiObj);
% f4 = MOMSA(params,MultiObj);
% f5 = MSSA(params,MultiObj);
end


%% �������㷨
for i=1:30  % ����30��(������)
f = MSSA(params,MultiObj);
f=real(f);
disp(['��5���㷨���е�' num2str(i) '��'])
X=f(:,1:D);%PS
Obtained_Pareto=f(:,D+1:D+numOfObj);%PF
if(isfield(MultiObj,'truePF'))%�ж��Ƿ��вο���PF
True_Pareto=MultiObj.truePF;
%  Metric Value
% ResultData��ֵ�ֱ���IGD��GD��HV��Spacing  (HVԽ��Խ�ã�����ָ��ԽСԽ��)
ResultData=[IGD(Obtained_Pareto,True_Pareto),GD(Obtained_Pareto,True_Pareto),HV(Obtained_Pareto,True_Pareto),Spacing(Obtained_Pareto)];
else
    %����ÿ���㷨��Spacing��SpacingԽС˵���⼯�ֲ�Խ����
    ResultData=Spacing(Obtained_Pareto);%�����Spacing
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
%% ������ʽͼ

Name{1}='IGD';
Name{2}='GD';
Name{3}='HV';
Name{4}='SP';

load ���л滭Ͱ.mat
figure('Position', [25, 25, 1650, 450]);
for i=1:4
subplot(1,4,i);
box_figure = boxplot(Boxplot{i},'color',[0 0 0],'Symbol','.');
set(box_figure,'Linewidth',1.2);
boxobj = findobj(gca,'Tag','Box');
for k = 1:5   %��Ϊ�ܹ���5���㷨��������߸�������ʵ��������ģ�
    patch(get(boxobj(k),'XData'),get(boxobj(k),'YData'),Color(3*k+k,:)./255,'FaceAlpha',0.5,'LineWidth',0.7);
end
axis square; % ������Ϊ������
set(gca,'XTickLabel',{'MOBKA','NSDBO','MOPSO','MOMSA','MSSA'});
title(Name{i})
set(gca,'FontName','Times New Rome','Box','on','FontSize',12,'LineWidth',1.5);
end

set(gcf, 'PaperPositionMode', 'auto'); % ȷ����ӡ�������Ļ��ʾһ��
set(gcf, 'Renderer', 'painters'); % ʹ�ø�������Ⱦ��
% ����ͼƬΪTIFF��ʽ���ֱ���Ϊ600 DPI
print(gcf, MultiObj.name, '-dtiff', '-r600');
% ����ͼ�δ���Ϊ.fig�ļ�
savefig(MultiObj.name);

% end


%% �������ս��ͼ
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



%% ��������ͼ+���ͼ
% figure(1) % �������� 
% subplot(2,3,1); % 

