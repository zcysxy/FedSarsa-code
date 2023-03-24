function [theta_t, P, R, p, phi] = markov_perturb(P, R, eps, gamma, r, eps_r)
%MARKOV_PERTURB Summary of this function goes here
%   Detailed explanation goes here
S = size(P, 1);

P = P.*(ones(S, S) + (2*rand(S, S)-1.0)*eps);
% P = P.*(ones(S, S) + randn(S, S)*eps);

for i=1:S
    P(i,:)=P(i,:)/sum(P(i,:));
end

[~,~,W]=eig(P);

% Extracting the Stationary Distribution
p=W(:,1); p=p.*sign(p); p=p/sum(p);

D = diag(p);

% R = R.*(ones(S, 1) + eps_r*(2*rand(S,1)- 1.0)); % reward vector
R = R.*(ones(S, 1) + eps_r*randn(S,1));

% Generating the feature matrix
%------------------------------
phi=zeros(S,r);
for i=1:r
    phi(i,i)=1;
end

Proj=phi*inv(phi'*D*phi)*phi'*D; %#ok<MINV> 
A=(eye(S,S)-gamma*Proj*P)*phi;
b=Proj*R;
theta_t=A\b; % fixed point of TD.
end

