
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