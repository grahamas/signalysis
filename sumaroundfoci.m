function focisum = sumaroundfoci( data, foci, window )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

numfoci = length(foci);
focidata = zeros(numfoci, 2 * window+1);

for i=1:numfoci
    focidata(i, :) = data((foci(i)-window):(foci(i)+window));
end

focisum = sum(focidata, 1);

end