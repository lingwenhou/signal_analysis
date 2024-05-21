function [signal_total_matric, signal_x_matric, signal_y_matric] = calculate_signal(cur_phantom, sample_rate, Drive_Amp, particle_diameters,Gradient_x, Drive_x_fre, Drive_y_fre, if_simulate_Phantom_signal)
%% 驱动场参数设置
time_sample = 1/sample_rate;
time_total = 1/100;     % 最好是能根据x y 轴驱动场频域 算出时间的最小公倍数，这样就正好能闭合。 后面再调整
time_discrete = time_sample:time_sample:time_total;
s_x = 1e-3;    % [T/A] 单位转化
s_y = 1e-3;     % [T/A]
A_x = Drive_Amp;       
A_y = Drive_Amp;       
Drive_x =  s_x * A_x * sin(2 * pi * Drive_x_fre * time_discrete);
Drive_y =  s_y * A_y * sin(2 * pi * Drive_y_fre * time_discrete);
%% 选择场设置
Gradient_y = Gradient_x*2;
volume_size = 1e-3;
% size_x = 0.04;     
% size_y = 0.02;

size_x = A_x*s_x*2/Gradient_x;
size_y = A_y*s_y*2/(Gradient_y);      % y向
size_x = size_x * 1.0;      % 乘以一个因子 使展示大小 大于 fov
size_y = size_y * 1.0;

range_x = -size_x:volume_size:size_x;
range_y = -size_y:volume_size:size_y;
[X, Y] = meshgrid(range_x, -range_y);
Select_x = Gradient_x.*X;
Select_y = Gradient_y.*Y;
%% 位置计算
Position_x = Drive_x ./ Gradient_x;
Position_y = Drive_y ./ Gradient_y;  

%% 绘制轨迹图
% figure;
%%逐点观察扫描轨迹
% for i = 1:length(Position_x)
%    plot(Position_x(i)*1e3, Position_y(i)*1e3,'.');
%    hold on;
%    pause(0.00001);
% end
%%直接绘制出扫描轨迹
% plot(Position_x(:)*1e3,Position_y(:)*1e3)
% xlabel('X(mm)','FontSize',25)
% ylabel('Y(mm)','FontSize',25)
% xlabel("X")
% ylabel("Y")
% axis equal
% title("扫描轨迹")
%% 磁场合并
H_total_x = Select_x + reshape(Drive_x, [1, 1, length(time_discrete)]);
H_total_y = Select_y + reshape(Drive_y, [1, 1, length(time_discrete)]);
H_total = sqrt(H_total_x.^2 + H_total_y.^2);
%%%%%%  my_code
% H_total = zeros(size(Select_x, 1),size(Select_x, 2), length(time_discrete));
% H_total_x = zeros(size(Select_x, 1),size(Select_x, 2), length(time_discrete));
% H_total_y = zeros(size(Select_x, 1),size(Select_x, 2), length(time_discrete));
% for i = 1:length(time_discrete)  
%    H_total_x_cur = Select_x + Drive_x(i);
%    H_total_y_cur = Select_y + Drive_y(i);
%    H_total(:,:,i) = sqrt(H_total_x_cur.^2+H_total_y_cur.^2);
%    H_total_x(:,:,i) = H_total_x_cur;
%    H_total_y(:,:,i) = H_total_y_cur;
% end
%%%%%%

%% 求解粒子磁化响应
% for i = 1:size(H_total,1)
%     for j = 1:size(H_total, 2)
%         cur_phantom = zeros(size(H_total,1),size(H_total,2));
%         cur_phantom(i, j) = 1;
%         M_H_cur = calculate_para(H_total)
%     end
% end
M_H_total = calculate_para(H_total, particle_diameters);    % 磁化
M_H_x = (H_total_x./H_total).*M_H_total;
M_H_y = (H_total_y./H_total).*M_H_total;
% signal_matric = diff(M_H_total, 1, 3);       % 计算每个位置处的信号 等价于在每个位置出分别扫描一个点源
% signal_total_matric = [M_H_total(:,:,2:end), M_H_total(:,:,end-1:end)]-M_H_total;
% 仿体信号和系统矩阵生成分离开
if if_simulate_Phantom_signal    
%   仿体信号生成
    M_H_x = M_H_x.*cur_phantom;
    M_H_y = M_H_y.*cur_phantom;
    M_H_x_sum = squeeze(sum(sum(M_H_x, 1),2));
    M_H_y_sum = squeeze(sum(sum(M_H_y, 1),2));
    signal_x_matric = cat(1, M_H_x_sum(2:end), M_H_x_sum(end)) - M_H_x_sum;
    signal_y_matric = cat(1, M_H_y_sum(2:end), M_H_y_sum(end)) - M_H_y_sum;
    signal_x_matric = signal_x_matric/time_sample;
    signal_y_matric = signal_y_matric/time_sample;
%     signal_total_matric = cat(3, M_H_total(:,:,2:end), M_H_total(:,:,end)) - M_H_total; 
    signal_total_matric = 0;% 这里不适用因此不用计算
else
%   SM生成
    signal_total_matric = cat(3, M_H_total(:,:,2:end), M_H_total(:,:,end)) - M_H_total;
    signal_x_matric = cat(3, M_H_x(:,:,2:end), M_H_x(:,:,end)) - M_H_x;     
    signal_y_matric = cat(3, M_H_y(:,:,2:end), M_H_y(:,:,end)) - M_H_y;
    signal_total_matric = signal_total_matric/time_sample;
    signal_x_matric = signal_x_matric/time_sample;
    signal_y_matric = signal_y_matric/time_sample;
end

end

