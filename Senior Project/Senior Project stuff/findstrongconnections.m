function findstrongconnections(A)
  
  nruns = length(A);                      % number of runs
  total = zeros(nruns,1);         % number of strongly connected components 
  totalsingles = zeros(nruns,1);  % number of strongly connected components made of a single node
  inactive_edges = 0;             % number of cells with value zero in the graph matrix
  for d = 1:nruns
    

    REAL = A;                      

    index = 1;                   % initialize index at 1 (first node/neuron visited will have index==1)
  
    j = 1;                       % j points to first empty cell from the top in STACK
    q = 1;                       % q points to the cell where you insert a newly visited edge/synapse
    neur = length(A);
    n = neur*neur;
    STACK = cell(2,n);           % a cell array with 2 rows, each of size n (tot. # of edges/synapses).
    
    INSTACK = zeros(1,neur);     % if a node/neuron neur is in STACK, INSTACK(neur)>0
    ADDED = zeros(1,neur);       % if a node/neuron neur participates in a component, ADDED(neur)==1
  
    SUCCESSORS = cell(2,n);      % a stack containing all synapses visited in order, used for backtracking
    FLAG = zeros(1,neur);        % FLAG(neur)==1 if neuron neur has neighbors
  
    INDEX = zeros(1,neur);       % matrix that will store indexes for each node/neuron
  
    LOWLINK = zeros(1,neur);     % matrix that will store lowlink for each node/neuron
     
    CONTAINER = [];              % container holding all strongly connected components found
    INTER = {'/B';'/B'};         % separates components in the container as they are concatenated 
    totcomponents = 0;           % count of all strongly connected components found
    totlonely = 0;               % count of strongly connected components of size one
      
      %START THE EXPLORATION (we start on node/neuron #1 - the first row of the input matrix)
      for r=1:neur  
         % Each unvisited node/neuron is assigned a unique integer index, which numbers them in the order in which they are discovered
         % IF CURRENT NODE WAS NEVER VISITED
         if INDEX(r)==0
              %assign it a unique integer index
              INDEX(r) = index;
              %lowlink represents the smallest index of any node/neuron known to be reachable from r, including r itself
              LOWLINK(r) = index;
              index = index + 1;
          % FIND FIRST AVAILABLE OUTGOING EDGE LEAVING FROM IT (from node #r)
            for c=1:neur         
             if ~(REAL(r,c) == 0)               % did we just find a nonzero active edge/synapse leaving from node/neuron #r?
                FLAG(r)=1;                        % node/neuron #r has at least one neighbor!
                % IF AND ONLY IF THIS EDGE TAKES US TO AN UNVISITED SUCCESSOR, PUSH IT IN THE STACK
                if INDEX(c)==0           
                    % push this edge/synapse taking us to the successor in the STACK
                    STACK{1,j}= r;            % node/neuron the edge leaves from
                    STACK{2,j}= c;            % node/neuron the edge leads to
                    j=j+1;                    % points to current top+1
                    INSTACK(r)=INSTACK(r)+1;  % updates how many times the node/neuron r is in the STACK
                    SUCCESSORS{1,q}= r;
                    SUCCESSORS{2,q}= c;
                    q=q+1;
                    row=c;                    %go to neighbor c of node/neuron r, which is row c  
                    
                  while (true)
                    colindex=1;        
                      while colindex <= neur
                          %THE SUCCESSOR WE ARE TAKEN TO WAS NEVER VISITED: assign it an index and lowlink
                          if INDEX(row)==0 
                                  INDEX(row) = index;
                                  LOWLINK(row) = index;
                                  index = index + 1;
                          end
                          % FIND OUT IF THIS MOST RECENTLY VISITED NODE HAS OUTGOING EDGES
                          if ~(REAL(row,colindex) == 0) %if node/neuron row has an outgoing edge/synapse 
                              FLAG(row)=1;              %record that neuron row has neighbors
                              %IF THERE IS AN OUTGOING EDGE THAT GOES TO AN UNVISITED NODE, PUSH IT THE STACK
                              if INDEX(colindex) == 0               %if it does, push this edge in STACK and SUCCESSORS
                                  STACK{1,j}= row;
                                  STACK{2,j}= colindex;
                                  j=j+1; 
                                  INSTACK(row)=INSTACK(row)+1;      % records neuron row's presence in stack
                                  SUCCESSORS{1,q}= row;
                                  SUCCESSORS{2,q}= colindex;
                                  q=q+1;
                                  %UPDATE THAT WE FOLLOWED THIS EDGE AND WE ARE IN A NEW NODE
                                  row = colindex; 
                                  colindex=0;  
                                  
                              %ELSE, IF THE NODE WAS ALREADY VISITED: UPDATE ITS LOWLINK                  
                              else if INSTACK(colindex) > 0                               %if it is already in STACK
                                    LOWLINK(row) = min(LOWLINK(row), INDEX(colindex));  %update its lowlink
                                  end
                              end      
                          end
                          colindex=colindex+1;   
                      end %end "while colindex<=neur"
                      flag=0; 
                      
                      %WE FINISHED VISITING EVERY SUCCESSOR OF A NODE: DID WE FIND A STRONGLY CONNECTED COMPONENT?
                      
                      % YES: iF the index of the node where the exploration started equal to its lowlink.
                      if LOWLINK(row) == INDEX(row)           
                        flag=1;                              
                        COMPONENT = cell(2,1);              %create a container for one strongly connected component
                        p=1;                                %points to next available empty cell in container
                            if INSTACK(row) == 0            %if neuron row is not present in the STACK
                                  
                                  COMPONENT{1,p}= row;        %put it in its own component
                                  COMPONENT{2,p}= 0;
                                  ADDED(row)=1;
                                  totlonely=totlonely+1;      %we found a component made out of a single node
                            else if FLAG(row)<1              %if neuron row has no neighbors
                                      COMPONENT{1,p}= row;    %put it in its own component
                                      COMPONENT{2,p}= 0;
                                      INSTACK(row) = 0;
                                      ADDED(row)=1;
                                      totlonely=totlonely+1;  %we found a component made out of a single node
                            else   
                                    %REMOVE THE STRONGLY CONNECTED COMPONENT FROM THE STACK                     
                                    while (1)
  
                                            if j>1            %when j==1 the STACK is empty;
                                              j= j-1;
                                            end

                                          w1 = STACK{1,j};              % the node where the edge leaves from, on top of STACK 
                                          w2 = STACK{2,j};              % the node where the edge leads to, on top of STACK 
                                          INSTACK(w1) = INSTACK(w1)-1;  % record this edge/synapse was taken out of STACK
                                          STACK{1,j} = [];              % pop from stack
                                          STACK{2,j} = [];              % pop from stack
  
                                          %add popped edge to current strongly connected component
                                          COMPONENT{1,p} = w1;
                                          ADDED(w1)=1;                  
                                          COMPONENT{2,p} = w2;
                                          p=p+1; 
                                          %stop popping edges/synapses from STACK when the strongly connected component is entirely ejected
                                            if w1 == row && INSTACK(w1) == 0  
                                              break;
                                            end
                                    end
                              end % end else if
                            end   %if INSTACK(row) == 0 
                            CONTAINER = [CONTAINER,INTER,COMPONENT];   %embed this component in the container of all components found
                            totcomponents=totcomponents+1;
                      end %if LOWLINK(row) == INDEX(row)
                      %WE FINISHED REMOVING THE STRONGLY CONNECTED COMPONENT WE FOUND 
                                           
                                      %MOVE ON TO FIND THE NEXT DESCENDANT
                                      if j==1
                                          break
                                      end
                                      if q==1
                                          break
                                      end
                                      if flag==1                      %if neuron #row is not present in the STACK
                                          caller = SUCCESSORS{1,q-1}; %backtrack 
                                          q=q-1;
                                          LOWLINK(caller) = min(LOWLINK(caller), LOWLINK(row));
                                              if j>1                  %when j==1 the STACK is empty
                                                  j= j-1;
                                              end
                                          INSTACK(caller) = INSTACK(caller)-1;
                                          STACK{1,j} = [];            % pop from stack
                                          STACK{2,j} = [];            % pop from stack
                                          row = caller;               % go to the node/neuron you backtracked to
                                          
                                        else                          
                                          caller = SUCCESSORS{1,q-1}; %backtrack
                                          q=q-1;
                                          LOWLINK(caller) = min(LOWLINK(caller), LOWLINK(row));
                                          row = caller;               % go to the node/neuron you backtracked to
                                      end                   
                  end  %end "while(true)"
                end %end "if INDEX(c)==0"   
              end %end "if ~(REAL(r,c)==0)"   
              if c==neur && ADDED(r)== 0         %if we visited all of neuron #c's neighbors and neuron #r is not part of any component
                          COMPONENT = cell(2,1); 
                          COMPONENT{1,1}= r;     %put neuron #r in its own component
                          COMPONENT{2,1}= 0;
                          ADDED(r)=1;
                          totlonely=totlonely+1;
                          INSTACK(r) = 0;        %record that neuron #r is not present in STACK
                          CONTAINER = [CONTAINER,INTER,COMPONENT];
                          totcomponents=totcomponents+1;           
              end
            end %end "for c=1:neur"
        end %end "if INDEX == 0"
      end %end exploration "for r=1:neur"
      total(d,1)=totcomponents;
      totalsingles(d,1)=totlonely;
  end  %end nruns
  
  figure 
  hold on
  
  subplot(2,2,1);
  plot(total,'.');
  xlabel('runs');
  ylabel('strongly connected components')
  title('1000x1000 sparse, PARTIAL RANDOM adjacency matrix')
  hold on
  
  
  subplot(2,2,2);
  plot(totalsingles,'r.');
  xlabel('runs');
  ylabel('single-node components')
  title('1000x1000 sparse, PARTIAL RANDOM adjacency matrix')
  hold on
  
end
  %{
  % for visually comparing two different graphs uncomment this
  subplot(2,2,3);
  plot(total,'.');
  xlabel('runs');
  ylabel('strongly connected components')
  title('1000x1000 sparse, PARTIAL MOTIF adjacency matrix')
  hold on
  
  
  subplot(2,2,4);
  plot(totalsingles,'r.');
  xlabel('runs');
  ylabel('single-node components')
  title('1000x1000 sparse, PARTIAL MOTIF adjacency matrix')
  hold on
 %}