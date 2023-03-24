%% Markov Matrix Generator %%
%-----------------------------%
% Takes as input # of states, discount factor, rank of feature matrix
% Returns Markov matrix + Reward Vector + True theta +stationary dist
% + feature matrix

function [theta_t,P,R,p,phi]= markov_gen(S,gamma,r)
% Generate a Markov Matrix 
%--------------------------------------------------------------------------
P=rand(S,S);

for i=1:S
    P(i,:)=P(i,:)/sum(P(i,:));
end

[~,~,W]=eig(P);

% Extracting the Stationary Distribution
p=W(:,1); p=p.*sign(p); p=p/sum(p);

D=zeros(S,S); % stores the elements of p

for i=1:S
D(i,i)=p(i);
end

R= rand(S,1); % reward vector

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
