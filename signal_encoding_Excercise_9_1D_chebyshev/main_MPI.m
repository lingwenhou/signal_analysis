%% 理解MPI使用
clear
clc;
close all;
%% 基本参数设置
number_point = 500;     % fov 内 体素数量
sample_rate = 1e7;      % 采样率
H_G = 2.5;     % 选择场梯度  T/m
particle_diameters = 25e-9;     % 粒径 此处单位为 nm
Excited_Amplitute = 50e-3;      % 激励场幅值       
Excited_Fre = 24e3;     % 激励场频率
t_pe = 1/Excited_Fre;
% t = 0:t_sam:5*1/(25e3);  % 3 Period
t = -t_pe*1.5:1/sample_rate:t_pe*1.5;
x_range = Excited_Amplitute/H_G * 2;  % FOV
x_range = x_range*1.2;
% 生成一个一维仿体
Phantom = zeros(1, number_point);
% Phantom(200) = 2;
Phantom(10) = 1;

%% 信号生成
[M_H, chebyshev_fre] = calculate_signal(H_G,particle_diameters,Excited_Amplitute,Excited_Fre,t,number_point, x_range);
signal_matric = diff(M_H, 1);       % 计算每个位置处的信号 等价于在每个位置出分别扫描一个点源
% 
% %% 信号傅里叶变换
f = sample_rate*(0:size(signal_matric, 1)/2)/size(signal_matric, 1);    % 10M a频点
% 
out_fre_Amplitude_matric = zeros(size(signal_matric, 1)/2+1, size(signal_matric, 2));
out_fre_Phase_matric = zeros(size(signal_matric, 1)/2+1, size(signal_matric, 2));
for i = 1:size(signal_matric,2)
    [out_fre_Amplitude_matric(:,i), out_fre_Phase_matric(:,i)] = signal_fft(signal_matric(:,i), size(signal_matric,1));
end
% 此处生成的 out_fre_Amplitude_matric 其实就是系统矩阵

% %% plot
curAmp = out_fre_Amplitude_matric((find(ismember(f/Excited_Fre, (1:9)))),:);
figure(1)
for i = 1:9
    subplot(3,3,i)
    plot(curAmp(i,:)*1e4, 'r');
    title(num2str(i)+"次谐波")
    xlabel("相对位置");
    ylabel("幅值");
end
sgtitle("理想粒子仿真结果");

chebyshev_apl = abs(chebyshev_fre);
chebyshev_apl(2:end,:) =  2*chebyshev_apl(2:end,:);
chebyshev_pha = angle(chebyshev_fre);
out_Amplitute = ((chebyshev_pha > 0)+(chebyshev_pha<0)*(-1)).*chebyshev_apl;
figure(2)
for i = 1:9
    subplot(3,3,i)
    plot(out_Amplitute(i,:), 'r');
    title(num2str(i)+"次谐波")
    xlabel("相对位置");
    ylabel("幅值");
end
sgtitle("切比雪夫");

% 
% sec = diff(curAmp(1,:));
% third = diff(sec);
% figure(3)
% subplot(1,3,1)
% plot(curAmp(1,:)*1e7, 'b');
% subplot(1,3,2)
% plot(sec*1e7, 'b');
% subplot(1,3,3)
% plot(third*1e7, 'b');
