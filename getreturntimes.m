function returntimes = getreturntimes( bmistate )
%GETRETURNTIMES Returns a one dimensional array of the times associated
%with the end of a sequence of 'return' states. BMIState input.
%   Detailed explanation goes here
returntimes = [];
bmistate = reshape(bmistate, 3, length(bmistate)/3);
time = double(cell2mat(bmistate(2,:)) - cell2mat(bmistate(2,1))) + (double(cell2mat(bmistate(3,:))) .* 10^(-9));
for i = 2:(length(bmistate)-1)
    if (strcmp(bmistate(1,i),'return') && strcmp(bmistate(1,i-1),'return') && ~strcmp(bmistate(1,i+1),'return'))
        returntimes = [returntimes, time(i)];
    end
end
end

