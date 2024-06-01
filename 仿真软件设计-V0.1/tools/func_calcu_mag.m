function out = func_calcu_mag(excited_field, par_diameter, sample_fre, relaxation_time, Excited_Fre, particle_model)
    H = excited_field;
    %% 基本参数设置
    D = par_diameter;     %磁粒子直径，单位为nm
    VT = 0.2*1e-6;       %溶液体积，单位为ul
    relaxation_time = relaxation_time;    %弛豫时间 （微秒）
    u0=4*pi*1e-7;   %真空磁导率
    MS=446000;      %粒子饱和磁化强度(A/m为单位)
    d_Fe3O4 = 5200;     %Fe3O4密度(Kg/m^3)
    m_Fe3O4 = 0.232;    %Fe3O4摩尔质量(Kg/mol)
    kB=1.38e-23;        %玻尔兹曼常数
    Tp = 300;       %温度

    %% 计算参数
    S = 9*1e-3/u0;      %接收灵敏度，单位为mT/A
    V=1/6*pi*D^3;       %磁粒子体积计算
    m_core = d_Fe3O4*V;         %磁粒子核质量
    N_Fe = m_core/m_Fe3O4*3;        %每个核中铁离子摩尔量
    momet=V*MS;     %磁矩
    Beta=u0*momet/(kB*Tp);     %系数β
    n_Fe = 25/56*1e3;      %溶液铁浓度，25 mg/mL
    c = n_Fe/N_Fe;      %溶液中四氧化三铁浓度
 %% 参数计算
    if strcmp(particle_model,"Langevin")
        out = c*momet*langevin(Beta*H/u0);      % 可选择不同粒子响应模型
    elseif strcmp(particle_model, "Step")
        out = c*momet*step_cur(Beta*H/u0, u0, MS);
    elseif strcmp(particle_model, "Linear")
        out = c*momet*linear_cur(Beta*H/u0, u0, MS);
    else
        disp("No particle model matching");
    end
    out = -u0*S*VT*out;      % 输出
    
    if relaxation_time ~= 0
        sample_point = floor(sample_fre/Excited_Fre);
        time_sequence = (1:sample_point)/sample_fre;
        r_t = (1/relaxation_time)*exp(-time_sequence/relaxation_time);
        out = conv(out, r_t, 'same');
    else 
        out = -out;
    end
%     deri_M_H = c*momet*Beta*deri_langevin(Beta*H/u0);  
    % 郎之万模型
    function out = langevin(xi)
        xi = xi+0.000001;
        out = coth(xi)-1./xi;
    end
     % 阶跃响应模型
    function out = step_cur(xi, u0, MS)
        max_value = max(max(xi));
        bias_ratio = 0.0;       % 偏置比
        xi(xi<max_value*bias_ratio) = -u0*MS;
        xi(xi>=max_value*bias_ratio) = u0*MS;
        out = xi;
    end
    % 线性响应模型
    function out = linear_cur(xi, u0, MS)
        max_value = max(xi);
        duty_cycle = 0.1;       %线性范围占比
        bias_ratio = 0.0;   % 偏执百分比
        xi = xi - bias_ratio*max_value;        % 给线性范围加上偏执
        xi(xi<-duty_cycle*max_value) = -max_value;       
        xi(xi>=duty_cycle*max_value) = max_value;
        %%%% 
        xi(xi>=-duty_cycle*max_value & xi<duty_cycle*max_value) = xi(xi>=-duty_cycle*max_value & xi<duty_cycle*max_value)/(duty_cycle); 
        out = xi; 
    end
    function out = deri_langevin(xi)
        if xi == 0
            out = 1/3;
        else 
            out = (1./xi-1./(sinh(xi).^2));
        end
    end

end