function partplot( data, step, ylimit )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
YLIM = ylimit;
XPOS = 500;
YPOS = 500;
WIDTH = 2000;
HEIGHT = 1000;

hFig = figure(1);
set(hFig, 'Position', [XPOS YPOS WIDTH HEIGHT]);

endpts = (step + 1):step:length(data);

for pt = endpts
    plot((pt-step):pt, data((pt - step):pt))
    xlim([pt-step, pt])
    ylim([-YLIM, YLIM])
    pause
end

end

