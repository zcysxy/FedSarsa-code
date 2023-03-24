% Markovian Setting
%------------------------------------------------------------------------------------%
clc; clear all; close all; %#ok<CLALL> 

M = 30; % no of agents
K = 20; % local steps

S=100; % no of states
gamma=0.5; % discount factor
r=10; % rank of feature matrix

agents = cell(1, M);

% algorithmic parameters
T=1000; % no of iterations
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

mdp.theta_st = theta_st; mdp.P = P; mdp.R = R; mdp.p = p; mdp.phi = phi;
mdp.gamma = gamma;
agent.mdp = mdp; 
agent.s_init = 1;
agent.s = 1;

agent.T = T; agent.r = r; agent.S = S; agent.alpha = alpha; 
agent.err = zeros(1, T); agent.avg_err = zeros(1,T);
agent.x = zeros(r, T); 
agents{1} = agent;

eps = 0.05; % relative error to P and R
P_nom = P; R_nom = R; 
for i = 1:M-1
    agent = struct;
    mdp = struct;
    
    % randomly generate MDPs
    [theta_st,P,R,p,phi]= markov_perturb(P_nom, R_nom, eps, gamma, r);

    mdp.theta_st = theta_st; mdp.P = P; mdp.R = R; mdp.p = p; mdp.phi = phi;
    mdp.gamma = gamma;
    agent.mdp = mdp; 
    agent.s_init = 1;
    agent.s = 1;
    
    agent.T = T; agent.r = r; agent.S = S; agent.alpha = alpha; 
    agent.err = zeros(1, T); agent.avg_err = zeros(1,T);
    agent.x = zeros(r, T); 
    agents{i+1} = agent;
end

method = 'mean';
method = 'iid';
method = 'markov';

%--------------------------------------------------------------------------
% Mean-Path Setting
%--------------------------------------------------------------------------
com_count = 0; % count the number of synchronization
for i = 1:T
    
    for j = 1:M
        agent = agents{j};
        D = diag(agent.mdp.p);

        R = agent.mdp.R; P = agent.mdp.P; phi = agent.mdp.phi; 
        gamma = agent.mdp.gamma;
        theta_st = agent.mdp.theta_st;
        % mean-path update
        g=phi'*D*(R+gamma*P*phi*agent.x(:,i)-phi*agent.x(:,i));
        agent.x(:,i+1) = agent.x(:,i) + agent.alpha*g;
        agent.err(:,i)=(norm(theta_st-agent.x(:,i)))^2;
        % need to reassign the updated values to the cell. 
        agents{j} = agent;
    end
    
     if mod(i, K+1) == 0
        % synchronize 
        x_mean = zeros(r, 1);
        for j = 1:M
           x_mean = x_mean + agents{j}.x(:, i); 
        end
        x_mean = x_mean/M;
        
        for j = 1:M
            agents{j}.x(:, i) = x_mean;
        end
        com_count = com_count + 1;
     end


end

%% plot the errors
for j = 1:M
err = agents{j}.err;
figure
plot(err,'Color', uint8([17 17 17]),'LineWidth',2);
hold on;
xlim([1 T]);
ax=gca;
set(ax, 'fontsize',15, 'fontname', 'times','FontWeight','bold');
ax.LineWidth=1.2;
xlab=xlabel('${{t}}$','Interpreter','latex');
set(xlab,'fontsize',30,'fontname', 'times','FontWeight','bold');
ylab=ylabel('$e_t$','Interpreter','latex');
set(ylab,'fontsize',30, 'fontname', 'times','FontWeight','bold');
grid on;

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

end
