function [theta_ts, Ps, Rs, ps, phis] = markov_perturb(P, R, eps, gamma, r, eps_r, N)
    % Input: 
    %   - (P,R,gamma, r): MDP model 
    %   - (eps, eps_r): peuturb bound
    %   - n: number of MDPs to generate
    S = size(P, 1);
    Ps = repmat(P, [1,1,N]);
    Ps = Ps + Ps .* (2 * rand(size(Ps)) - 1.0) * eps;
    Ps = Ps ./ sum(Ps,2);

    % R = R.*(ones(S, 1) + eps_r*(2*rand(S,1)- 1.0)); % reward vector
    Rs = repmat(R, [1,1,N]);
    Rs = Rs + eps_r * Rs .* randn(size(Rs));

    for i = 1:N
        [~, ~, W] = eig(Ps(:,:,i));
        % Extracting the stationary distribution
        p = W(:, 1); p = p .* sign(p); p = p / sum(p);
        D = diag(p);

        % Generating the feature matrix
        %------------------------------
        phi = eye(S, r);
        
        Proj = phi * inv(phi' * D * phi) * phi' * D; %#ok<MINV>
        A = (eye(S, S) - gamma * Proj * P) * phi;
        b = Proj * R;
        theta_t = A \ b; % fixed point of TD.

        ps(:,:,i) = p;
        phis(:,:,i) = phi;
        theta_ts(:,:,i) = theta_t;
    end
end
