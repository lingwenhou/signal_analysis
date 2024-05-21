function out=calculate_para(excited_field, par_diameter)
    H = excited_field;
    %% 基本参数设置
    D = par_diameter;     %磁粒子直径，单位为nm
    VT = 0.2*1e-6;       %溶液体积，单位为ul
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
    %% 粒子磁化
    out = c*momet*langevin(Beta*H/u0);      % 可选择不同粒子响应模型
    out = u0*S*VT*out;      % 输出
    % 郎之万模型
    function out = langevin(xi)
        xi = xi+0.000001;
        out = coth(xi)-1./xi;
    end

end