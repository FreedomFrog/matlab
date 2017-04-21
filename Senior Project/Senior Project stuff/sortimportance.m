function [v] = sortimportance(r)
v = [0 0; 0 0; 0 0; 0 0];
 f = sort(r,'descend');
 for i = 1:4
 v(i,2) = f(i,1);
 end
for i = 1:length(r)
   if v(1,2)== r(i)
       v(1,1)=i;
   elseif v(2,2)==r(i)
       v(2,1)=i;
   elseif v(3,2)==r(i)
       v(3,1)=i;
   elseif v(4,2)==r(i)
       v(4,1)=i;
   else
   end
end