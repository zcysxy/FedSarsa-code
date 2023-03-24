function [agents] = fedTD(agents, T, K, method, trajs)

    if nargin < 5; trajs = 50; end

    N = length(agents);

    if strcmp(method, 'mean')

        for t = 1:T

            for i = 1:N
                D = diag(agents{i}.mdp.p);
                R = agents{i}.mdp.R; P = agents{i}.mdp.P; phi = agents{i}.mdp.phi;
                gamma = agents{i}.mdp.gamma; r = agents{i}.r;
                theta_st = agents{i}.mdp.theta_st;
                theta_t = agents{i}.theta(:, t);
                % mean-path update
                % ϕᵀD(R + γPϕθ − ϕθ)
                g = phi' * D * (R + gamma * P * phi * theta_t - phi * theta_t);
                agents{i}.theta(:, t + 1) = theta_t + agents{i}.alpha * g;
                agents{i}.err(:, t) = (norm(theta_st - theta_t)) ^ 2;
            end

            % Synchronize
            if mod(t, K) == 0
                theta_mean = zeros(r, 1);

                for i = 1:N
                    theta_mean = theta_mean + agents{i}.theta(:, t);
                end

                theta_mean = theta_mean / N;

                for i = 1:N
                    agents{i}.theta(:, t) = theta_mean;
                    agents{i}.err(:, t) = (norm(agents{i}.mdp.theta_st - theta_mean)) ^ 2;
                end

            end

        end

        for i = 1:N
            agents{i}.avg_err = agents{i}.err;
            agents{i}.cell_record{1} = agents{i}.err;
        end

    elseif strcmp(method, 'iid')

        for k = 1:trajs
            fprintf('trajectory num: %d \n', k);

            % reset err
            for i = 1:N
                agents{i}.err = zeros(1, T);
            end

            for t = 1:T

                if mod(t, 1000) == 0; disp(t); end

                for i = 1:N
                    % Generate current state s_t from stationary dist
                    p = agents{i}.mdp.p;

                    R = agents{i}.mdp.R; P = agents{i}.mdp.P; phi = agents{i}.mdp.phi;
                    gamma = agents{i}.mdp.gamma; r = agents{i}.r; alpha = agents{i}.alpha;
                    theta_st = agents{i}.mdp.theta_st;

                    s_old = find(cumsum(p) > rand(1), 1);
                    % Generating the next state s_t+1
                    d = P(s_old, :); % distribution of s_t+1|s_t
                    s_new = find(cumsum(d) > rand(1), 1); % new state s_t+1
                    rew = R(s_old, 1); %+ 0.1 * normrnd(0, 1); % current reward
                    % (R + γPϕθ − ϕθ) ϕᵀ
                    theta_t = agents{i}.theta(:, t);
                    g = (rew + gamma * (phi(s_new, :)) *  theta_t - (phi(s_old, :)) * theta_t) * (phi(s_old, :))';
                    agents{i}.theta(:, t + 1) = theta_t + alpha * g;
                    agents{i}.err(:, t) = (norm(theta_st - theta_t)) ^ 2;
                end

                if mod(t, K) == 0
                    % synchronize
                    theta_mean = zeros(r, 1);

                    for i = 1:N
                        theta_mean = theta_mean + agents{i}.theta(:, t);
                    end

                    theta_mean = theta_mean / N;

                    for i = 1:N
                        agents{i}.theta(:, t) = theta_mean;
                        agents{i}.err(:, t) = (norm(agents{i}.mdp.theta_st - theta_mean)) ^ 2;
                    end

                end

            end

            for i = 1:N
                agents{i}.avg_err = agents{i}.avg_err + agents{i}.err;
                agents{i}.err_record{k} = agents{i}.err;
            end

        end

        for i = 1:N
            agents{i}.avg_err = agents{i}.avg_err / trajs;
        end

    elseif strcmp(method, 'markov')

        for k = 1:trajs
            fprintf('epoch num: %d \n', k);
            % reset err
            for i = 1:N
                agents{i}.err = zeros(1, T);
                % initialize the state
                agents{i}.s = agents{i}.s_init;
            end

            for t = 1:T

                if mod(t, 1000) == 0; disp(t); end

                for i = 1:N
                    R = agents{i}.mdp.R; P = agents{i}.mdp.P; phi = agents{i}.mdp.phi;
                    gamma = agents{i}.mdp.gamma; r = agents{i}.r; alpha = agents{i}.alpha;
                    theta_st = agents{i}.mdp.theta_st;

                    s_old = agents{i}.s;

                    % Generating the next state s_t+1
                    d = P(s_old, :); % distribution of s_t+1|s_t
                    s_new = find(cumsum(d) > rand(1), 1); % new state s_t+1
                    rew = R(s_old, 1); % current reward
                    theta_t = agents{i}.theta(:, t);
                    % (R + γPϕθ − ϕθ) ϕᵀ
                    g = (rew + gamma * (phi(s_new, :)) * theta_t - (phi(s_old, :)) *  theta_t) * (phi(s_old, :))';
                    agents{i}.theta(:, t + 1) =  theta_t + alpha * g;
                    agents{i}.err(:, t) = (norm(theta_st -  theta_t)) ^ 2;
                    agents{i}.s = s_new; % continuity of trajectory
                end

                if mod(t, K) == 0
                    % synchronize
                    theta_mean = zeros(r, 1);

                    for i = 1:N
                        theta_mean = theta_mean + agents{i}.theta(:, t);
                    end

                    theta_mean = theta_mean / N;

                    for i = 1:N
                        agents{i}.theta(:, t) = theta_mean;
                        agents{i}.err(:, t) = (norm(agents{i}.mdp.theta_st - theta_mean)) ^ 2;
                    end

                end

            end

            for i = 1:N
                agents{i}.avg_err = agents{i}.avg_err + agents{i}.err;
                agents{i}.err_record{k} = agents{i}.err;
            end

        end

        for i = 1:N
            agents{i}.avg_err = agents{i}.avg_err / trajs;
        end

    else
        error('Method not implemented.')
    end
end
