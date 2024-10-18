线性规划问题，Matlab+Yalmip+Cplex，Ilog/Cplex，从入门开始....<br>
==
<br>

欢迎大家批评指正，又cai又爱玩  
<br>
问题一，问题描述<br>
--
1.某工厂在计划期内要安排生产桌子（table)、椅子（chair），已知生产单位产品所需的设备台时及A，B两种原材料的消耗量，如表1所示。该工厂每生产一张桌子获利2元，每生产一件椅子获利3元，问如何安排生产获利最大？
<br>
<br>
|    | 资源约束表 |    |   |
| ------------- | ------------- | ------------- | ------------- |
| Content Cell  | 桌子/张  | 椅子/张  | 合计  |
| 设备台时  | 1  | 2  | 8  |
| 原材料A  | 4  | 0  | 16 kg |
| 原材料B  | 0  | 4  | 12kg  |
<br>
建议自己写出他的数学模型，非常简单...
<br>
目标函数为：

$$
\text{max } z = 2x_1 + 3x_2
$$

<br>
Subject to:

$$
x_1 + 2x_2 \leq 8
$$
$$
4x_1 \leq 16
$$
$$
4x_2 \leq 12
$$
$$
x_1, x_2 \geq 0
$$

<br>
很简单啊，不解释了，下面给出Matlab+Yalmip+Cplex代码，见库中名为Cplex1.md的文件
<br>
`
clc
x = sdpvar(1,2);
Constraints = [x(1) + 2*x(2) <= 8 , 4*x(1) <= 16,4*x(2)<=12 , x(1)>=0 , x(2) >= 0];

z = 2*x(1) + 3*x(2);

sol = optimize(Constraints , -z);
if sol.problem == 0
    disp('求解成功')
    x1 = value(x(1))
    x2 = value(x(2))
    disp(['目标函数最大值为：' , num2str(value(z))])
else
    disp('求解失败')
    disp(sol.info)
end
`
