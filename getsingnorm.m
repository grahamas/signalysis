function [ norm ] = getsingnorm( dataline, singstims )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
LEN = length(singstims);

% Initialize array for averages.
avg = 1:LEN;

for i = 1:LEN
    STIMI = singstims(i);
    avg(i) = mean(dataline((STIMI - 2050):(STIMI - 50)));
end
norm = mean(avg);
end

