function [new_powerSpecFeats] = add_ratios(powerSpecFeats, num_features)

%   This function adds theta/delta, alpha/theta, beta/alpha, and gamma/beta
%   to an UNNORMALIZED electrodewise powerSpecFeats after the original FIVE power waves
%   (delta, theta, alpha, beta, gamma)
%
%   num_features - number of features per electrode in powerSpecFeats(5)
%   Written by Arnold Yeung, May 21, 2015
%   Editted by Arnold Yeung, May 30, 2015 - compatiable with a
%   powerSpecFeats with 5 entropies after power

new_powerSpecFeats = [];

for i = 1:num_features:size(powerSpecFeats, 2) % 1, 6, 11...
    new_powerSpecFeats = [new_powerSpecFeats powerSpecFeats(:, i:i+4)];     % concatenate original power waves
    
    theta_delta = powerSpecFeats(:, i+1)./powerSpecFeats(:, i);
    alpha_theta = powerSpecFeats(:, i+2)./powerSpecFeats(:, i+1);
    beta_alpha = powerSpecFeats(:, i+3)./powerSpecFeats(:, i+2);
    gamma_beta = powerSpecFeats(:, i+4)./powerSpecFeats(:, i+3);
    
    new_powerSpecFeats = [new_powerSpecFeats theta_delta alpha_theta beta_alpha gamma_beta];
    
    % new_powerSpecFeats = [new_powerSpecFeats powerSpecFeats(:, i+5:i+9)];
   
end

