function [signal_x_out, signal_y_out, Position_x, Position_y, F_position] = calculate_signal(Phantom,Excited_Amp, Excited_fre, Drive_Amp, Drive_x_fre, Drive_y_fre,Gradient_x, sample_rate, particle_diameters, X, Y)
time_sample = 1/sample_rate;
time_total = 1/Drive_y_fre;     
time_discrete = 0:time_sample:0.5*time_total;
time_sig = time_discrete(1)+time_sample/2:time_sample:time_discrete(end)-time_sample/2; 
%% 激励场设置
s_e = 0.6;       % 激励线圈灵敏度待确认
Excited_x = s_e * Excited_Amp * sin(2 * pi * Excited_fre * time_discrete);
%% 驱动场参数设置
s_x = 0.87;    % [mT/A]   线圈灵敏度
s_y = 1.74;     % [mT/A]
A_x = Drive_Amp;       % [A]
A_y = Drive_Amp;       % [A]
Drive_x = s_x * A_x * sin(2 * pi * Drive_x_fre * time_discrete);
Drive_y = s_y * A_y * cos(2 * pi * Drive_y_fre * time_discrete);
%% 选择场设置

Gradient_y = Gradient_x*2;
Select_x = Gradient_x.*X;       % x方向选择场设置
Select_y = Gradient_y.*Y;       % y方向选择场设置

%% 磁场合并
H_total_x = Select_x + reshape(Drive_x, [1, 1, length(time_discrete)]) + reshape(Excited_x, [1, 1, length(time_discrete)]);
H_total_y = Select_y + reshape(Drive_y, [1, 1, length(time_discrete)]);
H_total = sqrt(H_total_x.^2 + H_total_y.^2);        % 总磁场

velocity_x = diff(H_total_x(1,1,:));    % 速度
velocity_x = velocity_x(:);
velocity_y = diff(H_total_y(1,1,:));
velocity_y = velocity_y(:);

start_point_x = X(H_total(:,:,1) == min(min(H_total(:,:,1))));       % 初始位置
start_point_y = Y(H_total(:,:,1) == min(min(H_total(:,:,1))));

Position_x = start_point_x - cumtrapz(velocity_x)./Gradient_x;          % 采样时间内所有位置
Position_y = start_point_y - cumtrapz(velocity_y)./Gradient_y;
% plot(Position_x, Position_y);
%% 求解粒子磁化响应
M_H_total = Phantom.*calculate_para(H_total, particle_diameters);    % 磁化
M_H_x = (H_total_x./H_total).*M_H_total;
M_H_y = (H_total_y./H_total).*M_H_total;

sum_MH_x = squeeze(sum(sum(M_H_x,2),1));
sum_MH_y = squeeze(sum(sum(M_H_y,2),1));
signal_x = diff(sum_MH_x);
signal_y = diff(sum_MH_y);

CroppingFactor = 0.2;        % 简单的滤波操作
HighIndex = abs(velocity_x)>(CroppingFactor*max(velocity_x(:)));       
signal_x(not(HighIndex)) = NaN; 

signal_x_out = signal_x./velocity_x;    % 速度归一化
signal_y_out = signal_y./velocity_y; 
%% 
F_position = scatteredInterpolant(Position_x(HighIndex),Position_y(HighIndex),signal_x_out(HighIndex));
end
