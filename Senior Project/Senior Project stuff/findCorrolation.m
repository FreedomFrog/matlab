function T = findCorrolation(varargin)
T = table;
for i = 1:length(varargin)
    Tbase = varargin{i};
    for j = 1:length(varargin)
        Thold = varargin{j};
        newThold = [Tbase.(1) interp1(Thold.(1),Thold.(2),Tbase.(1)]
    end
    
end