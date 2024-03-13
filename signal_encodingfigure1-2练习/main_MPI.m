%% 理解MPI使用
clear
clc;
close all;
%% 激励场设置
t = 0:1e-8:5*1/(25e3);  %采样率为100Ms/s
Excited_Amplitute = 50e-3;      % 激励幅值
Excited_Fre = 25e3;             % 激励频率
H = Excited_Amplitute * sin(2*pi*Excited_Fre*t);    % 余弦激励 激励场幅值50mT  频率 25kHz
% H = Excited_Amplitute*sawtooth(2 * pi * Excited_Fre * t, 0.5);  % 三角波激励 激励场幅值50mT  频率 25kHz
particle_diameters = [10, 15, 20, 25];      % 粒径
%%
M_H = zeros(length(particle_diameters), length(H));
M_H_dif = zeros(length(particle_diameters), length(H)-1);
df = zeros(length(particle_diameters), length(H));
for i = 1:length(particle_diameters)
    [M_H(i,:), df(i,:)] = calculate_para(H, particle_diameters(i)*1e-9);
    M_H_dif(i,:) = diff(M_H(i,:));        
end

Y = signal_fft(M_H_dif(1,:), length(M_H_dif(1,:)));
f = 1e8*(0:length(M_H_dif(1,:))/2)/length(M_H_dif(1,:));
fre_amplitude = Y((find(ismember(f(1:100)/25e3, [1, 2, 3, 4, 5, 6, 7, 8, 9]))));
%%
figure
% 绘制 磁化强度随磁场强度变化曲线
subplot 231;
plot(H, M_H(3,:),'LineWidth', 1.5);
hold on;
plot(H(1:5000), 0.98*abs(M_H_dif(3,1:5000))*(max(M_H(3,:))/max(M_H_dif(3,1:5000))),'LineWidth', 1.5);

% axis off;
% % 绘制磁化强度曲线
subplot 232;
plot(M_H(3,1:10000),'LineWidth', 1.5);

% 绘制信号
subplot 233;
plot(t(1:10000), M_H_dif(3,1:10000),'LineWidth', 1.5);

% 绘制外加磁场
subplot 234;
plot(H(1:10000), t(1:10000),'LineWidth', 1.5);

% 绘制频谱图
subplot 236;
bar(fre_amplitude, 'k', 'BarWidth', 0.01);
categories = {'1', '2', '3','4', '5','6', '7','8', '9'};
xlim([0.5, length(fre_amplitude)+0.5]);
ylim([0, 1.2*max(fre_amplitude)]);
xticklabels(categories);
xlabel('f/f_0');
ylabel('Amplitude');

% position = find(ismember(f(1:100)/25e3, [1,3,5,7,9]));
% result = Y(position);
% for i = 1:length(result)  
%     plot([i,i], [0,result(i)], 'k-');
%     hold on;
% end 
% xlim([0, length(result)+1]);
% ylim([0, 1.2*max(result)]);
% plot(f(1:100)/25e3,Y(1:100), 'k-');
% displayname = strcat(num2str(particle_diameters(i)), 'nm');
% % 绘制磁化强度随信号变化曲线
% subplot 131;
% plot(t*1e6,M_H,'LineWidth',1,'DisplayName',displayname);
% grid on;
% xlabel("T/(us)");
% ylabel("M/(A/m)");
% legend('Location', 'northwest');
% % 绘制生成信号
% subplot 132;
% plot(t(1:length(t)-1)*1e6, M_H_dif,'LineWidth',1, 'DisplayName',displayname);
% xlabel('T/us');
% ylabel('A/v');
% legend('Location', 'northwest');
% 
% subplot 133;
% plot(H(2:20001)*1000,abs(M_H_dif(:,1:20000)),'LineWidth',1, 'DisplayName',displayname);
% xlabel("H/(mTu_0^{-1})");
% ylabel("dM/dH");
% 
% %     set(gca, 'YTick', []);
% legend('Location', 'northwest');
% hold off;
% fft 观察信号频谱
% figure(2)
% plot(M_H(3,1:6000));