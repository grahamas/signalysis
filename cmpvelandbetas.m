function [h, p] = cmpvelandbetas( vel, lfp, params, movingwin )
%CMPVELANDBETAS Summary of this function goes here
%   I'm going to be mean and put low and high thresholds in params

% First things first: Convert the vel struct to a matrix
% Works for cartvel and eigenderiv
vels_and_times = cartvelcell2mat(vel);

% Isolate the velocities
vels = vels_and_times(:,1);

% Isolate the velocity times
times = vels_and_times(:,2) - params.time_correction;
err = times(1)

% Next we need to get the timestamps of interest.
[vci, h_sd, l_sd] = velchangeindices(vels, params);
lvci = length(vci)
% for v=1:lvci
%     hold on
%     cent = vci(v);
%     left = params.lowvel_window;
%     right = params.highvel_window;
%     plot(abs(vels(cent-left:cent+right)))
%     plot([1, left], [l_sd, l_sd])
%     plot([left, right+left], [h_sd,h_sd])
%     pause
%     hold off
% end
%for i=1:length(vci)
%    plot(vels(vci(i)-10:vci(i)+10))
%    pause
%end

% Now we want to map vci to the matching indices
lfpindices = 1:length(lfp);
lfptime = 0:.0005:(length(lfp)-1)/2000;
lfpmask = approxmaptimes(times(vci), lfptime, .00029);

events = lfpindices(lfpmask);

rad = params.radius;
chs = params.chs;

results = zeros(length(chs), 4);
all = [];

for chdx = 1:length(chs)
    thistest = [];
    for evdx = 1:length(events)
        event = events(evdx);
        [S, t, f] = mtspecgramc(double(lfp(chs(chdx),event-rad:event+rad)), movingwin, params);
        %plot_matrix(S, t, f);
        %pause
        betabool = (12 < f & f < 30);
        pre = mean(mean(S(t<=(rad*.0005),betabool),2),1);
        post = mean(mean(S(t>(rad*.0005), betabool),2),1);
        thistest = [thistest; pre,post];
        all = [all; pre, post];
    end
    [h,p] = ttest(thistest(:,1), thistest(:,2));
    results(chdx,:) = [h,p, mean(thistest(:,1),1), mean(thistest(:,2),1) ];
end

'By channel'
results

'Total results'
[h,p, ci, stats] = ttest(all(:,1), all(:,2), 'Tail', 'right')

'Avg results'
[h,p, ci, stats] = ttest(results(:,3), results(:,4), 'Tail', 'right')

% 'Against'
% [h,p] = ttest(all(1:10,1)-all(1:10,2), all(11:20,1)-all(11:20,2))


end

