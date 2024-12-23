function crit=prabow(param1)

if param1<=0.25
    crit='linear';%预测变量中的常数项和线性项
elseif param1<=0.5
    crit='interactions';%常数项、线性项和预测变量之间的交互作用项
elseif param1<=0.75
    crit='purequadratic';%常数项、线性项和每个预测变量中的纯二次项
else
    crit='quadratic';%常数项、线性项和二次项（包括相互作用）
end

end