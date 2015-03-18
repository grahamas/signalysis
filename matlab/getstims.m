function stims = getstims( data, thresh )
%GETSTIMS Takes data and threshold and returns stimulus indices.
%   Detailed explanation goes here

indices = 1:length(data);
stims = indices(data > thresh);

end

