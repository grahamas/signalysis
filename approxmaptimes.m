function mask = approxmaptimes( map, timedata, error )
%APPROXMAPTIMES Returns a mask with 1 at indices close to map times in the
%timedata. Error says how close they must be.
%   Detailed explanation goes here
mask = zeros(1, length(timedata));
for time=map
    newmask = abs(time-timedata) < error;
    mask = newmask | mask;
end

end

