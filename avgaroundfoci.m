function focimean = avgaroundfoci( data, foci, window )
%AVGAROUNDFOCI Actually takes the AVERAGE of windows around foci
%   

numfoci = length(foci);
focidata = zeros(numfoci, 2 * window+1);

for i=1:numfoci
    focidata(i, :) = data((foci(i)-window):(foci(i)+window));
end

focimean = mean(focidata, 1);

end