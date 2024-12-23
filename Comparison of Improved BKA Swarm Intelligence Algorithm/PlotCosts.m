function PlotCosts(PopFit,Fbest,Title)
figure(1)
plot(PopFit(:,1),PopFit(:,2),'ro')
hold on
plot(Fbest(:,1),Fbest(:,2),'b*')
xlabel('目标函数1')
ylabel('目标函数2')
grid on
hold off
title(Title)
legend('NSDBO的可行解' ,'存档库内非占优解')%,'location','best')


figure(10)
plot(Fbest(:,1),Fbest(:,2),'m*');
legend('NSDBO');
xlabel('预测误差')
ylabel('特征总数量')
title('pareto前沿解集')
end