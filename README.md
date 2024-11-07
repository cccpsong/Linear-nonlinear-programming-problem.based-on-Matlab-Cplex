线性/非线性规划问题，Matlab+Yalmip+Cplex，Ilog/Cplex，从入门开始....<br>
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
运行结果如下所示：<br>
![Example Image](Chapter_1_pic/matlab1.1.png)

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
运行结果如下所示：<br>

<div align="center">
  <img src="Chapter_1_pic/Cplex1.1.png" alt="Example Image" width="400"/>
</div>

<br>

<div align="center">
  <img src="Chapter_1_pic/Cplex1.2.png" alt="Example Image" width="400"/>
</div>

<br>


至此，第一题完毕--2024.10.18

<br>

问题二，非线性规划问题（POS算法）
--
已知昆明机场次日某时段的航班计划如表所示，设对于连续落地的航班，在次日预报的气象条件下的预计容量为每10min 可以落地 2 架飞机。各机型的地面延误成本为 \( B747 = 130t \), \( B767 = 65t \), \( B737 = 30t \), \( Y7 = 12t \)（单位：元，t 的单位为 min）。求修改后的航班起飞时间表，使地面等待总成本最低。
<br>
<br>
<br>

<div align="center">
    
| 航班号 | 机型  | 起飞机场 | 起飞时刻 | 计划降落时刻 |
|--------|-------|----------|----------|--------------|
| SC981  | B737  | 南昌     | 08:00    | 10:15        |
| CZ3422 | B737  | 成都     | 08:55    | 10:16        |
| MU5407 | Y7    | 贵阳     | 09:20    | 10:17        |
| MF8726 | B767  | 长沙     | 08:30    | 10:17        |
| CA342  | B747  | 武汉     | 08:20    | 10:17        |

<div>
    
<br>
<br>

解：设航班 `SC981`、`CZ3422`、`MU5407`、`MF8726`、`CA342` 分别编号 `1, 2, 3, 4, 5`，它们计划降落时间分别为 ti ，\( i = 1, 2, 3, 4, 5 \)，即表的第5列给出计划降落的时间。在地面等待每分钟的成本是 Ci ，\(i= 1, 2, 3, 4, 5 \)，也即\[C1 = C2 = 30, C3 = 12, C4 = 65, C5 = 130.\]以每 10 分钟为一个时间段，即时间段 \( j = 1 \) 是 `10:00 ～ 10:10`，\( j = 2 \) 是 `10:10 ～ 10:20`。如果实际降落时间为 Tj ，\( j = 1, 2, ..., 6 \)，那么航班 \( i \) 在时间片 \( j \) 降落的成本是<br>


$$
\[
G_{ij} = c_i \cdot (T_j - t_i^a).
\]
$$
   
目标函数：

$$
\min \sum_{i=1}^{5} \sum_{j=1}^{6} G_{ij} X_{ij} = \min 30x_1 + 30x_2 + 12x_3 + 65x_4 + 130x_5
$$

<br>

约束条件为：
<br>

$$
\sum_{i=1}^{5} X_{ij} \leq 2, \quad \forall j \in \{1,2,\ldots,6\} \quad (\text{每个时间片的容量为 2 架})
$$

$$
\sum_{j=1}^{6} X_{ij} = 1, \quad \forall i \in \{1,2,3,4,5\} \quad (\text{保证每架飞机都有一个落地时间})
$$

$$
X_{ij} = 
\begin{cases} 
1, & \text{第 i 架飞机在时间片 j 可以降落} \\ 
0, & \text{其他} 
\end{cases}
$$

$$
x_i = \sum_{j=1}^{6} (T_j - t_i^a) X_{ij}, \quad i = 1,2,\ldots,5 \quad (\text{等待时间})
$$

<br>
以下为书中给的答案：

调整后的航班时刻表如表所示，总增加成本为`120 + 156 + 150 = 426`。

| 航班号 | 机型  | 地面等待成本 | 原起飞时刻 | 增加地面等待时间 | 原预计降落时间 | 修改后预计降落时间 |
|--------|-------|--------------|------------|------------------|----------------|--------------------|
| SC981  | B737  | 30t         | 08:00      | 5                | 10:15         | 10:20             |
| CZ3422 | B737  | 30t         | 08:55      | 4                | 10:16         | 10:20             |
| MU5407 | Y7    | 12t         | 09:20      | 13               | 10:17         | 10:30             |
| MF8726 | B767  | 65t         | 08:30      | 0                | 10:17         | 10:17             |
<br>

<br>
解答：
-
<br>
这是一个非线性规划求最小值问题，Cplex仅限于线性规划，可以考虑使用POS即粒子算法求解。
<br>
粒子算法原理如图所示：

