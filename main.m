% clc;
clear all;
close all
rng(0)

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
Rmax = 1e2;     % reward cap
gamma = 0.2;    % discount factor
eps = 0.1;              % relative error of P
eps_r = 0.1;            % relative error of R

% Feature map
phi = feature_gen(S, d1, d2);

% Algorithm parameters
Ns = [1,2,5,10,20,40,60];   % # of agents
% Ns = [1, 2, 5, 10];     % # of agents
trajs =  5;             % # of trajectories
K = 30;                 % local steps
T = 15000;              % # of iterations
alpha = 0.1;            % step size

% Description of Notation
%--------------------------
% theta_st ---> True fixed point
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
    opts.T = 5*T; opts.K = 5*T; opts.trajs = 1;
    opts.gamma = gamma; opts.alpha = alpha; opts.an = 0;
    opts.log_err = false;
    theta_st = zeros(d1*d2,1);
    for i = 1:10
        agent_ref = fedsarsa(agent_ref, phi, opts);
        theta_st = theta_st + agent_ref{1}.theta(:,end);
    end
    theta_st = theta_st / 10;
    save('mdp_data.mat', 'agent_ref', 'theta_st');
end

%% Run
opts.T = T; opts.K = K; opts.trajs = trajs;
opts.gamma = gamma; opts.alpha = alpha; opts.an = an;
opts.log_err = true; opts.theta_st = theta_st;
results = cell(1, length(Ns));

Ns = [1,2,10]; % tmp
for i = 1:length(Ns)
    fprintf('Current N = %d \n', Ns(i));
    N = Ns(i);
    agents = mdp_gen(P0, R0, eps, eps_r, N);
    agents = fedsarsa(agents, phi, opts);
    results{i} = agents;
end
save(sprintf('bkup_%0.0f.mat',clock))

%% plot the errors
figure

for i = 1:length(Ns)
    err = results{i}{end}.avg_err;
    plot_err = err(K:K:end);
    semilogy(K:K:T, plot_err, 'DisplayName', sprintf('$N = %d$', Ns(i)));
    hold on
end

legend

xlim([1 T]);
xlabel('${{t}}$', 'FontSize', 30);
ylabel('$e_t$', 'FontSize', 30);
grid on;
title(['K = ', num2str(K), ' rel err = ', num2str(eps)]);

ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
ax.Position = [left bottom ax_width ax_height];
