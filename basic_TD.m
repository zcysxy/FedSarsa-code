%% Basic Setup for Temporal Difference Learning with Linear Function Approximation %%
% Markovian Setting
%------------------------------------------------------------------------------------%
clc; clear all; close all; %#ok<CLALL>
set(0, 'DefaultAxesFontSize', 15, 'DefaultAxesFontName', 'times', 'DefaultAxesFontWeight', 'bold')
set(0, 'DefaultLineLineWidth', 2, 'DefaultAxesLineWidth', 1.5)
set(0, 'DefaultTextInterpreter', 'latex', 'DefaultTextFontName', 'times', 'DefaultTextFontWeight', 'bold')

S = 100; % no of states
gamma = 0.5; % discount factor
r = 10; % rank of feature matrix

% Description of Notation
%--------------------------
% theta_st ---> True fixed point
% P ---> Transition matrix
% R ---> Reward vector
% p ---> Stationary distribution
% phi ---> Feature matrix
[theta_st, P, R, p, phi] = markov_gen(S, gamma, r);

%%
%--------------------------------------------------------------------------
% Mean-Path Setting
%--------------------------------------------------------------------------
T = 1000; % no of iterations
D = diag(p); % stores the elements of p
theta = zeros(r, T);
alpha = 0.1;
err = zeros(1, T);
err(1, 1) = (norm(theta_st)) ^ 2;

for i = 1:T
    % ϕᵀD(R + γPϕθ − ϕθ)
    g = phi' * D * (R + gamma * P * phi * theta(:, i) - phi * theta(:, i));
    theta(:, i + 1) = theta(:, i) + alpha * g;
    err(:, i) = (norm(theta_st - theta(:, i))) ^ 2;
end

figure
plot(err, 'Color', uint8([17 17 17]));
hold on;
xlim([1 T]);
xlabel('${{t}}$', 'FontSize', 30)
ylabel('$e_t$', 'FontSize', 30);
grid on;

ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
ax.Position = [left bottom ax_width ax_height];

%%
%--------------------------------------------------------------------------
% IID Setting
%--------------------------------------------------------------------------
trajs = 50; % no of trajectories over which we average
avg_err = zeros(1, T);

for k = 1:trajs
    theta = zeros(r, T);
    alpha = 0.1;
    err = zeros(1, T);
    err(1, 1) = norm(theta_st)^2;

    for i = 1:T
        % Generate current state s_t from stationary dist
        s_old = find(cumsum(p) > rand(1), 1);
        % Generating the next state s_t+1
        ps = P(s_old, :); % distribution of s_t+1|s_t
        s_new = find(cumsum(ps) > rand(1), 1); % new state s_t+1
        rew = R(s_old, 1) + normrnd(0, 1); % current reward
        % (R + γPϕθ − ϕθ) ϕᵀ
        g = (rew + gamma * phi(s_new, :) * theta(:, i) - phi(s_old, :) * theta(:, i)) * phi(s_old, :)';
        theta(:, i + 1) = theta(:, i) + alpha * g;
        err(:, i) = (norm(theta_st - theta(:, i))) ^ 2;
    end

    avg_err = avg_err + err;
end

figure
plot(avg_err / trajs, 'r');
hold on;
xlim([1 T]);
xlabel('${{t}}$', 'Interpreter', 'latex');
ylabel('$e_t$', 'Interpreter', 'latex');
grid on;

ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
ax.Position = [left bottom ax_width ax_height];

%%
%--------------------------------------------------------------------------
% Markov Setting
%--------------------------------------------------------------------------
trajs = 50; % no of epochs over which we average
avg_err = zeros(1, T);

for k = 1:trajs
    theta = zeros(r, T);
    alpha = 0.1;
    err = zeros(1, T);
    err(1, 1) = (norm(theta_st)) ^ 2;
    s_old = 1; % initialize from state 1

    for i = 1:T
        % Generating the next state s_t+1
        ps = P(s_old, :); % distribution of s_t+1|s_t
        s_new = find(cumsum(ps) > rand(1), 1); % new state s_t+1
        rew = R(s_old, 1); % current reward
        % (R + γPϕθ − ϕθ) ϕᵀ
        g = (rew + gamma * phi(s_new, :) * theta(:, i) - phi(s_old, :) * theta(:, i)) * phi(s_old, :)';
        theta(:, i + 1) = theta(:, i) + alpha * g;
        err(:, i) = (norm(theta_st - theta(:, i))) ^ 2;
        s_old = s_new; % continuity of trajectory
    end

    avg_err = avg_err + err;
end

figure
plot(avg_err / trajs, 'b');
hold on;
xlim([1 T]);
xlabel('${{t}}$', 'Interpreter', 'latex');
ylabel('$e_t$', 'Interpreter', 'latex');
grid on;

ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
ax.Position = [left bottom ax_width ax_height];
