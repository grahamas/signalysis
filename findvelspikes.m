function [ velchangeindices ] = findvelspikes( cartvelmat, threshold, idxwindow )
%FINDVELOCITYCHANGES Return indices of velocity increases above threshold.
%   Detailed explanation goes here

velchangeindices = [];
i=1;
while i < length(cartvelmat)-idxwindow
    if (cartvelmat(i) - cartvelmat(i + idxwindow)) > threshold
        velchangeindices = [velchangeindices, i+(round(idxwindow/2))];
        i = i+idxwindow;
    else
        i = i+1;
    end
end

end

