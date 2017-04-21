function [components] = findComponents(vertices, G)
components = [];

for i = 1:length(vertices)-1
    [visitedVertices] = traversal([], vertices(i), G + G');
    if numel(visitedVertices)==1
        components = [components; visitedVertices(1)];
    else if visitedVertices(1) < visitedVertices(2:numel(visitedVertices))
        components = [components; visitedVertices(1)];
        end
    end
end