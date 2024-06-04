function [signal_x_out, Position_x, Position_y, F_position] = calculate_signal(Phantom,Excited_Amp, Excited_fre, Drive_Amp, Drive_x_fre, Drive_y_fre,Gradient_x, Gradient_y, sample_rate, particle_diameters, X, Y)
time_sample = 1/sample_rate;
time_total = 1/Drive_y_fre;     
time_discrete = 0:time_sample:0.5*time_total;
time_sig = time_discrete(1)+time_sample/2:time_sample:time_discrete(end)-time_sample/2; 
%% 激励场设置
s_e = 1;       % [mT/A] 激励线圈灵敏度待确认
Excited_x = s_e * Excited_Amp * sin(2 * pi * Excited_fre * time_discrete);
%% 驱动场参数设置
s_x = 1;    % [mT/A]   线圈灵敏度 
s_y = 1;     % [mT/A] 
A_x = Drive_Amp;       % [A]
A_y = Drive_Amp;       % [A]
Drive_x = s_x * A_x * sin(2 * pi * Drive_x_fre * time_discrete);
Drive_y = s_y * A_y * cos(2 * pi * Drive_y_fre * time_discrete);    % 这里将sin 换成 cos 可将时间减少一半遍历整个FOV
%% 选择场设置

Select_x = Gradient_x.*X;       % x方向选择场设置
Select_y = Gradient_y.*Y;       % y方向选择场设置

%% 磁场合并
H_total_x = Select_x + reshape(Drive_x, [1, 1, length(time_discrete)]) + reshape(Excited_x, [1, 1, length(time_discrete)]);
% H_total_x_pos = Select_x + reshape(Drive_x, [1, 1, length(time_discrete)]);
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
clear velocity_y start_point_x start_point_y time_discrete time_sig H_total_y Excited_x Drive_x Drive_y
% plot(Position_x, Position_y);
% figure(2)
% plot(Position_x);
% hold on;
% plot(Position_y);
%% 求解粒子磁化响应
M_H_total = zeros(size(H_total));
for i = 1:size(H_total, 1)
    M_H_total(i,:,:) = Phantom(i,:).*calculate_para(H_total(i,:,:), particle_diameters);
end 
% M_H_total = Phantom.*calculate_para(H_total, particle_diameters);    % 磁化
M_H_x = (H_total_x./H_total).*M_H_total;
sum_MH_x = squeeze(sum(sum(M_H_x,2),1));
signal_x = diff(sum_MH_x);

CroppingFactor = 0.4;        % 
HighIndex_x = abs(velocity_x)>(CroppingFactor*max(velocity_x(:)));       
signal_x(not(HighIndex_x)) = NaN; 

signal_x_out = signal_x./velocity_x;    % 速度归一化
% figure
% subplot(121);
% plot(signal_x_out);
% subplot(122);
% plot(signal_x);

%% 
F_position = scatteredInterpolant(Position_x(HighIndex_x),Position_y(HighIndex_x),signal_x_out(HighIndex_x));
% F_position = scatteredInterpolant(Position_x,Position_y,signal_x_out);
end

