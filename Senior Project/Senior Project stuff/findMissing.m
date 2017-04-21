function [difference] = findMissing(vertices)
    difference=[];
    for i=1:length(vertices)-1
        if vertices(i+1)-vertices(i) > 1
            for j=vertices(i)+1:vertices(i+1)-1
                difference(length(difference)+1)=j;
            end
        end
    end
end