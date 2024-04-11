function [M_H, chebyshev_fre] = calculate_signal(H_G,particle_diameters,Excited_Amplitute,Excited_Fre,t,number_point,x_range)
%% 其他参数设置

%% 激励场设置

H_AC = Excited_Amplitute * cos(2*pi*Excited_Fre*t);    % 余弦激励 激励场幅值50mT  频率 25kHz

%% 选择场设置
point_size = x_range/number_point;
H_S = -0.5*(H_G*x_range)+point_size*H_G : point_size*H_G : 0.5*(H_G*x_range);   % 生成每个点对应的梯度

%% 选择激励叠加  
% 无法直接直接动态叠加，
% 因此使用二维矩阵模型模拟，矩阵的每一行代表fov中的不同位置， 
% 每一列代表不同的时间，组合起来就是不同时间不同位置处的混合场强
H_AC_size = size(H_AC,2);           %  时间维度
H_S_size  = size(H_S,2);            % 位置维度

% Phantom_matric = repmat(Phantom, H_AC_size, 1); % 生成仿体矩阵，仿体相同位置处不同时刻一致
H_AC_matric = repmat(H_AC', 1, H_S_size);       % 假设同一时刻，fov内所有区域场强相同
H_S_matric = repmat(H_S, H_AC_size, 1);
H_total = H_AC_matric + H_S_matric;

%% 求解粒子磁化响应
M_H = calculate_para(H_total, particle_diameters);    % 磁化

u_chebyshev = H_S/Excited_Amplitute;
chebyshev_fre = chebyshev_Core(u_chebyshev, H_S, Excited_Fre);
% M_H_out = Phantom_matric.*M_H;          
% M_H_total = sum(M_H_out');     % 对不同位置处产生的响应求和，每个位置的响应求和即为最终的响应信号
% M_H_dif= [M_H_total(2:end),M_H_total(end)]-M_H_total;
% M_H_dif = diff(M_H_total);  % 信号
end

