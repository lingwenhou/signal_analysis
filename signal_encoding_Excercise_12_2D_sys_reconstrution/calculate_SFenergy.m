function cal_energy = calculate_SFenergy(system_a)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
cal_energy = sqrt(sum(abs(system_a.*system_a), 'all'));
end

