function graphstims( data, stimdex, len )
%GRAPHSTIMS Graphs data around stims, found in stimdex
%   Detailed explanation goes here

for i = 1:len
    if data(stimdex, i) > 150
        grapharound( i, data, 1, 32, 4, 8)
        i = i + 1000;
        pause
    end
end

end

