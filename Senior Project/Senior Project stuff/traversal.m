function [visitedVertices] = traversal(visitedVertices, starting, graph)
    if any(abs(starting-visitedVertices)<.1)
    else
        visitedVertices(length(visitedVertices)+1)=starting;
        for i=1:length(graph)
            if graph(starting,i) > 0
                visitedVertices = traversal(visitedVertices, i, graph);
            end
        end
    end
end