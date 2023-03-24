%% Basic Setup for Temporal Difference Learning with Linear Function Approximation %%
% Markovian Setting
%------------------------------------------------------------------------------------%
clc; clear all; close all; %#ok<CLALL> 
S=100; % no of states
gamma=0.5; % discount factor
r=10; % rank of feature matrix

% Description of Notation
%--------------------------
% theta_st ---> True fixed point
% P ---> Transition matrix
% R ---> Reward vector
% p ---> Stationary distribution
% phi ---> Feature matrix 
[theta_st,P,R,p,phi]= markov_gen(S,gamma,r);
%--------------------------------------------------------------------------
% Mean-Path Setting
%--------------------------------------------------------------------------
T=1000; % no of iterations
D=zeros(S,S); % stores the elements of p
for i=1:S
D(i,i)=p(i);
end
x=zeros(r,T);
alpha=0.1;
err=zeros(1,T);
err(1,1)=(norm(theta_st))^2;
for i=1:T
    g=phi'*D*(R+gamma*P*phi*x(:,i)-phi*x(:,i));
    x(:,i+1)=x(:,i)+alpha*g;
    err(:,i)=(norm(theta_st-x(:,i)))^2;
end

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

%--------------------------------------------------------------------------
% IID Setting
%--------------------------------------------------------------------------
Ep=50; % no of epochs over which we average
avg_err=zeros(1,T);
for k=1:Ep
x=zeros(r,T);
alpha=0.1;
err=zeros(1,T);
err(1,1)=(norm(theta_st))^2;
for i=1:T
% Generate current state s_t from stationary dist
h=cumsum(p);
z=rand(1);
s_old=find(h > z, 1);
% Generating the next state s_t+1
d=P(s_old,:); % distribution of s_t+1|s_t
h=cumsum(d);
z=rand(1);
s_new=find(h > z, 1); % new state s_t+1
rew=R(s_old,1)+normrnd(0,1); % current reward
g=(rew+gamma*(phi(s_new,:))*x(:,i)-(phi(s_old,:))*x(:,i))*(phi(s_old,:))';
    x(:,i+1)=x(:,i)+alpha*g;
    err(:,i)=(norm(theta_st-x(:,i)))^2;
end
avg_err=avg_err+err;
end
figure
plot(avg_err/Ep, 'r', 'LineWidth',2);
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

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Markov Setting
%--------------------------------------------------------------------------
Ep=50; % no of epochs over which we average
avg_err=zeros(1,T);
for k=1:Ep
x=zeros(r,T);
alpha=0.1;
err=zeros(1,T);
err(1,1)=(norm(theta_st))^2;
s_old=1; % initialize from state 1
for i=1:T
% Generating the next state s_t+1
d=P(s_old,:); % distribution of s_t+1|s_t
h=cumsum(d);
z=rand(1);
s_new=find(h > z, 1); % new state s_t+1
rew=R(s_old,1); % current reward
g=(rew+gamma*(phi(s_new,:))*x(:,i)-(phi(s_old,:))*x(:,i))*(phi(s_old,:))';
    x(:,i+1)=x(:,i)+alpha*g;
    err(:,i)=(norm(theta_st-x(:,i)))^2;
s_old=s_new; % continuity of trajectory
end
avg_err=avg_err+err;
end
figure
plot(avg_err/Ep, 'b', 'LineWidth',2);
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