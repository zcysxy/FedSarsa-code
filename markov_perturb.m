function [Ps, Rs] = markov_perturb(P, R, eps, eps_r, N)
    % Input: 
    %   - (P,R): MDP model 
    %   - (eps, eps_r): peuturb bound
    %   - N: number of MDPs to generate
    S = size(P, 1);
    Ps = repmat(P, [1,1,N]);
    Ps = Ps + Ps .* (2 * rand(size(Ps)) - 1.0) * eps;
    Ps = Ps ./ sum(Ps,2);

    % R = R.*(ones(S, 1) + eps_r*(2*rand(S,1)- 1.0)); % reward vector
    Rs = repmat(R, [1,1,N]);
    Rs = Rs + eps_r * Rs .* randn(size(Rs));
end
