function cartvel2spec( movingwin, params, rawcartvel, data, threshold, velchangewindow, specwindow )
%CARTVEL2SPEC Plots a spectrogram of avg of windows around cartvel spikes
%   Detailed explanation goes here

cartvel = cartvelcell2mat(rawcartvel);
velchangeindices = findvelspikes(cartvel, threshold, velchangewindow);

if length(velchangeindices) == 0
    print('No valid spikes')
end

hyp_spec(movingwin, params, velchangeindices, data, specwindow)

end

