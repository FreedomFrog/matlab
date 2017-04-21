%% Senior Project 9/21 Tony Jaeger
% Pull routes data from openair.org and any other data you wish to explore
% From there, we will remove any routes which do not have destinations or 
% starting points.  This might be a situation where this information was 
% simply omitted, or not fully recorded for security or other reasons
[A,H] = zeroelimiator;
% A is the orginal matrix, G is the matrix after removing these
% undesirables
figure(1)
spy(A)
figure(2)
spy(G)

%% 
[J,D] = dimentionwitheigenvalue1(G,H);
%check this
%% We have the first connected web here!
set(0,'RecursionLimit',3187)
% Originally we used [visitedVertices] = traversal([], 1, G); However, this
% does not give every component. A "source" would not be included unless it
% was the beginning node, which we cannot garuntee. 
[visitedVertices] = traversal([], 1, G + G');
F = sort(visitedVertices);
missing=findMissing(F)
[J] = findComponents(missing,G)
%The findComponents function will give us the disconnected component nodes
%% Now we need to get M = (1-m)A + mS from G
S = ones(length(G))/length(G);
m = .15;
M = (1-m)*G + m*S;

[V,D] = eig(M);
k = find(abs(V-1) < 0.01)
K = det(eye(length(G))-M);
