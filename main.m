clear all; close all;
% rng(0)

%% Plot setup
set(0, 'DefaultAxesFontSize', 15, 'DefaultAxesFontName', 'times', 'DefaultAxesFontWeight', 'bold')
set(0, 'DefaultLineLineWidth', 2, 'DefaultAxesLineWidth', 1.5)
set(0, 'DefaultTextInterpreter', 'latex', 'DefaultTextFontName', 'times', 'DefaultTextFontWeight', 'bold')
set(0, 'DefaultLegendInterpreter', 'latex')

%% Hyperparameters
% MDP parameters
S = 100;        % # of states
d1 = 5;         % # of features for states
d2 = 5;         % # of features for actions
an = 100;       % number of candidate actions
% Rmax = 1e2;     % reward cap
Rmax = 1e1;     % reward cap
gamma = 0.2;    % discount factor
eps = 0.1;      % relative error of P
eps_r = 0.1;    % relative error of R

% Feature map
phi = feature_gen(S, d1, d2);
[dict_S, dict_A, feat_S, feat_A] = feature_map(S,d1,d2);

% Algorithm parameters
Ns = [1,2,5,10,20,40];              % # of agents
epss_p = [0,0.1,0.2,0.5,1,2];       % kernel heterogeneity
epss_r = [0,0.1,0.2,0.5,1,2];       % reward heterogeneity
trajs =  10;                        % # of trajectories
K = 10;                             % local steps
T = 2e4;                            % # of iterations
alpha = 1e-2;                       % step size

% Description of Notation
%--------------------------
% theta_st ---> True fixed poin
t
% P ---> Transition matrix
% R ---> Reward vector
% p ---> Stationary distribution
% phi ---> Feature matrix

% initialize the MDP for the first agent
agents = mdp_gen(S, Rmax, eps, eps_r, 1);

P0 = agents{1}.P;
R0 = agents{1}.R;

%% Get reference theta_star
if isfile('mdp_data.mat')
    load mdp_data.mat
else
    agent_ref = cell(1);
    agent_ref{1} = agents{1};
    % opts.T = 2e2*T;
    opts.T = 1e1*T;
    opts.K = opts.T; opts.trajs = 1;
    opts.gamma = gamma;
    opts.alpha = alpha;
    opts.L = 0.01;
    opts.method = 'piece_linear';
    opts.an = 0;
    opts.log_err = true;
    theta_st = zeros(d1*d2,1);
    opts.theta_st = theta_st;
    opts.dict_A = dict_A;
    ref_trajs = 10;
    for i = 1:ref_trajs
        agent_ref = fedsarsa(agent_ref, phi, opts);
        theta_st = theta_st + agent_ref{1}.theta(:,end);
    end
    theta_st = theta_st / ref_trajs;
    save('mdp_data.mat', 'agent_ref', 'theta_st');
    
    % figure
    % semilogy(K:K:opts.T, agent_ref{1}.avg_err(K:K:opts.T));
end

%% Run
% opts.T = T * 4;
opts.T = T; opts.K = K; opts.trajs = trajs;
opts.gamma = gamma; opts.alpha = alpha; opts.an = 0;
opts.log_err = true; opts.theta_st = theta_st;
opts.L = 0.01;
opts.method = 'const';
opts.dict_A = dict_A;

results = cell(length(epss_r), length(epss_p), length(Ns));
for k = 1:length(epss_r)
    for i = 1:length(epss_p)
        eps = epss_p(i); eps_r = epss_r(k);
        for j = 1:length(Ns)
            fprintf('Current eps_r = %f \n', epss_r(k));
            fprintf('Current eps = %f \n', epss_p(i));
            fprintf('Current N = %d \n', Ns(j));
            N = Ns(j);
            agents = mdp_gen(P0, R0, eps, eps_r, N);
            agents = fedsarsa(agents, phi, opts);
            results{k, i, j} = agents;
        end
    end
end
save(strcat('code/bkup/bkup', sprintf('%0.0f',clock), '.mat'), '-v7.3')

%% Plot the errors
switch opts.method
    case 'linear'
        plot_cus = @plot;
    case 'const'
        plot_cus = @semilogy;
end
rel_line = mean(results{1,1,1}{end}.avg_err(opts.T-100:opts.T));
for k = 1:length(epss_r)
    for i = 1:length(epss_p)
        figure()
        for j = 1:length(Ns)
            err = results{k,i,j}{end}.avg_err;
            plot_cus(K:K:opts.T, err(K:K:opts.T), 'DisplayName', sprintf('$N = %d$', Ns(j)));
            %         err_mat = [];
            %         for k = 1:trajs*2
            %             err_mat = [err_mat; results{i,j}{end}.err_record{k}];
            %         end
            %         line = stdshade(err_mat(:,K:10*K:opts.T),0.5,colors(j),K:10*K:size(err_mat,2),12);
            %         set(gca, 'YScale', 'log')
            %         ylim([3e0,1.3e2])
            hold on
        end
        
        yline(rel_line,'r--', 'LineWidth',  2, 'DisplayName', '$N=1$')
        legend
        
        xlim([1 opts.T]);
        xlabel('${{t}}$', 'FontSize', 30);
        ylabel('MSE', 'FontSize', 30);
        grid on;
        title(sprintf('$\\epsilon_p = %.1f, \\epsilon_r = %.1f$', epss_p(i), epss_r(k)), 'Interpreter', 'latex', 'FontSize', 20);
        % pause
        
        ax = gca;
        outerpos = ax.OuterPosition;
        ti = ax.TightInset;
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
        ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
        ax.Position = [left bottom ax_width ax_height];
%         exportgraphics(gca, sprintf('code/fig_sarsa/N%.1f_%.1f.png', epss_p(i), epss_r(k)), 'Resolution', 600)
%         savefig(sprintf('code/fig_sarsa/N%.1f_%.1f.fig', epss_p(i), epss_r(k)))
    end
end

% %% Plot the errors
% switch opts.method
%     case 'linear'
%         plot_cus = @plot;
%     case 'const'
%         plot_cus = @semilogy;
% end
% rel_line = mean(results{1,1,1}{end}.avg_err(opts.T-100:opts.T));
% for j = 1:length(Ns)
%     % for i = 1:length(epss_p)
%         figure()
%         for k = 1:length(epss_r)
%             err = results{k,k,j}{end}.avg_err;
%             plot_cus(K:K:opts.T, err(K:K:opts.T), 'DisplayName', sprintf('$\\epsilon = \\epsilon_r = %.1f$', epss_r(k)));
%             %         err_mat = [];
%             %         for k = 1:trajs*2
%             %             err_mat = [err_mat; results{i,j}{end}.err_record{k}];
%             %         end
%             %         line = stdshade(err_mat(:,K:10*K:opts.T),0.5,colors(j),K:10*K:size(err_mat,2),12);
%             %         set(gca, 'YScale', 'log')
%             %         ylim([3e0,1.3e2])
%             hold on
%         end

%         yline(rel_line,'r--', 'LineWidth',  2, 'DisplayName', '$N=1$')
%         legend

%         xlim([1 opts.T]);
%         xlabel('${{t}}$', 'FontSize', 30);
%         ylabel('MSE', 'FontSize', 30);
%         grid on;
%         title(sprintf('$N = %d$', Ns(j)), 'Interpreter', 'latex', 'FontSize', 20);
%         % pause

%         ax = gca;
%         outerpos = ax.OuterPosition;
%         ti = ax.TightInset;
%         left = outerpos(1) + ti(1);
%         bottom = outerpos(2) + ti(2);
%         ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
%         ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
%         ax.Position = [left bottom ax_width ax_height];
%         exportgraphics(gca, sprintf('code/fig_td/%d_%.1f.png', Ns(j), epss_p(k)), 'Resolution', 600)
%     % end
% end
