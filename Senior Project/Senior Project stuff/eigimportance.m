function [q] = eigimportance(A, m, i)
q = zeros(length(A),i);
s(1:length(A),1) = 1/length(A);
q(:,1) = s;


for j = 2:i
    q(:,j) = (1-m)*A*q(:,j-1)+m*s;
    q(:,j) = q(:,j)/sum(q(:,j));
    
end
