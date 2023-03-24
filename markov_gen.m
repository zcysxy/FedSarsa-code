%% Markov Matrix Generator %%
%-----------------------------%
% Takes as input # of states, discount factor, dimension of feature matrix
% Returns Markov matrix + Reward Vector + True theta +stationary dist
% + feature matrix

function [theta_t,P,R,p]= markov_gen(S,Rmax, gamma,phi)
% Generate a Markov Matrix 
%--------------------------------------------------------------------------
P=rand(S,S);
P = P ./ sum(P, 2);

% Reward vector
R = rand(S,1) * Rmax;

[~,~,W]=eig(P);

% Extracting the stationary distribution
p=W(:,1); p=p.*sign(p); p=p/sum(p);
D = diag(p);


% remove this (no close solution for SARSA)
Proj=phi*inv(phi'*D*phi)*phi'*D; %#ok<MINV> 
A=(eye(S,S)-gamma*Proj*P)*phi;
b=Proj*R;
theta_t=A\b; % fixed point of TD.
