% clc;
% clear all;
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
Rmax = 1e2;       % reward cap
gamma = 0.8;    % discount factor
eps = 0;%0.1;              % relative error of P
eps_r = 0;%0.1;            % relative error of R

% Feature map
phi = feature_gen(S, d1, d2);

% Algorithm parameters
% Ns = [10 20 40 60];   % # of agents
Ns = [1, 2, 5, 10];     % # of agents
trajs = 10;              % # of trajectories
K = 30;                 % local steps
T = 10000;              % # of iterations
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
% save('mdp_data.mat', 'theta_st', 'P', 'R', 'p');
% data = load('mdp_data.mat');

P0 = agents{1}.P;
R0 = agents{1}.R;

%%
method = 'markov';
results = cell(1, length(Ns));

for i = 1:length(Ns)
    fprintf('Current M = %d \n', Ns(i));
    N = Ns(i);
    agents = mdp_gen(P0, R0, eps, eps_r, N);
    agents = fedTD(agents, phi, T, K, method, trajs);
    results{i} = agents;
    save expr_1012_batch_K_30_eps_0dot1
end

%% plot the errors
figure

for i = 1:length(Ns)
    err = results{i}{1}.avg_err;
    plot_err = err(K:K:end);
    semilogy(K:K:T, plot_err, 'DisplayName', sprintf('$N = %d$', Ns(i)));
    hold on
end

legend

xlim([1 T]);
xlabel('${{t}}$', 'FontSize', 30);
ylabel('$e_t$', 'FontSize', 30);
grid on;
title(['K = ', num2str(K), ' method = ', method, ' rel err = ', num2str(eps)]);

ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
ax.Position = [left bottom ax_width ax_height];
