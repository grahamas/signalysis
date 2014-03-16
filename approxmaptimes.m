function mask = approxmaptimes( map, timedata, error )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
mask = zeros(1, length(timedata));
for time=map
    newmask = abs(time-timedata) < error;
    mask = newmask | mask;
end

end

