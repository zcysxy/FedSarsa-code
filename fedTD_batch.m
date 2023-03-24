% Markovian Setting
%------------------------------------------------------------------------------------%
% clc; clear all; close all; %#ok<CLALL> 
clear all;

K = 30; % local steps

eps = 0.1; % relative error to P and R
eps_r = 0.1;

S=100; % no of states
gamma=0.2; % discount factor
r=10; % rank of feature matrix

% algorithmic parameters
T = 30000; % no of iterations
alpha = 0.1; 

% Description of Notation
%--------------------------
% theta_st ---> True fixed point
% P ---> Transition matrix
% R ---> Reward vector
% p ---> Stationary distribution
% phi ---> Feature matrix 

% initialize the MDP for each agent
% [theta_st,P,R,p,phi]= markov_gen(S,gamma,r);
% save('mdp_data_1012.mat', 'theta_st', 'P', 'R', 'p', 'phi');

data = load('mdp_data.mat');
theta_st = data.theta_st; P = data.P; R = data.R; p = data.p; phi = data.phi;
mdp_nom = struct;
mdp_nom.theta_st = theta_st; mdp_nom.P = P; mdp_nom.R = R; mdp_nom.p = p; mdp_nom.phi = phi;

%% 
M_list = [10 20 40 60];
% M_list = [1 10];

method = 'markov'; num_epoch = 10;

results = cell(1, length(M_list));

for i = 1:length(M_list)
    fprintf('Current M = %d \n', M_list(i));
    M = M_list(i);
    agents = batch_mdp_perturb(mdp_nom, T, r, S, alpha, gamma, eps, eps_r, M);
    agents = fedTD(agents, T, K, method, num_epoch);
    results{i} = agents;
    save expr_1012_batch_K_30_eps_0dot1
end


%% plot the errors
figure

for i = 1:length(M_list)-1
    err = results{i+1}{1}.avg_err;
    plot_err = err(K:K:end);
    semilogy(K:K:T, plot_err,'LineWidth',2);
    hold on
end

legend('$N = 10$', '$N = 20$', '$N = 40$', '$N = 60$', 'Interpreter', 'Latex');
% legend('M = 1', 'M = 10');

xlim([1 T]);
ax=gca;
set(ax, 'fontsize',15, 'fontname', 'times','FontWeight','bold');
ax.LineWidth=1.2;
xlab=xlabel('${{t}}$','Interpreter','latex');
set(xlab,'fontsize',30,'fontname', 'times','FontWeight','bold');
ylab=ylabel('$e_t$','Interpreter','latex');
set(ylab,'fontsize',30, 'fontname', 'times','FontWeight','bold');
grid on;
% title(['K = ', num2str(K), ' method = ', method, ' rel err = ', num2str(eps)]);

ax = gca;
ax.XAxis.LineWidth = 1.5;
ax.YAxis.LineWidth = 1.5;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3)-0.01;
ax_height = outerpos(4) - ti(2) - ti(4)-0.01;
ax.Position = [left bottom ax_width ax_height]; 