function plotmanystims( data, channels, stims, prestim, poststim, rownum, colnum, norms, delta )
%PLOTMANYSTIMS Calls plot stims on all channels, pre/poststims in ms
XPOS = 500;
YPOS = 500;
WIDTH = 1800;
HEIGHT = 950;

hFig = figure(1);
set(hFig, 'Position', [XPOS YPOS WIDTH HEIGHT]);
for i = 1:length(channels)
    subplot(rownum, colnum, i)
    plotstims_nofig(data, channels(i), stims, prestim, poststim, norms, delta)
end

end

