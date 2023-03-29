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
        R = rand(SorP,1) * Rmax;
        P = rand(SorP,SorP);
    end
    
    Rs = repmat(R, [1,1,N]);
    Rs = Rs + eps_r * Rs .* randn(size(Rs));

    P = P ./ sum(P, 2);
    Ps = repmat(P, [1,1,N]);
    Ps = Ps + Ps .* (2 * rand(size(Ps)) - 1.0) * eps;
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
        j = a1 - i * S;
        Pas = circshift(P, i);
        Pas = circshift(Pas, j, 2);
        if nargin == 2
            Pas = Pas(s,:);
        end
    end
end