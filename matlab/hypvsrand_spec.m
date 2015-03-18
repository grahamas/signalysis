function hypvsrand_spec( movingwin, params, interestindices, data, window)
%HYPVSRAND_SPEC Plots two spectrograms, one of interest, the other random
%   

numpts = length(interestindices);
datalen = length(data);

randindices = round(rand(1, numpts) .* datalen);

validindices_rand = (randindices > window) & (randindices < (datalen - window));
validindices_hyp = (interestindices > window) & (interestindices < (datalen - window));

hyp = avgaroundfoci(data, interestindices(validindices_hyp), window);
randdata = avgaroundfoci(data, randindices(validindices_rand), window);

subplot(1,2,1)
[S, t, f] = mtspecgramc(hyp, movingwin, params); plot_matrix(S, t, f)
title('Data of interest')
subplot(1,2,2)
[S, t, f] = mtspecgramc(randdata, movingwin, params); plot_matrix(S, t, f)
title('Equivalent random data')

end

