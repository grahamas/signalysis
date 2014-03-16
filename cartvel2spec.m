function cartvel2spec( movingwin, params, rawcartvel, data, threshold, velchangewindow, specwindow )
%CARTVEL2SPEC Processes NSx data matrix and cartvel struct to find velspikes
%and plot a specsum around them
%   Detailed explanation goes here

cartvel = cartvelcell2mat(rawcartvel);
velchangeindices = findvelocitychanges(cartvel, threshold, velchangewindow);

datalen = length(data);
randindices = round(rand(1, length(velchangeindices)) .* length(data));

hypvsrand_spec(movingwin, params, velchangeindices, data, specwindow)

end

