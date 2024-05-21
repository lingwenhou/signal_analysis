function x = kzReconstruction(A,b,iterations,lambd,shuff,enforceReal,enforcePositive)
% INPUT - A: system matrix
%         b: signal
%         e0: termination condition of iteration
%         maxiteration: 迭代次数  
%         error: x 和 ecact_x每次迭代时的差值
%         miu：步长
% OUTPUT - x: the solution of the liear equation
% x^(k+1) = x^k + lambda * AT(b - A(x))/ATA
[N, M] = size(A);
x = complex(zeros(N,1)); 
% residual = complex(zeros(M,1));
rowIndexCycle = 1:M;

% calculate the energy of each frequency component
energy = rowEnergy(A);

% may use a randomized Kaczmarz
if shuff
    rowIndexCycle = randperm(M);
end

for l = 1:iterations
    for m = 1:M
        k = rowIndexCycle(m);
        
        tmp = A(:,k).'*x;
        beta = (b(k) - tmp) / energy(k)^2;
        x = x + lambd*beta*conj(A(:,k));
    end
    if enforceReal && ~isreal(x)
        x = complex(real(x),0);
    end
    if enforcePositive
        x(real(x) < 0) = 0;
    end
end

end

