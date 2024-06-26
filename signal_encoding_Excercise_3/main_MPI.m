%% 理解MPI使用
clear
clc;
close all;
%% 激励场设置
Fs = 1e-8;
t = 0:Fs:5*1/(25e3);  %采样率为100Ms/s
Excited_Amplitute = 50e-3;      % 激励幅值
Excited_Fre = 25e3;             % 激励频率
H_DC_ratio = (0:0.01:1.5);   % 添加的直流分量占交流幅值的比率
H_AC = Excited_Amplitute * cos(2*pi*Excited_Fre*t);    % 余弦激励 激励场幅值50mT  频率 25kHz

% H = Excited_Amplitute*sawtooth(2 * pi * Excited_Fre * t, 0.5);  % 三角波激励 激励场幅值50mT  频率 25kHz
particle_diameters =25;      % 粒径
%% 求解粒子磁化响应
M_H = zeros(length(H_DC_ratio), length(H_AC));
M_H_dif = zeros(length(H_DC_ratio), length(H_AC)-1);
H_matric = zeros(length(H_DC_ratio), length(H_AC));
for i = 1:length(H_DC_ratio)
    H_matric(i,:) = H_AC+H_DC_ratio(i)*Excited_Amplitute;   % 偏置
    [M_H(i,:), df] = calculate_para(H_matric(i,:), particle_diameters*1e-9);    % 粒子磁化
    M_H_dif(i,:) = diff(M_H(i,:));  % 信号
end
%% 信号傅里叶变换
out_Amplitude = zeros(length(H_DC_ratio), (length(H_AC)-1)/2+1);     % 存储输出幅值
out_Phase = zeros(length(H_DC_ratio), (length(H_AC)-1)/2+1);    % 存储输出相位
% f = 1e8*(0:length(M_H_dif(i,:))/2)/length(M_H_dif(i,:));    % 频点
fre_Amplitude = zeros(length(H_DC_ratio), length((1:9)));
fre_Phase = zeros(length(H_DC_ratio), length((1:9)));
fre_imagine = zeros(length(H_DC_ratio), length((1:9)));
fre_real = zeros(length(H_DC_ratio), length((1:9)));
f = 1e8*(0:length(M_H_dif(i,round(1/25e3*1/Fs+1):round(2*1/25e3*1/Fs)))/2)/length(M_H_dif(i,round(1/25e3*1/Fs+1):round(2*1/25e3*1/Fs)));    % 频点
% (round(t*Fs+1):round(2*t*Fs));
% a = M_H_dif(1,round(1/(25e3)*1/Fs+1):round(2*1/(25e3)*1/Fs));
for i = 1:length(H_DC_ratio)
    [origin_fre, out_ampitude, out_phase] = signal_fft(M_H_dif(i,round(1/25e3*1/Fs+1):round(2*1/25e3*1/Fs)), length(M_H_dif(i,round(1/25e3*1/Fs+1):round(2*1/25e3*1/Fs)))); % 傅里叶变换
    fre_Amplitude(i,:) = out_ampitude((find(ismember(f(1:100)/25e3, (1:9)))));    % 找对应频率幅值
    fre_Phase(i,:) = out_phase((find(ismember(f(1:100)/25e3, (1:9)))));       % 找对应频率相位
    fre_imagine(i, :) = imag(origin_fre((find(ismember(f(1:100)/25e3, (1:9))))));   % 取虚部
    fre_real(i, :) = real(origin_fre((find(ismember(f(1:100)/25e3, (1:9))))));      % 取实部
%     out_Amplitude(i,:) = out_ampitude;
%     out_Phase(i,:) = out_phase;
end
%%
% out_x(round(t*f_s+1):round(2*t*f_s));
phase_3 = fre_Phase;

fre_Phase(fre_Phase<0) = -1;
fre_Phase(fre_Phase>=0) = 1;

fre_Amplitude = fre_Amplitude.*fre_Phase;       % 相位 幅值合并

%% 绘图
% 绘制不同偏置场 谐波 相位 幅值变化情况
figure(1);
z_zero = zeros(size(fre_Amplitude));
% 使用 mesh 函数绘制 Z=0 平面
mesh(z_zero, 'FaceAlpha', 0.7); % 设置透明度为 0.5，使 Z=0 平面能够透视显示
hold on;
[x,y] = meshgrid(1:size(fre_Amplitude, 2), 1:size(fre_Amplitude, 1));
% y = 0.01 * y;
for i = 1:size(fre_Amplitude, 1)
    for j = 1:size(fre_Amplitude, 2)
        if mod(i, 2)==0
            color_bar = 'g';
        else
            color_bar = 'b';
        end
        plot3([x(i, j), x(i, j)], [y(i, j), y(i, j)], [0, fre_Amplitude(i, j)], color_bar, 'LineWidth', 2);
        if i > 1
            plot3([x(i-1, j), x(i, j)], [y(i-1, j), y(i, j)], [fre_Amplitude(i-1, j), fre_Amplitude(i, j)], 'k', 'LineWidth', 0.5);
        end
        hold on;
    end 
end
x_categories = {'1f', '2f', '3f', '4f',  '5f', '6f',  '7f', '8f', '9f'};
x_tick_position = 1:numel(x_categories); % 确定x轴刻度位置
xticks(x_tick_position);
xticklabels(x_categories);
% y_categories = {'0', '0.1*A_{AC}', '0.2*A_{AC}', '0.3*A_{AC}', '0.4*A_{AC}', '0.5*A_{AC}', '0.6*A_{AC}'};
% y_tick_position = 1:numel(y_categories);
% yticks(y_tick_position);
% yticklabels(y_categories);
xlabel('harmonic index');
ylabel('ratio/ %');
grid on;

figure(2)
% 绘制 磁化强度随磁场强度变化曲线
labels = {'0*Amp_{ac}', '0.2*Amp_{ac}', '0.4*Amp_{ac}', '0.6*Amp_{ac}'};
subplot 221;
for i = 1:2:7
    j = (i+1)/2;
    plot(H_matric(i, :), M_H(i,:),'LineWidth', 0.5, 'DisplayName', labels{j});
    hold on;
    legend;
end 
xlim([-0.05,0.05])
% % 绘制磁化强度曲线
subplot 222;
for i = 1:2:7
    j = (i+1)/2;
    plot(t(1:10000), M_H(i, 1:10000), 'LineWidth', 0.5, 'DisplayName', labels{j});
    hold on;
    legend;
end
% 绘制外加磁场
subplot 223;
for i = 1:2:7
    j = (i+1)/2;
    plot(H_matric(i,1:10000), t(1:10000),'LineWidth', 0.5, 'DisplayName', labels{j});
    hold on;
    legend;
end
% 绘制信号
subplot 224;
for i = 1:2:7
    j = (i+1)/2;
    plot(t(1:10000), M_H_dif(i,1:10000),'LineWidth', 0.5, 'DisplayName', labels{j});
    hold on;
    legend;
end
% 绘制3次谐波 实部 虚部 幅值 相位  只显示相对大小及变化趋势。
figure(3)
fre_real_norm = 2*(fre_real(:,3)-min(fre_real(:,3)))/(max(fre_real(:,3))-min(fre_real(:,3)))-1;
plot(H_DC_ratio,fre_real_norm, 'LineWidth', 2);
hold on;
fre_imagine_norm = 2*(fre_imagine(:,3)-min(fre_imagine(:,3)))/(max(fre_imagine(:,3))-min(fre_imagine(:,3)))-1;
plot(H_DC_ratio,fre_imagine_norm*0.4, 'LineWidth', 1.5,'linestyle','--');
hold on;
phase_3_norm = 2*(phase_3(:,3)-min(phase_3(:,3))) / (max(phase_3(:,3)) - min(phase_3(:,3)))-1;
plot(H_DC_ratio,phase_3_norm*0.9, 'LineWidth', 2,'linestyle','--');
hold on;
plot((0:0.01:1.55), zeros(size((0:0.01:1.55))),  'LineWidth', 2, 'Color', 'k');
hold on;
plot(zeros(size((-1.1:0.01:1.1))),(-1.1:0.01:1.1),  'LineWidth', 2, 'Color', 'k');
legend( '3-har-real','3-har-imagine','3-har-phase','','');
axis off;
% 绘制0.5H_AC时3次谐波幅值
figure(4);
% x_categories = {'1f', '2f', '3f', '4f',  '5f', '6f',  '7f', '8f', '9f'};
stem(fre_Amplitude(50,:), 'filled', 'Marker', 'o', 'Color', 'g');
hold on;
plot(linspace(0,10,1000), zeros(1000),  'LineWidth', 2, 'Color', 'k');
hold on;
plot(zeros(1000),linspace(-1.1*max(fre_Amplitude(50,:)),1.1*max(fre_Amplitude(50,:)),1000),  'LineWidth', 2, 'Color', 'k');
xlabel('Harmonic Index');
ylabel('Amp');
title('0.5*H_{AC} bias Harmonic Amplitude Plot');
xlim([0, 10]);



