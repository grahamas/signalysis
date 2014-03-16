function manycartvel2spec( movingwin, params, pairlist, threshold, velchangewindow, specwindow, rows )
%MANYCARTVEL2SPEC Takes a list (cartvel, data) and produces plots on cartvel2spec.
%   Detailed explanation goes here

numpairs = length(pairlist);
cols = numpairs / rows;

for i=1:numpairs
    pair = pairlist(i, :);
    subplot(rows, cols, i)
    cartvel2spec(movingwin, params, pair{1}, pair{2}, threshold, velchangewindow, specwindow)
end

end

