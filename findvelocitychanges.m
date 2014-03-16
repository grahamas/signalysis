function [ velchangeindices ] = findvelocitychanges( cartvel, threshold, idxwindow )
%FINDVELOCITYCHANGES Return indices of velocity changes
%   Detailed explanation goes here

velchangeindices = [];
for i=1:length(cartvel)-idxwindow
    if abs(cartvel(i) - cartvel(i + idxwindow)) > threshold
        velchangeindices = [velchangeindices, i, i+idxwindow];
    end
end

end

