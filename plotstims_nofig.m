function plotstims_nofig( data, channel, stims, prestim, poststim, norms, delta)
%PLOTSTIMS_NOFIG Helper function, does not create fig, pre/poststim in ms
%   Detailed explanation goes here
hold all
for i = 1:91:(length(stims)-90)
    locus = stims(i);
    plot(-prestim:(1/30):poststim, data(channel,(locus-(30*prestim)):(locus+(30*poststim))))
end
norm = norms(channel);
line([-prestim poststim], [norm norm]);
line([-prestim poststim], [norm-delta norm-delta]);
line([-prestim poststim], [norm+delta norm+delta]);
xlabel('Time (msec)')
ylabel('Amplitude (uV)')
xlim([-prestim poststim])
title(strcat('Channel-', num2str(channel)))
hold off

end

