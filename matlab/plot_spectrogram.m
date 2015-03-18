function plot_spectrogram( data, movingwin, params,  window, focus)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
[S1, t, f] = mtspecgramc(double(data(focus-window:focus+window, :)), movingwin, params); plot_matrix(S1, t, f)

end

