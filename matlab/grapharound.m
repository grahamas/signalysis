function grapharound( locus, data, lowch, highch, dimm, dimn )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
FREQ = 30000;
YLIM = 3000;
STIMCH = 85;
XLOW = locus - 10*FREQ;
XHIGH = locus + 10*FREQ;

x=500;
y=500;
width=1500;
height=750;

hFig = figure(1);
set(hFig, 'Position', [x y width height])

title(strcat('Second Number  ', num2str(locus/30000)))
for i = lowch:highch
    subplot(dimm, dimn, i)
    plot(data(i,XLOW:XHIGH), 'color', 'b')
    ylim([-YLIM YLIM])
    xlim([XLOW XHIGH])
    title(strcat('Channel  ', num2str(i)))
    hold on;
    plot(data(STIMCH,XLOW:XHIGH), 'color', 'r')
end

end

