% Markovian Setting
%------------------------------------------------------------------------------------%
% clc; clear all; close all; %#ok<CLALL> 
clear all;

M = 10; % no of agents
K = 10; % local steps

S=100; % no of states
gamma=0.2; % discount factor
r=10; % rank of feature matrix

agents = cell(1, M);

% algorithmic parameters
T=10000; %30000; % no of iterations
alpha = 0.1; 

% Description of Notation
%--------------------------
% theta_st ---> True fixed point
% P ---> Transition matrix
% R ---> Reward vector
% p ---> Stationary distribution
% phi ---> Feature matrix 

% initialize the MDP for each agent
[theta_st,P,R,p,phi]= markov_gen(S,gamma,r);
save('mdp_data.mat', 'theta_st', 'P', 'R', 'p', 'phi');

% data = load('mdp_data.mat');
% theta_st = data.theta_st; P = data.P; R = data.R; p = data.p; phi = data.phi;

theta_st_nom = theta_st;

mdp.theta_st = theta_st_nom; mdp.P = P; mdp.R = R; mdp.p = p; mdp.phi = phi;
mdp.gamma = gamma;
agent.mdp = mdp; 
agent.s_init = 1;
agent.s = 1;

agent.T = T; agent.r = r; agent.S = S; agent.alpha = alpha; 
agent.err = zeros(1, T); agent.avg_err = zeros(1,T);
agent.x = zeros(r, T); 
agents{1} = agent;

eps = 0.05; % relative error to P and R
eps_r = 0.1;

P_nom = P; R_nom = R; 
for i = 1:M-1
    agent = struct;
    mdp = struct;
    
    % randomly generate MDPs
    [theta_st,P,R,p,phi]= markov_perturb(P_nom, R_nom, eps, gamma, r, eps_r);
       
    % use the same theta star for error comparison
    mdp.theta_st = theta_st_nom; mdp.P = P; mdp.R = R; mdp.p = p; mdp.phi = phi;
    mdp.gamma = gamma;
    agent.mdp = mdp; 
    agent.s_init = 1;
    agent.s = 1;
    
    agent.T = T; agent.r = r; agent.S = S; agent.alpha = alpha; 
    agent.err = zeros(1, T); agent.avg_err = zeros(1,T);
    agent.x = zeros(r, T); 
    agents{i+1} = agent;
end

%% FedTD algorithm

% method = 'mean', 'iid', or 'markov'
method = 'iid'; num_epoch = 5;
agents = fedTD(agents, T, K, method, num_epoch);

% baseline
data = load('mdp_data.mat');
theta_st = data.theta_st; P = data.P; R = data.R; p = data.p; phi = data.phi;

mdp.theta_st = theta_st; mdp.P = P; mdp.R = R; mdp.p = p; mdp.phi = phi;
mdp.gamma = gamma;
agent.mdp = mdp; 
agent.s_init = 1;
agent.s = 1;

agent.T = T; agent.r = r; agent.S = S; agent.alpha = alpha; 
agent.err = zeros(1, T); agent.avg_err = zeros(1,T);
agent.x = zeros(r, T); 
agents_new{1} = agent;
method = 'iid'; 
agents_new = fedTD(agents_new, T, K, method, num_epoch);

%% plot the errors
figure

% for j = 1:M
% err = agents{j}.avg_err;
% plot_err = err(2:K+1:end);
% % plot(err,'Color', uint8([17 17 17]),'LineWidth',1);
% semilogy(2:K+1:T, plot_err,'LineWidth',1);
% end


err = agents{1}.avg_err;
plot_err = err(K:K:end);
% plot(err,'Color', uint8([17 17 17]),'LineWidth',1);
semilogy(K:K:T, plot_err,'LineWidth',1);

hold on;
semilogy(K:K:T, agents_new{1}.avg_err(K:K:end), 'LineWidth', 1);

xlim([1 T]);
ax=gca;
set(ax, 'fontsize',15, 'fontname', 'times','FontWeight','bold');
ax.LineWidth=1.2;
xlab=xlabel('${{t}}$','Interpreter','latex');
set(xlab,'fontsize',30,'fontname', 'times','FontWeight','bold');
ylab=ylabel('$e_t$','Interpreter','latex');
set(ylab,'fontsize',30, 'fontname', 'times','FontWeight','bold');
grid on;
title(['K = ', num2str(K), ' M = ', num2str(M), ' method = ', method, ' rel err = ', num2str(eps)]);
legend('M = 10', 'M = 1');

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