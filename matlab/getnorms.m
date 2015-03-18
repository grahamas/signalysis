function [norms] = getnorms( data, stims, stimstep )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sz = size(data);
LINES = sz(1);
norms = 1:LINES;

singstims = stims(1:stimstep:end);


for i = 1:LINES
    norms(i) = getsingnorm(data(i,:), singstims);
end

end

