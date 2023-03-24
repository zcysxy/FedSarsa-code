function [agents] = fedTD(agents, T, K, method, num_epoch)
%FEDTD Summary of this function goes here
%   Detailed explanation goes here
if nargin < 5
    num_epoch = 50;
end

M = length(agents);

if strcmp(method, 'mean')
    for i = 1:T
        for j = 1:M
            agent = agents{j};
            D = diag(agent.mdp.p);

            R = agent.mdp.R; P = agent.mdp.P; phi = agent.mdp.phi; 
            gamma = agent.mdp.gamma; r = agent.r;
            theta_st = agent.mdp.theta_st;
            % mean-path update
            g=phi'*D*(R+gamma*P*phi*agent.x(:,i)-phi*agent.x(:,i));
            agent.x(:,i+1) = agent.x(:,i) + agent.alpha*g;
            agent.err(:,i)=(norm(theta_st-agent.x(:,i)))^2;
            % need to reassign the updated values to the cell. 
            agents{j} = agent;
        end

         if mod(i, K) == 0
            % synchronize 
            x_mean = zeros(r, 1);
            for j = 1:M
               x_mean = x_mean + agents{j}.x(:, i); 
            end
            x_mean = x_mean/M;

            for j = 1:M
                agents{j}.x(:, i) = x_mean;
                agents{j}.err(:,i)=(norm(agents{j}.mdp.theta_st-agents{j}.x(:,i)))^2;
            end
         end
    end
    
    for j = 1:M
       agents{j}.avg_err = agents{j}.err; 
       agents{j}.cell_record{1} = agents{j}.err;
    end
    
elseif strcmp(method, 'iid')
    for k = 1:num_epoch
        fprintf('epoch num: %d \n', k);

        % reset err
        for j = 1:M
            agents{j}.err = zeros(1, T);
        end          
        
        for i=1:T
            if mod(i,1000)==0
                disp(i)
            end
            for j = 1:M
                % Generate current state s_t from stationary dist
                agent = agents{j};
                p = agent.mdp.p;
                                
                R = agent.mdp.R; P = agent.mdp.P; phi = agent.mdp.phi; 
                gamma = agent.mdp.gamma; r = agent.r; alpha = agent.alpha;
                theta_st = agent.mdp.theta_st;

                h=cumsum(p);
                z=rand(1);
                s_old=find(h > z, 1);
                % Generating the next state s_t+1
                d=P(s_old,:); % distribution of s_t+1|s_t
                h=cumsum(d);
                z=rand(1);
                s_new=find(h > z, 1); % new state s_t+1
                rew=R(s_old,1) + 0.1*normrnd(0,1); % current reward
                g=(rew+gamma*(phi(s_new,:))*agent.x(:,i)-(phi(s_old,:))*agent.x(:,i))*(phi(s_old,:))';
                agent.x(:,i+1) = agent.x(:,i)+alpha*g;
                agent.err(:,i)=(norm(theta_st-agent.x(:,i)))^2;
                agents{j} = agent;
            end
            
            if mod(i, K) == 0
                % synchronize 
                x_mean = zeros(r, 1);
                for j = 1:M
                   x_mean = x_mean + agents{j}.x(:, i); 
                end
                x_mean = x_mean/M;

                for j = 1:M
                    agents{j}.x(:, i) = x_mean;
                    agents{j}.err(:,i)=(norm(agents{j}.mdp.theta_st-agents{j}.x(:,i)))^2;
                end
            end
        end
        
        
        
        for j = 1:M
           agents{j}.avg_err = agents{j}.avg_err + agents{j}.err;
           agents{j}.err_record{k} = agents{j}.err;
        end
        
    end
    
    for j = 1:M
       agents{j}.avg_err = agents{j}.avg_err/num_epoch; 
    end
    
elseif strcmp(method, 'markov')
    for k = 1:num_epoch
        fprintf('epoch num: %d \n', k);
        % reset err
        for j = 1:M
            agents{j}.err = zeros(1, T);
        end
        
        for j = 1:M
            % initialize the state
            agents{j}.s = agents{j}.s_init;
        end
        
        for i=1:T
            if mod(i,1000)==0
                disp(i)
            end
            for j = 1:M
                % Generate current state s_t from stationary dist
                agent = agents{j};
                p = agent.mdp.p;
                                
                R = agent.mdp.R; P = agent.mdp.P; phi = agent.mdp.phi; 
                gamma = agent.mdp.gamma; r = agent.r; alpha = agent.alpha;
                theta_st = agent.mdp.theta_st;
                
                s_old = agent.s;
                
                % Generating the next state s_t+1
                d=P(s_old,:); % distribution of s_t+1|s_t
                h=cumsum(d);
                z=rand(1);
                s_new=find(h > z, 1); % new state s_t+1
                rew=R(s_old,1); % current reward
                g=(rew+gamma*(phi(s_new,:))*agent.x(:,i)-(phi(s_old,:))*agent.x(:,i))*(phi(s_old,:))';
                agent.x(:,i+1) = agent.x(:,i)+alpha*g;
                agent.err(:,i)=(norm(theta_st-agent.x(:,i)))^2;
                agent.s = s_new; % continuity of trajectory

                agents{j} = agent;
            end
            
            if mod(i, K) == 0
                % synchronize 
                x_mean = zeros(r, 1);
                for j = 1:M
                   x_mean = x_mean + agents{j}.x(:, i); 
                end
                x_mean = x_mean/M;

                for j = 1:M
                    agents{j}.x(:, i) = x_mean;
                    agents{j}.err(:,i)=(norm(agents{j}.mdp.theta_st-agents{j}.x(:,i)))^2;
                end
            end
        end
        
        for j = 1:M
           agents{j}.avg_err = agents{j}.avg_err + agents{j}.err;
           agents{j}.err_record{k} = agents{j}.err;
        end
        
    end
    
    for j = 1:M
       agents{j}.avg_err = agents{j}.avg_err/num_epoch; 
    end
    
else
    error('Method not implemented.')
    agents = [];
end


end

