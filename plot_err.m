close all;
rng(0)

%% Plot setup
set(0, 'DefaultAxesFontSize', 15, 'DefaultAxesFontName', 'times', 'DefaultAxesFontWeight', 'bold')
set(0, 'DefaultLineLineWidth', 2, 'DefaultAxesLineWidth', 1.5)
set(0, 'DefaultTextInterpreter', 'latex', 'DefaultTextFontName', 'times', 'DefaultTextFontWeight', 'bold')
set(0, 'DefaultLegendInterpreter', 'latex')

if ~exist('results', 'var') == 1
    load bkup/bkup2023925154454.mat
end

rel_line = reshape(cell2mat(results{1,1,1}{end}.err_record), 2e4, []);
rel_line = rel_line(opts.T-100:opts.T,:);
rel_line = mean(rel_line);
rel_line = repmat(rel_line, opts.T / K, 1);

switch opts.method
    case 'linear'
        plot_cus = @plot;
    case 'const'
        plot_cus = @semilogy;
end

%% Plot the errors: Fixed N and e
for j = 2:length(Ns)
    for i = 1:length(epss_p)
        figure('visible','off')
        ax = gca;
        for k = 1:length(epss_r)
            % err = results{k,i,j}{end}.avg_err;
            % plot_cus(K:K:opts.T, err(K:K:opts.T), 'DisplayName', sprintf('$\\epsilon_r = %.1f$', epss_r(k)));
            err = reshape(cell2mat(results{k,i,j}{end}.err_record), 2e4, []);
            varplot(K:K:opts.T, err(K:K:opts.T,:), 'DisplayName', sprintf('$\\epsilon_r = %.1f$', epss_r(k)));
            hold on
            ax.Children(1).EdgeColor = 'none';
            ax.Children(1).FaceAlpha = 0.2;
            ax.Children(1).HandleVisibility = 'off';
        end
        
        % yline(rel_line,'r--', 'LineWidth',  2, 'DisplayName', '$N=1$')
        varplot(K:K:opts.T, rel_line,'r--', 'LineWidth',  2, 'DisplayName', '$N=1$')
        ax.Children(1).EdgeColor = 'none';
        ax.Children(1).FaceAlpha = 0.2;
        ax.Children(1).HandleVisibility = 'off';
        legend
        
        xlim([1 opts.T]);
        xlabel('${{t}}$', 'FontSize', 25);
        ylabel('MSE', 'FontSize', 20);
        grid on;
        title(sprintf('$N = %d, \\epsilon_p = %.1f$', Ns(j), epss_p(i)), 'Interpreter', 'latex', 'FontSize', 20);
        % pause
        
        ax.YScale = "log";
        outerpos = ax.OuterPosition;
        ti = ax.TightInset;
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
        ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
        ax.Position = [left bottom ax_width ax_height];
        exportgraphics(gca, sprintf('fig_sarsa/Ne/%d_%.1f.png', Ns(j), epss_p(i)), 'Resolution', 600)
        savefig(sprintf('fig_sarsa/Ne/%d_%.1f.fig', Ns(j), epss_p(i)))
        fprintf('%d_%.1f saved\n', Ns(j), epss_p(i))
    end
end

%% Plot the errors: Fixed N and e1
for j = 2:length(Ns)
    for k = 1:length(epss_r)
        figure('visible','off')
        ax = gca;
        for i = 1:length(epss_p)
            % err = results{k,i,j}{end}.avg_err;
            % plot_cus(K:K:opts.T, err(K:K:opts.T), 'DisplayName', sprintf('$\\epsilon_p = %.1f$', epss_p(i)));
            err = reshape(cell2mat(results{k,i,j}{end}.err_record), 2e4, []);
            varplot(K:K:opts.T, err(K:K:opts.T,:), 'DisplayName', sprintf('$\\epsilon_p = %.1f$', epss_p(i)));
            hold on
            ax.Children(1).EdgeColor = 'none';
            ax.Children(1).FaceAlpha = 0.2;
            ax.Children(1).HandleVisibility = 'off';
        end
        
        varplot(K:K:opts.T, rel_line,'r--', 'LineWidth',  2, 'DisplayName', '$N=1$')
        ax.Children(1).EdgeColor = 'none';
        ax.Children(1).FaceAlpha = 0.2;
        ax.Children(1).HandleVisibility = 'off';
        legend
        
        xlim([1 opts.T]);
        xlabel('${{t}}$', 'FontSize', 25);
        ylabel('MSE', 'FontSize', 20);
        grid on;
        title(sprintf('$N = %d, \\epsilon_r = %.1f$', Ns(j), epss_r(k)), 'Interpreter', 'latex', 'FontSize', 20);
        % pause
        
        ax.YScale = "log";
        outerpos = ax.OuterPosition;
        ti = ax.TightInset;
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
        ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
        ax.Position = [left bottom ax_width ax_height];
        exportgraphics(gca, sprintf('fig_sarsa/Nr/%d_%.1f.png', Ns(j), epss_r(k)), 'Resolution', 600)
        savefig(sprintf('fig_sarsa/Nr/%d_%.1f.fig', Ns(j), epss_r(k)))
        fprintf('%d_%.1f saved\n', Ns(j), epss_r(k))
    end
end

%% Plot the errors: Fixed N
for j = 2:length(Ns)
    % for i = 1:length(epss_p)
        figure('Visible','off')
        ax = gca;
        for k = 1:length(epss_r)
            % err = results{k,k,j}{end}.avg_err;
            % plot_cus(K:K:opts.T, err(K:K:opts.T), 'DisplayName', sprintf('$\\epsilon_p = \\epsilon_r = %.1f$', epss_r(k)));
            err = reshape(cell2mat(results{k,k,j}{end}.err_record), 2e4, []);
            varplot(K:K:opts.T, err(K:K:opts.T,:), 'DisplayName', sprintf('$\\epsilon_p = \\epsilon_r = %.1f$', epss_r(k)));
            hold on
            ax.Children(1).EdgeColor = 'none';
            ax.Children(1).FaceAlpha = 0.2;
            ax.Children(1).HandleVisibility = 'off';
        end
        
        varplot(K:K:opts.T, rel_line,'r--', 'LineWidth',  2, 'DisplayName', '$N=1$')
        ax.Children(1).EdgeColor = 'none';
        ax.Children(1).FaceAlpha = 0.2;
        ax.Children(1).HandleVisibility = 'off';
        legend
        
        xlim([1 opts.T]);
        xlabel('${{t}}$', 'FontSize', 25);
        ylabel('MSE', 'FontSize', 20);
        grid on;
        title(sprintf('$N = %d$', Ns(j)), 'Interpreter', 'latex', 'FontSize', 20);
        % pause
        
        ax.YScale = "log";
        outerpos = ax.OuterPosition;
        ti = ax.TightInset;
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
        ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
        ax.Position = [left bottom ax_width ax_height];
        exportgraphics(gca, sprintf('fig_sarsa/N/%d.png', Ns(j)), 'Resolution', 600)
        savefig(sprintf('fig_sarsa/N/%d.fig', Ns(j)))
        fprintf('%d saved\n', Ns(j))
    % end
end

%% Plot the errors: Fixed ep and er
for i = 1:length(epss_p)
    for k = 1:length(epss_r)
        figure('visible','off')
        % figure
        ax = gca;
        for j = 1:length(Ns)
            % err = results{k,i,j}{end}.avg_err;
            err = reshape(cell2mat(results{k,i,j}{end}.err_record), 2e4, []);
            varplot(K:K:opts.T, err(K:K:opts.T,:), 'DisplayName', sprintf('$N = %d$', Ns(j)));
            hold on
            ax.Children(1).EdgeColor = 'none';
            % ax.Children(1).FaceAlpha = 0.2;
            ax.Children(1).HandleVisibility = 'off';
        end
        legend
        
        ax.YScale = 'log';
        xlim([1 opts.T]);
        xlabel('${{t}}$', 'FontSize', 25);
        ylabel('MSE', 'FontSize', 20);
        grid on;
        % title(sprintf('$\\epsilon_p = %.1f, \\epsilon_r = %.1f$', epss_p(i), epss_r(k)), 'Interpreter', 'latex', 'FontSize', 20);
        % pause
        
        outerpos = ax.OuterPosition;
        ti = ax.TightInset;
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
        ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
        ax.Position = [left bottom ax_width ax_height];
        exportgraphics(gca, sprintf('fig_sarsa/e/%.1f_%.1f.png', epss_p(i), epss_r(k)), 'Resolution', 600)
        savefig(sprintf('fig_sarsa/e/%.1f_%.1f.fig', epss_p(i), epss_r(k)))
        fprintf('%.1f_%.1f saved\n', epss_p(i), epss_r(k))
    end
end
