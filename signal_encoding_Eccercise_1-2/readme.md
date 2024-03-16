程序为MPI基础知识练习。主要参考文献“Signal encoding in magnetic particle imaging: properties of the system function”

main_MPI.m 为主程序

下面为基本参数设置，可以调整不同激励波形，三角波，正弦波

```
%% 激励场设置
t = 0:1e-8:5*1/(25e3);  %采样率为100Ms/s
Excited_Amplitute = 50e-3;      % 激励幅值
Excited_Fre = 25e3;             % 激励频率
H = Excited_Amplitute * sin(2*pi*Excited_Fre*t);    % 余弦激励 激励场幅值50mT  频率 25kHz
% H = Excited_Amplitute*sawtooth(2 * pi * Excited_Fre * t, 0.5);  % 三角波激励 激励场幅值50mT  频率 25kHz
particle_diameters = [10, 15, 20, 25];      % 粒径
```

calculate_para.m 中可以选择不同的粒子模型 langevin模型，  阶跃函数、线性函数

```
out = c*momet*langevin(Beta*H/u0);      % 可选择不同粒子响应模型
out = u0*S*VT*out;      % 输出
deri_M_H = c*momet*Beta*deri_langevin(Beta*H/u0);  
% 郎之万模型
function out = langevin(xi)
    xi = xi+0.000001;
    out = coth(xi)-1./xi;
end
% 阶跃响应模型
function out = step_cur(xi)
    max_value = max(xi);
    bias_ratio = 0.0;       % 偏置比
    xi(xi<max_value*bias_ratio) = -max_value;
    xi(xi>=max_value*bias_ratio) = max_value;
    out = xi;
end
% 线性响应模型
function out = linear_cur(xi)
    max_value = max(xi);
    duty_cycle = 0.1;       %线性范围占比
    bias_ratio = 0.3;   % 偏执百分比
    xi = xi - bias_ratio*max_value;
    xi(xi<-duty_cycle*max_value) = -max_value;       % 给线性范围加上偏执
    xi(xi>=duty_cycle*max_value) = max_value;
    %%%% 
    xi(xi>=-duty_cycle*max_value & xi<duty_cycle*max_value) = (1/duty_cycle)*xi(xi>=-duty_cycle*max_value & xi<duty_cycle*max_value); 
    out = xi; 
end
```

输出结果示例：

![正弦波激励+langevin](E:\23121110600\01code\MPI_Simulation\signal_analysis\signal_encodingfigure1-2练习\out_figure\正弦波激励+langevin.jpg)