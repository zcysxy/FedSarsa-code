function [agents] = fedsarsa(agents, phi, opts)
    % Run FedSarsa and update results to agents

    % Defaults
    if ~isfield(opts, 'T'), opts.T = 1e4; end
    if ~isfield(opts, 'K'), opts.K = 30; end
    if ~isfield(opts, 'trajs'), opts.trajs = 10; end
    if ~isfield(opts, 'gamma'), opts.gamma = 0.8; end
    if ~isfield(opts, 'alpha'), opts.alpha = 0.1; end
    if ~isfield(opts, 's_init'), opts.s_init = 1; end
    if ~isfield(opts, 'an'), opts.an  = 100; end
    if ~isfield(opts, 'log_err'), opts.log_err  = false; end

    log_err = opts.log_err;
    if log_err
        if ~isfield(opts, 'theta_st')
            error("Error: theta_star is not given!")
        end
        theta_st = opts.theta_st;
        theta_st_norm = norm(theta_st);
    end
    
    T = opts.T;
    K = opts.K;
    trajs = opts.trajs;
    gamma = opts.gamma;
    alpha = opts.alpha;
    s_init = opts.s_init;
    an = opts.an;

    N = length(agents);
    d = size(phi(1,1), 1);
    S = size(agents{1}.P,1);
    % Generate random action candidates
    if an == 0
        as_old = linspace(0,1,S^2+1);
        as_new = as_old;
    else
        as_old = rand(1,an);
    end

    for i = 1:N
        agents{i}.avg_err = zeros(1, T);
    end

    for traj = 1:trajs
        fprintf('trajectory num: %d \n', traj);

        for i = 1:N
            % Initialization
            agents{i}.err = zeros(1, T);
            agents{i}.s = s_init;
            agents{i}.theta = zeros(d, T);
            agents{i}.phi_cache = phi(s_init, as_old);
        end

        for t = 1:T
            if mod(t, 1000) == 0; disp(t); end

            % Generate random action candidates
            if an ~= 0
                as_new = rand(1,an);
            end

            for i = 1:N
                theta_t = agents{i}.theta(:,t);
                s_old = agents{i}.s;
                value_old = theta_t' * agents{i}.phi_cache;
                a_old = as_old(policy(value_old));

                % Generating the next state-action (s_t+1, a_t+1)
                Pas = agents{i}.Pa(a_old, s_old); % distribution of s_t+1|s_t
                rew = agents{i}.R(s_old, 1); % current reward
                s_new = find(cumsum(Pas) > rand(1), 1); % new state s_t+1

                phi_cache = phi(s_new, as_new);
                value_new = phi_cache' * theta_t;
                a_new = as_new(policy(value_new));

                % (R + γPϕθ − ϕθ) ϕᵀ
                g = (rew + gamma * theta_t' * phi(s_new, a_new) - theta_t' * phi(s_old, a_old)) * phi(s_old, a_old);

                agents{i}.theta(:, t + 1) = theta_t + alpha * g;
                agents{i}.s = s_new; % continuity of trajectory
                agents{i}.phi_cache = phi_cache;
                if log_err
                    agents{i}.err(:, t) = norm(theta_st - theta_t) / theta_st_norm;
                end
            end

            as_old = as_new;

            if mod(t + 1, K) == 0
                % synchronize
                theta_mean = agents{1}.theta(:, t + 1);

                for i = 2:N
                    theta_mean = theta_mean + agents{i}.theta(:, t + 1);
                end

                theta_mean = theta_mean / N;

                for i = 1:N
                    agents{i}.theta(:, t + 1) = theta_mean;
                end

            end

        end

        if log_err
            for i = 1:N
                agents{i}.avg_err = agents{i}.avg_err + agents{i}.err;
                agents{i}.err_record{traj} = agents{i}.err;
            end
        end
    end

    if log_err
        for i = 1:N
            agents{i}.avg_err = agents{i}.avg_err / trajs;
        end
    end

end
