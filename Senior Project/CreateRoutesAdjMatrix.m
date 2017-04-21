function [A] = CreateRoutesAdjMatrix(sourceAirport, destinationAirport,numAirports)

   A = zeros(numAirports);
    
    for i = 1:length(destinationAirport)
              
            if (isnan(sourceAirport(i)) || isnan(destinationAirport(i)))
                
            elseif(sourceAirport(i) > numAirports || destinationAirport(i) > numAirports)
                      
            else
                if (sourceAirport(i)==destinationAirport(i))
         
                else
                    A(sourceAirport(i),destinationAirport(i)) = A(sourceAirport(i),destinationAirport(i)) + 1;
                end
            end
       
    end
    
end