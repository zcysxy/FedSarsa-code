function [agents] = batch_mdp_perturb(mdp, T, r, S, alpha, gamma, eps, eps_r, N, phi)
    % generate N perturbed MDPs of the nominal MDP

    agents = cell(1, N);

    % theta_st_nom = mdp.theta_st;
    P_nom = mdp.P; R_nom = mdp.R;

    mdp.gamma = gamma;
    agent.mdp = mdp;
    % remove
    agent.s_init = 1;
    agent.s = 1;
    agent.T = T; agent.r = r; agent.S = S; agent.alpha = alpha;
    agent.err = zeros(1, T); agent.avg_err = zeros(1, T); agent.err_record = {};
    agent.theta = zeros(r, T);
    agents{1} = agent;

    % randomly generate MDPs
    [theta_sts, Ps, Rs, ps] = markov_perturb(P_nom, R_nom, eps, gamma, phi, eps_r, N);

    for i = 2:N
        % use the same theta star for error comparison
        % mdp.theta_st = theta_st_nom;
        mdp.P = Ps(:, :, i); mdp.R = Rs(:, :, i);
        mdp.p = ps(:, :, i);
        agent.mdp = mdp;
        agents{i} = agent;
    end

end
