function cartvel2spec_wrand( movingwin, params, rawcartvel, data, threshold, velchangewindow, specwindow )
%CARTVEL2SPEC Processes NSx data matrix and cartvel struct to find velspikes
%and plot a specsum around them
%   Detailed explanation goes here

cartvel = cartvelcell2mat(rawcartvel);
velchangeindices = findvelspikes(cartvel, threshold, velchangewindow);

hypvsrand_spec(movingwin, params, velchangeindices, data, specwindow)

end

