function hyp_spec( movingwin, params, interestindices, data, window)
%HYPVSRAND_SPEC Plots two spectrograms, one of interest, the other random
%   

numpts = length(interestindices);
datalen = length(data);

validindices_hyp = (interestindices > window) & (interestindices < (datalen - window));

hyp = avgaroundfoci(data, interestindices(validindices_hyp), window);

[S, t, f] = mtspecgramc(hyp, movingwin, params); plot_matrix(S, t, f)

end
