function [J,D] = dimentionwitheigenvalue1(G,H)
J = zeros(length(H));
for i = 1:length(H)
    
    for k = 1:length(H)
        J(i,k) = G(i,k) * 1/H(1,k);
    end
    
end

D = eig(J);

%F = 0;
%for i = 1:length(D)
%    if D == 1
%        F = i;
%    end
%end
%C = V(F,:);
%
%kron(eye(length(J)),J);
%http://strategic.mit.edu/docs/matlab_networks/simple_spectral_partitioning.m