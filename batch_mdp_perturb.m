function [agents] = batch_mdp_perturb(mdp, T, r, S, alpha, gamma, eps, eps_r, M)
%BATCH_MDP_PERTURB Summary of this function goes here
%   generate M perturbed MDPs of the nominal MDP

agents = cell(1, M);

theta_st_nom = mdp.theta_st;
P = mdp.P; R = mdp.R; p = mdp.p; phi = mdp.phi;

mdp.theta_st = theta_st_nom; mdp.P = P; mdp.R = R; mdp.p = p; mdp.phi = phi;
mdp.gamma = gamma;
agent.mdp = mdp; 
agent.s_init = 1;
agent.s = 1;



agent.T = T; agent.r = r; agent.S = S; agent.alpha = alpha; 
agent.err = zeros(1, T); agent.avg_err = zeros(1,T); agent.err_record = {};
agent.x = zeros(r, T); 
agents{1} = agent;

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

end

