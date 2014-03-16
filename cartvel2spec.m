function cartvel2spec( movingwin, params, rawcartvel, data, threshold, velchangewindow, specwindow )
%CARTVEL2SPEC Plots a spectrogram of avg of windows around cartvel spikes
%   Detailed explanation goes here

cartvel = cartvelcell2mat(rawcartvel);
velchangeindices = findvelspikes(cartvel, threshold, velchangewindow);

hyp_spec(movingwin, params, velchangeindices, data, specwindow)

end

