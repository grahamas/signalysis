function [changes, h_sd, l_sd] = velchangeindices( vels, params )
%VELOCITYCHANGEINDICES Finds depressed followed by increased velocity indices
%   BK's method.

changes = [];

% z-score the ABSOLUTE VALUE of the velocity.
% if params.abs
%     [Z, mu, sigma] = zscore(abs(vels));
%     mu
%     sigma
% else
%     [Z, mu,sigma] = zscore(vels);
%     mu
%     sigma
% end

Z = abs(vels);
scale = sort(Z);
len = length(scale);

% Get values from the params
h_window = params.highvel_window;
l_window = params.lowvel_window;
margin = params.midvel_margin;

sds = params.sd;
h_param = sds(2);
l_param = sds(1);

h_sd = scale(round(h_param * len));
l_sd = scale(round(l_param * len));


% Set the loop state
l_found = 0;

h_cnt = 0;
l_cnt = 0;
m_cnt = margin;

for i = 1:length(vels)
    low = Z(i) < l_sd;
    high = Z(i) >= h_sd;
    middle = ~low & ~high;
    
    % Soooooooo many duplicated operations. But I'll wait the extra five
    % seconds if it means redundancy.
    if l_found
        if middle
            h_cnt = 0;
            l_cnt = 0;
            m_cnt = m_cnt - 1;
            if m_cnt < 0
                l_found = 0;
                m_cnt = margin;
            end
        elseif high
            l_cnt = 0;
            m_cnt = margin;
            h_cnt = h_cnt + 1;
            if h_cnt == h_window
                changes = [changes, i - h_window];
                h_cnt = 0;
                l_found = 0;
            end
        elseif (h_cnt > 0) || (m_cnt < margin)
            l_found = 0;
            h_cnt = 0;
            l_cnt = 1;
            m_cnt = margin;
        end
    else
        if high
            l_cnt = 0;
            m_cnt = margin;
            h_cnt = 0;
        elseif middle
            l_cnt = 0;
            m_cnt = margin;
            h_cnt = 0;
        else
            l_cnt = l_cnt + 1;
            m_cnt = margin;
            h_cnt = 0;
            if l_cnt >= l_window
                l_found = 1;
            end
        end
    end
end
        
    



end

