%% Markov Matrix Generator
function [agents]= mdp_gen(SorP, Rmax, eps, eps_r, N)
    % Generate MDPs 
    % Takes as input MDP parameters, heterogeneity parameters, # fo agents
    % Returns reward vector, original transition kernel, action kernel generator
    
    agents = cell(1,N);

    % original MDP is provided
    if all(size(SorP) > [1,1]) && length(Rmax) > 1
        R = Rmax;
        P = SorP;
    % # of states and Rmax are provided
    else
        R = rand(SorP,1);
        % Make reward non-uniform
        R_switch = 0.95;
        R(R > R_switch) = R(R > R_switch) * 10;
        R(R <= R_switch) = R(R <= R_switch) / 10;
        
        % Make reward non-random
        % R = zeros(SorP,1);
        % R(end) = 1;

        R = rescale(R) * Rmax;

        P = rand(SorP,SorP);
        % Make kernel non-uniform
        P_switch = 0.7;
        P(P > P_switch) = P(P > P_switch) * 10;
        P(P <= P_switch) = P(P <= P_switch) / 10;

        % Make kernel non-random
        % P = zeros(SorP,SorP);
        % P(:,1) = 1;

        P = P ./ sum(P, 2);
    end
    
    Rs = repmat(R, [1,1,N]);
    Rs = Rs + ((rand(size(Rs)) > 0.5)*2-1) .* eps_r .* Rmax;
    Rs = max(-Rmax, min(Rmax,Rs));

    Ps = repmat(P, [1,1,N]);
    Ps = Ps + (rand(size(Ps))*2-1) .* eps .* Ps;
    Ps = Ps + ((rand(size(Ps)) > 0.5)*2-1) .* eps .* Ps;
    Ps = max(0,Ps);
    Ps = Ps ./ sum(Ps,2);
    
    for i = 2:N
        agents{i}.R = Rs(:,:,i);
        agents{i}.P = Ps(:,:,i);
        agents{i}.Pa = P_gen_gen(Ps(:,:,i));
    end

    agents{1}.R = R;
    agents{1}.P = P;
    agents{1}.Pa = P_gen_gen(P);
end

function out = P_gen_gen(P)
    % Generate the transition kernel of action a in [0,1]
    out = @P_gen;
    function Pas = P_gen(a,s)
        S = size(P,1);
        a1 = int16(a * S^2);
        i = a1 / S;
        % j = a1 - i * S;
        % Pas = circshift(P, i);
        % Pas = circshift(Pas, j, 2);
        Pas = circshift(P, i, 2);
        if nargin == 2
            Pas = Pas(s,:);
        end
    end
end
