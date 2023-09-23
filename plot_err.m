clear all; close all;
rng(0)

%% Plot setup
set(0, 'DefaultAxesFontSize', 15, 'DefaultAxesFontName', 'times', 'DefaultAxesFontWeight', 'bold')
set(0, 'DefaultLineLineWidth', 2, 'DefaultAxesLineWidth', 1.5)
set(0, 'DefaultTextInterpreter', 'latex', 'DefaultTextFontName', 'times', 'DefaultTextFontWeight', 'bold')
set(0, 'DefaultLegendInterpreter', 'latex')

load data.mat

%% Plot the errors: Fixed N and e
switch opts.method
    case 'linear'
        plot_cus = @plot;
    case 'const'
        plot_cus = @semilogy;
end
rel_line = mean(results{1,1,1}{end}.avg_err(opts.T-100:opts.T));
for j = 1:length(Ns)
    for i = 1:length(epss)
        figure()
        for k = 1:length(epss_r)
            err = results{k,i,j}{end}.avg_err;
            plot_cus(K:K:opts.T, err(K:K:opts.T), 'DisplayName', sprintf('$\\epsilon_r = %.1f$', epss_r(k)));
            hold on
        end
        
        yline(rel_line,'r--', 'LineWidth',  2, 'DisplayName', '$N=1$')
        legend
        
        xlim([1 opts.T]);
        xlabel('${{t}}$', 'FontSize', 30);
        ylabel('$e_t$', 'FontSize', 30);
        grid on;
        title(sprintf('$N = %d, \\epsilon = %.1f$', Ns(j), epss(i)), 'Interpreter', 'latex', 'FontSize', 20);
        % pause
        
        ax = gca;
        outerpos = ax.OuterPosition;
        ti = ax.TightInset;
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
        ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
        ax.Position = [left bottom ax_width ax_height];
        exportgraphics(gca, sprintf('fig_td/Ne/%d_%.1f.png', Ns(j), epss(i)), 'Resolution', 600)
    end
end

%% Plot the errors: Fixed N and e1
for j = 1:length(Ns)
    for k = 1:length(epss_r)
        figure()
        for i = 1:length(epss)
            err = results{k,i,j}{end}.avg_err;
            plot_cus(K:K:opts.T, err(K:K:opts.T), 'DisplayName', sprintf('$\\epsilon = %.1f$', epss(i)));
            hold on
        end
        
        yline(rel_line,'r--', 'LineWidth',  2, 'DisplayName', '$N=1$')
        legend
        
        xlim([1 opts.T]);
        xlabel('${{t}}$', 'FontSize', 30);
        ylabel('$e_t$', 'FontSize', 30);
        grid on;
        title(sprintf('$N = %d, \\epsilon_r = %.1f$', Ns(j), epss_r(k)), 'Interpreter', 'latex', 'FontSize', 20);
        % pause
        
        ax = gca;
        outerpos = ax.OuterPosition;
        ti = ax.TightInset;
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
        ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
        ax.Position = [left bottom ax_width ax_height];
        exportgraphics(gca, sprintf('fig_td/Nr/%d_%.1f.png', Ns(j), epss_r(k)), 'Resolution', 600)
    end
end

%% Plot the errors: Fixed N
switch opts.method
    case 'linear'
        plot_cus = @plot;
    case 'const'
        plot_cus = @semilogy;
end
rel_line = mean(results{1,1,1}{end}.avg_err(opts.T-100:opts.T));
for j = 1:length(Ns)
    % for i = 1:length(epss)
        figure()
        for k = 1:length(epss_r)
            err = results{k,k,j}{end}.avg_err;
            plot_cus(K:K:opts.T, err(K:K:opts.T), 'DisplayName', sprintf('$\\epsilon = \\epsilon_r = %.1f$', epss_r(k)));
            %         err_mat = [];
            %         for k = 1:trajs*2
            %             err_mat = [err_mat; results{i,j}{end}.err_record{k}];
            %         end
            %         line = stdshade(err_mat(:,K:10*K:opts.T),0.5,colors(j),K:10*K:size(err_mat,2),12);
            %         set(gca, 'YScale', 'log')
            %         ylim([3e0,1.3e2])
            hold on
        end
        
        yline(rel_line,'r--', 'LineWidth',  2, 'DisplayName', '$N=1$')
        legend
        
        xlim([1 opts.T]);
        xlabel('${{t}}$', 'FontSize', 30);
        ylabel('$e_t$', 'FontSize', 30);
        grid on;
        title(sprintf('$N = %d$', Ns(j)), 'Interpreter', 'latex', 'FontSize', 20);
        % pause
        
        ax = gca;
        outerpos = ax.OuterPosition;
        ti = ax.TightInset;
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
        ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
        ax.Position = [left bottom ax_width ax_height];
        exportgraphics(gca, sprintf('fig_td/N/%d.png', Ns(j)), 'Resolution', 600)
    % end
end

%% Get Phi
[~,~,W] = eig(agents{1}.P);
p = abs(W(:,1)); p = p / sum(p);
D = diag(p);
Phi = zeros(S,d1*d2);
for s = 1:S
    Phi(s,:) = phi(s-1,0);
end
Phi = Phi(:,any(Phi,1));
Proj = Phi / (Phi' * D * Phi) * Phi' * D;
A = (eye(S) - gamma * Proj * agents{1}.P) * Phi;
b = Proj * agents{1}.R;
