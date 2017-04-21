function [A,H] = zeroelimiator
load('Airlines.mat')
load('Airports.mat')
load('Routes.mat')
A=CreateRoutesAdjMatrix(SourceAirportID,DestinationAirportID,length(AirportID));
B = zeros(1);
while length(A) ~= length(B)
 B = A;
  X=sum(B);
  Y=find(X);
  C = B(:,Y);
  A = C(Y,:);
  
end
H = sum(A);
%spy(G)
%sum(diag(G))
