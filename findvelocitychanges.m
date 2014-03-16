function [ velchangeindices ] = findvelocitychanges( cartvel, threshold, idxwindow )
%FINDVELOCITYCHANGES Return indices of velocity changes
%   Detailed explanation goes here

velchangeindices = [];
i=1;
while i < length(cartvel)-idxwindow
    if abs(cartvel(i) - cartvel(i + idxwindow)) > threshold
        velchangeindices = [velchangeindices, i+(round(idxwindow/2))];
        i = i+idxwindow;
    else
        i = i+1;
    end
end

end

