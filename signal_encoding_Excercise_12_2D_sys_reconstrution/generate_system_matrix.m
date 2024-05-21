%% sm重建学习
% 可在calculate_para中选择不同的粒子响应模型 langevin 理想阶跃 线性模型
%% 参数设置
function generate_system_matrix(particle_diameters, sample_rate,Drive_Amp, Drive_x_fre, Drive_y_fre,Gradient_x)
    %% 信号生成
    [signal_total_matric, signal_x_matric, signal_y_matric] = calculate_signal(0, sample_rate, Drive_Amp, particle_diameters,Gradient_x, Drive_x_fre, Drive_y_fre, 0);
    %% 傅里叶变换
    % x轴向
    out_fre_Amplitude_x_matric = zeros(size(signal_total_matric, 1), size(signal_total_matric, 2), size(signal_total_matric, 3)/2+1);
    out_fre_Phase_x_matric = zeros(size(signal_total_matric, 1), size(signal_total_matric, 2), size(signal_total_matric, 3)/2+1);
    % y轴向
    out_fre_Amplitude_y_matric = zeros(size(signal_total_matric, 1), size(signal_total_matric, 2), size(signal_total_matric, 3)/2+1);
    out_fre_Phase_y_matric = zeros(size(signal_total_matric, 1), size(signal_total_matric, 2), size(signal_total_matric, 3)/2+1);

    % 傅里叶变换
    f = sample_rate/size(signal_total_matric, 3)*(0:size(signal_total_matric, 3)/2);    % 频点

    for i = 1:size(signal_total_matric,1)
        for j = 1:size(signal_total_matric,2)
    %         [out_fre_Amplitude_total_matric(i,j,:), out_fre_Phase_total_matric(i,j,:)] = signal_fft(signal_total_matric(i,j,:), size(signal_total_matric,3));
            [out_fre_Amplitude_x_matric(i,j,:), out_fre_Phase_x_matric(i,j,:)] = signal_fft(signal_x_matric(i,j,:), size(signal_x_matric,3));
            [out_fre_Amplitude_y_matric(i,j,:), out_fre_Phase_y_matric(i,j,:)] = signal_fft(signal_y_matric(i,j,:), size(signal_y_matric,3));
        end
    end
    %% 计算频率能量
    % show_fre_range = 30e3;
    % index_fre_range = find(ismember(f,show_fre_range));
    % energy_x = zeros(1, index_fre_range);
    % energy_y = zeros(1, index_fre_range);
    % for i = 1:index_fre_range
    %     energy_x(i) = calculate_SFenergy(out_fre_Amplitude_x_matric(:,:,i));
    %     energy_y(i) = calculate_SFenergy(out_fre_Amplitude_y_matric(:,:,i));
    % end
    % figure(1)
    % plot((1:index_fre_range)/10, energy_x);
    % hold on;
    % plot((1:index_fre_range)/10, energy_y);

    figure(2)
    imshow(abs(out_fre_Amplitude_x_matric(:,:,65)),[]);
    save './out_data/system_matrix_x' out_fre_Amplitude_x_matric;
    save './out_data/system_matrix_y' out_fre_Amplitude_y_matric;
    %% 单独绘制 2D 一个接收向的SM
    % 绘制 x接收
    figure(3)
    per_index = 32;
    for index_show = 1:per_index
    %     sum_xy = find(ismember(f, index_show*Drive_x_fre));
        subplot(4, per_index/4, index_show);
        imshow(abs(out_fre_Amplitude_x_matric(:,:,index_show+1)),[]);
        hold on;
    end
    % 绘制y接收
    figure(4)
    for index_show = 1:per_index
        subplot(4, per_index/4, index_show);
        imshow(abs(out_fre_Amplitude_y_matric(:, :, index_show+1)), []);
        hold on;
    end
    %% 绘制展示 2D SM index_show_x index_show_y 表示不同的混频因子
    % figure(5)
    % index_num = 8;
    % for index_show_x = 1:index_num
    %     for index_show_y = 1:index_num
    %         
    %         if index_show_x == 1 && (index_show_y == 1)
    %             continue;
    %         else
    %             sum_xy = find(ismember(f, (index_show_y-1)*Drive_y_fre+(index_show_x-1)*Drive_x_fre));
    %             subplot(index_num*2, index_num, (index_show_y-1)*(index_num*2)+index_show_x);
    %             imshow(abs(out_fre_Amplitude_x_matric(:,:,sum_xy)),[]);
    %             subplot(index_num*2, index_num, (index_show_y-1)*(index_num*2)+index_show_x + index_num);
    %             imshow(abs(out_fre_Amplitude_y_matric(:,:,sum_xy)),[]);  
    %         end 
    %         hold on;
    %     end
    % end

end

