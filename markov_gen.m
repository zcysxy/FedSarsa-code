%% Markov Matrix Generator
function [P,R]= markov_gen(S, Rmax)
    % Generate a Markov Matrix 
    % Takes as input # of states, discount factor
    % Returns Markov matrix + Reward Vector
    
    % Reward vector (on state alone)
    R = rand(S,1) * Rmax;

    P0 = rand(S,S);
    P0 = P0 ./ sum(P0, 2);
    P = @P_gen;
    function Pa = P_gen(a)
        a1 = int16(a * S^2);
        i = a1 / S;
        j = a1 - i * S;
        Pa = circshift(P0, i);
        Pa = circshift(Pa, j, 2);
    end
end