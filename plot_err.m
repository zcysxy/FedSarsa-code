clear all; close all;
rng(0)

%% Plot setup
set(0, 'DefaultAxesFontSize', 15, 'DefaultAxesFontName', 'times', 'DefaultAxesFontWeight', 'bold')
set(0, 'DefaultLineLineWidth', 2, 'DefaultAxesLineWidth', 1.5)
set(0, 'DefaultTextInterpreter', 'latex', 'DefaultTextFontName', 'times', 'DefaultTextFontWeight', 'bold')
set(0, 'DefaultLegendInterpreter', 'latex')

if ~exist('results', 'var') == 1
    load bkup/bkup202392831946.mat
end

rel_line = mean(results{1,1,1}{end}.avg_err(opts.T-100:opts.T));

switch opts.method
    case 'linear'
        plot_cus = @plot;
    case 'const'
        plot_cus = @semilogy;
end
%
% %% Plot the errors: Fixed N and e
% for j = 2:length(Ns)
%     for i = 1:length(epss_p)
%         figure('visible','off')
%         for k = 1:length(epss_r)
%             err = results{k,i,j}{end}.avg_err;
%             plot_cus(K:K:opts.T, err(K:K:opts.T), 'DisplayName', sprintf('$\\epsilon_r = %.1f$', epss_r(k)));
%             hold on
%         end
%         
%         yline(rel_line,'r--', 'LineWidth',  2, 'DisplayName', '$N=1$')
%         legend
%         
%         xlim([1 opts.T]);
%         xlabel('${{t}}$', 'FontSize', 25);
%         ylabel('MSE', 'FontSize', 20);
%         grid on;
%         % title(sprintf('$N = %d, \\epsilon_p = %.1f$', Ns(j), epss_p(i)), 'Interpreter', 'latex', 'FontSize', 20);
%         % pause
%         
%         ax = gca;
%         outerpos = ax.OuterPosition;
%         ti = ax.TightInset;
%         left = outerpos(1) + ti(1);
%         bottom = outerpos(2) + ti(2);
%         ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
%         ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
%         ax.Position = [left bottom ax_width ax_height];
%         exportgraphics(gca, sprintf('fig_td/Ne/%d_%.1f.png', Ns(j), epss_p(i)), 'Resolution', 600)
%         savefig(sprintf('fig_td/Ne/%d_%.1f.fig', Ns(j), epss_p(i)))
%         fprintf('%d_%.1f saved\n', Ns(j), epss_p(i))
%     end
% end
%
% %% Plot the errors: Fixed N and e1
% for j = 2:length(Ns)
%     for k = 1:length(epss_r)
%         figure('visible','off')
%         for i = 1:length(epss_p)
%             err = results{k,i,j}{end}.avg_err;
%             plot_cus(K:K:opts.T, err(K:K:opts.T), 'DisplayName', sprintf('$\\epsilon_p = %.1f$', epss_p(i)));
%             hold on
%         end
%         
%         yline(rel_line,'r--', 'LineWidth',  2, 'DisplayName', '$N=1$')
%         legend
%         
%         xlim([1 opts.T]);
%         xlabel('${{t}}$', 'FontSize', 25);
%         ylabel('MSE', 'FontSize', 20);
%         grid on;
%         % title(sprintf('$N = %d, \\epsilon_r = %.1f$', Ns(j), epss_r(k)), 'Interpreter', 'latex', 'FontSize', 20);
%         % pause
%         
%         ax = gca;
%         outerpos = ax.OuterPosition;
%         ti = ax.TightInset;
%         left = outerpos(1) + ti(1);
%         bottom = outerpos(2) + ti(2);
%         ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
%         ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
%         ax.Position = [left bottom ax_width ax_height];
%         exportgraphics(gca, sprintf('fig_td/Nr/%d_%.1f.png', Ns(j), epss_r(k)), 'Resolution', 600)
%         savefig(sprintf('fig_td/Nr/%d_%.1f.fig', Ns(j), epss_r(k)))
%         fprintf('%d_%.1f saved\n', Ns(j), epss_r(k))
%     end
% end
%
% %% Plot the errors: Fixed N
% for j = 2:length(Ns)
%     % for i = 1:length(epss_p)
%         figure('visible','off')
%         for k = 1:length(epss_r)
%             err = results{k,k,j}{end}.avg_err;
%             plot_cus(K:K:opts.T, err(K:K:opts.T), 'DisplayName', sprintf('$\\epsilon_p = \\epsilon_r = %.1f$', epss_r(k)));
%             %         err_mat = [];
%             %         for k = 1:trajs*2
%             %             err_mat = [err_mat; results{i,j}{end}.err_record{k}];
%             %         end
%             %         line = stdshade(err_mat(:,K:10*K:opts.T),0.5,colors(j),K:10*K:size(err_mat,2),12);
%             %         set(gca, 'YScale', 'log')
%             %         ylim([3e0,1.3e2])
%             hold on
%         end
%         
%         yline(rel_line,'r--', 'LineWidth',  2, 'DisplayName', '$N=1$')
%         legend
%         
%         xlim([1 opts.T]);
%         xlabel('${{t}}$', 'FontSize', 25);
%         ylabel('MSE', 'FontSize', 20);
%         grid on;
%         % title(sprintf('$N = %d$', Ns(j)), 'Interpreter', 'latex', 'FontSize', 20);
%         % pause
%         
%         ax = gca;
%         outerpos = ax.OuterPosition;
%         ti = ax.TightInset;
%         left = outerpos(1) + ti(1);
%         bottom = outerpos(2) + ti(2);
%         ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
%         ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
%         ax.Position = [left bottom ax_width ax_height];
%         exportgraphics(gca, sprintf('fig_td/N/%d.png', Ns(j)), 'Resolution', 600)
%         savefig(sprintf('fig_td/N/%d.fig', Ns(j)))
%         fprintf('%d saved\n', Ns(j))
%     % end
% end

%% Plot the errors: Fixed ep and er
for i = 1:length(epss_p)
    for k = 1:length(epss_r)
        figure('visible','off')
        for j = 1:length(Ns)
            err = results{k,i,j}{end}.avg_err;
            plot_cus(K:K:opts.T, err(K:K:opts.T), 'DisplayName', sprintf('$N = %d$', Ns(j)));
            hold on
        end
        legend
        
        xlim([1 opts.T]);
        xlabel('${{t}}$', 'FontSize', 25);
        ylabel('MSE', 'FontSize', 20);
        grid on;
        % title(sprintf('$\\epsilon_p = %.1f, \\epsilon_r = %.1f$', epss_p(i), epss_r(k)), 'Interpreter', 'latex', 'FontSize', 20);
        % pause
        
        ax = gca;
        outerpos = ax.OuterPosition;
        ti = ax.TightInset;
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        ax_width = outerpos(3) - ti(1) - ti(3) - 0.01;
        ax_height = outerpos(4) - ti(2) - ti(4) - 0.01;
        ax.Position = [left bottom ax_width ax_height];
        exportgraphics(gca, sprintf('fig_ql/e/%.1f_%.1f.png', epss_p(i), epss_r(k)), 'Resolution', 600)
        savefig(sprintf('fig_td/e/%.1f_%.1f.fig', epss_p(i), epss_r(k)))
        fprintf('%.1f_%.1f saved\n', epss_p(i), epss_r(k))
    end
end
