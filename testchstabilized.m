function [ stabilized ] = testchstabilized( dataline, avg, stims, stimstep, delta )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

singstims = stims(1:stimstep:end);
stabilized = 1:length(singstims);

stimstabilized = 1:5000;
avgs = int16(repmat(avg, 9, 1))';

for j = 1:length(singstims)
    stim = singstims(j);
    for i = 1:5000
        stimstabilized(i) = all(abs(dataline((stim+i):(stim+i+8)) - avgs) < delta);
    end
    stabilized(j) = any(stimstabilized);
end



end

