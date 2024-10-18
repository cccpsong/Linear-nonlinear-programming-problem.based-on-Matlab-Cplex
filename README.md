线性规划问题，Matlab+Yalmip+Cplex，Ilog/Cplex，从入门开始....<br>
==
<br>

欢迎大家批评指正，又cai又爱玩  
<br>
问题一
--
1.某工厂在计划期内要安排生产桌子（table)、椅子（chair），已知生产单位产品所需的设备台时及A，B两种原材料的消耗量，如表所示。该工厂每生产一张桌子获利2元，每生产一件椅子获利3元，问如何安排生产获利最大？
<br>
<br>
<div align="center">
    
|    | 资源约束表 |    |   |
| ------------- | ------------- | ------------- | ------------- |
| Content Cell  | 桌子/张  | 椅子/张  | 合计  |
| 设备台时  | 1  | 2  | 8  |
| 原材料A  | 4  | 0  | 16 kg |
| 原材料B  | 0  | 4  | 12kg  |

</div>
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
很简单啊，不解释，下面给出Matlab+Yalmip+Cplex代码，见库中名为Cplex1.m的文件
<br>

```matlab
clc
x = sdpvar(1,2);                    %定义x1，x2
Constraints = [x(1) + 2*x(2) <= 8 , 4*x(1) <= 16,4*x(2)<=12 , x(1)>=0 , x(2) >= 0];   %约束条件

z = 2*x(1) + 3*x(2);         %目标函数

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
```
<br>
下面给出Ilog/Cplex代码，其文件见库中的Cplex1文件夹。<br>
如下为mod文件代码

```cpp
{string} Products = ...;
{string} Components = ...;

float demand[Products][Components] = ...;
float Profit[Products] = ...;
float Stock[Components] = ...;
dvar float+ Production[Products];

maximize
  sum( p in Products ) 
    Profit[p] * Production[p];
    
subject to {
  forall( c in Components )
    ct:
      sum( p in Products ) 
        demand[p,c] * Production[p] <= Stock[c];
};
```
<br>
如下为dat文件代码

```cpp
Products={ "table " "chair "};
Components={ "equipment ""materialA ""materialB "};
demand=[[1,4,0],[2,0,4]];
Profit=[2,3];
Stock=[8,16,12];
```
<br>
至此，第一题完毕--2024.10.18
