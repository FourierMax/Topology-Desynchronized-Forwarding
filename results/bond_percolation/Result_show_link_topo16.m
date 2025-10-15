%% Load MPC0 packet loss rate data
load link_16_Dropped_rate_MPC0;
link_16_Dropped_rate_MPC0 = Dropped_rate_MPC0;

%% Load MPC1_side packet loss rate data
load link_16_Dropped_rate_MPC1_side;
link_16_Dropped_rate_MPC1_side = Dropped_rate_MPC1_side;

%% Load MPC1_oppo packet loss rate data
load link_16_Dropped_rate_MPC1_oppo;
link_16_Dropped_rate_MPC1_oppo = Dropped_rate_MPC1_oppo;

%% Load LFA packet loss rate data
load link_16_Dropped_rate_LFA;
link_16_Dropped_rate_LFA = Dropped_rate_LFA;

%% Load MPC0 maximum hop count data
load link_16_Average_Max_Hops_MPC0;
link_16_Average_Max_Hops_MPC0 = Average_Max_Hops_MPC0;

%% Load MPC1_side maximum hop count data
load link_16_Average_Max_Hops_MPC1_side;
link_16_Average_Max_Hops_MPC1_side = Average_Max_Hops_MPC1_side;

%% Load MPC1_oppo maximum hop count data
load link_16_Average_Max_Hops_MPC1_oppo;
link_16_Average_Max_Hops_MPC1_oppo = Average_Max_Hops_MPC1_oppo;

%% Load LFA packet maximum hop count data
load link_16_Average_Max_Hops_LFA;
link_16_Average_Max_Hops_LFA = Average_Max_Hops_LFA;

%% Load MPC1_oppo IF hop count ratio data
load link_16_IF_Forward_hops_rate_MPC1_oppo;
link_16_IF_Forward_hops_rate_MPC1_oppo = IF_Forward_hops_rate_MPC1_oppo;

%% Load MPC1_side IF hop count ratio data
load link_16_IF_Forward_hops_rate_MPC1_side;
link_16_IF_Forward_hops_rate_MPC1_side = IF_Forward_hops_rate_MPC1_side;

%% Load MPC1_side maximum hop count data
load link_16_IF_Forward_packets_rate_MPC1_side;
link_16_IF_Forward_packets_rate_MPC1_side = IF_Forward_packets_rate_MPC1_side;

%% Load MPC1_oppo maximum hop count data
load link_16_IF_Forward_packets_rate_MPC1_oppo;
link_16_IF_Forward_packets_rate_MPC1_oppo = IF_Forward_packets_rate_MPC1_oppo;

%% Define X-axis vectors (ensure column vector format)
X1 = 0.0001:0.0001:0.01;  % 100 points, from 0.0001 to 0.01
X2 = 0.001:0.001:0.1;     % 100 points, from 0.001 to 0.1
X3 = 0.01:0.01:1;         % 100 points, from 0.01 to 1
X4 = [X1,X2(11:100),X3(11:100)];
X = X4(:);  % Force conversion to column vector
LOGX = log10(X);

%% Set global plotting parameters
set(0, 'DefaultAxesFontName', 'Times New Roman', 'DefaultTextFontName', 'Times New Roman');
set(0, 'DefaultAxesFontSize', 20, 'DefaultTextFontSize', 20);
set(0, 'DefaultAxesFontWeight', 'bold', 'DefaultTextFontWeight', 'bold');

%% Define fitting options and style parameters
fit_options = fitoptions('Method', 'NonlinearLeastSquares', 'Display', 'off');
fit_type_exp = fittype('a*exp(b*x)+ c*exp(d*x)', 'options', fit_options);
fit_type_exp1 = fittype('exp1');
fit_type_poly1 = fittype('poly1');
fit_type_poly2 = fittype('poly2'); % Quadratic polynomial
fit_type_power1 = fittype('power1');
fit_type_power2 = fittype('power2');
fit_type_linear = fittype({'(sin(x-pi))', '((x-10)^2)', '1'}, 'independent', 'x', 'dependent', 'y', 'coefficients', {'a', 'b', 'c'}); % Define linear fitting type
fit_type_gauss1 = fittype('gauss1');
fit_type_gauss2 = fittype('gauss2');
gauss2opts = fitoptions('Method', 'NonlinearLeastSquares');
gauss2opts.Display = 'Off';
gauss2opts.Lower = [-Inf -Inf 0 -Inf -Inf 0];
gauss2opts.StartPoint = [40.6666666666667 0.014 0.00796852649449246 36.5285783881755 0.033 0.0111119879651678];
fit_type_gauss4 = fittype('gauss4');
fit_type_gauss5 = fittype('gauss5');
fit_type_gauss7 = fittype('gauss7');

%% Set global plotting parameters - Nature style
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultTextFontName', 'Arial');
set(0, 'DefaultAxesFontSize', 8, 'DefaultTextFontSize', 8);
set(0, 'DefaultAxesFontWeight', 'normal', 'DefaultTextFontWeight', 'normal');

% Nature color scheme
nature_colors = [
    0.90, 0.29, 0.23;  % Red
    0.18, 0.45, 0.71;  % Blue  
    0.15, 0.68, 0.38;  % Green
    0.84, 0.37, 0.00;  % Orange
    0.58, 0.41, 0.70;  % Purple
    0.55, 0.55, 0.55   % Gray
];

% Nature style configuration
plot_styles = struct(...
    'MPC0',  struct('color', nature_colors(1,:), 'marker', 'o', 'line', '-',  'size', 20),...
    'MPC1',  struct('color', nature_colors(2,:), 'marker', 's', 'line', '--', 'size', 20),...
    'LFA',   struct('color', nature_colors(2,:), 'marker', '^', 'line', '-.', 'size', 20),...
    'MPC1_oppo',  struct('color', nature_colors(3,:), 'marker', 'd', 'line', ':',  'size', 20),...
    'MPC1_side',  struct('color', nature_colors(5,:), 'marker', 'v', 'line', '-',  'size', 20));

line_width = 1.5;  % Nature style thinner lines
marker_line_width = 0.8;  % Marker edge line width
font_size = 11;           % Larger font
legend_font_size = 9;     % Legend font
axis_line_width = 0.8;    % Coordinate axis line width

%% =============== Packet loss rate performance plot - Nature style ===============
figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points'); % Nature standard dimensions
hold on;
xlim([-4,0]);

% MPC0
[fit_MPC0, gof_MPC0] = fit(LOGX, Dropped_rate_MPC0, fit_type_gauss2);
h1 = plot(fit_MPC0);
set(h1, 'Color', plot_styles.MPC0.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC0.line);

% Data points - Nature style (filled markers)
scatter(LOGX, Dropped_rate_MPC0, plot_styles.MPC0.size, ...
    plot_styles.MPC0.color, plot_styles.MPC0.marker, 'filled', ...
    'MarkerEdgeColor', plot_styles.MPC0.color, 'LineWidth', marker_line_width);

% LFA
[fit_LFA, gof_LFA] = lossrate_LFA_2(LOGX, Dropped_rate_LFA);
h3 = plot(fit_LFA);
set(h3, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);
scatter(LOGX, Dropped_rate_LFA, plot_styles.LFA.size, ...
    plot_styles.LFA.color, plot_styles.LFA.marker, 'filled', ...
    'MarkerEdgeColor', plot_styles.LFA.color, 'LineWidth', marker_line_width);

% MPC1_oppo
[fit_MPC1_oppo, gof_MPC1_oppo] = lossrate_MPC1oppo_2(LOGX, Dropped_rate_MPC1_oppo);
h4 = plot(fit_MPC1_oppo);
set(h4, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);
scatter(LOGX, Dropped_rate_MPC1_oppo, plot_styles.MPC1_oppo.size, ...
    plot_styles.MPC1_oppo.color, plot_styles.MPC1_oppo.marker, 'filled', ...
    'MarkerEdgeColor', plot_styles.MPC1_oppo.color, 'LineWidth', marker_line_width);

% MPC1_side
[fit_MPC1_side, gof_MPC1_side] = lossrate_MPC1side_2(LOGX, Dropped_rate_MPC1_side);
h4 = plot(fit_MPC1_side);
set(h4, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);
scatter(LOGX, Dropped_rate_MPC1_side, plot_styles.MPC1_side.size, ...
    plot_styles.MPC1_side.color, plot_styles.MPC1_side.marker, 'filled', ...
    'MarkerEdgeColor', plot_styles.MPC1_side.color, 'LineWidth', marker_line_width);

% Nature style graphics beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width ,'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation x-coordinate
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Packet loss rate', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend (no border, optimized position)
legend({'NF (Fit)', 'NF (Data)', ...
        'LFA (Fit)', 'LFA (Data)', ...
        'RF-CF (Fit)', 'RF-CF (Data)', ...
        'RF-LF (Fit)', 'RF-LF (Data)'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

% Remove title (Nature usually explains in figure notes)
% title('');

grid off; % Nature typically doesn't use grid

% Set graphics to Nature standard dimensions
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters'); % Use vector renderer

%% =============== Save images according to Nature requirements ===============
% Nature journal image requirements:
% - Resolution: 300-600 DPI (bitmap) or vector format
% - Format: TIFF/EPS/PDF (recommended vector format)
% - Dimensions: Single column 8.6 cm wide, double column 17.8 cm wide
% - Fonts: Embed all fonts

% Set image dimensions (single column 8.6 cm wide)
figure_width_cm = 17.8; % Nature single column width
figure_height_cm = 12;  % Adjust height based on content
figure_width_inch = figure_width_cm / 2.54;
figure_height_inch = figure_height_cm / 2.54;

% Reset graphics dimensions
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

% Save in multiple formats to meet different requirements

% 1. Save as high resolution TIFF (for review)
print('-dtiff', '-r600', 'packet_loss_rate_nature.tif');
fprintf('Saved high resolution TIFF: packet_loss_rate_nature.tif (600 DPI)\n');

% 2. Save as EPS (vector format, for typesetting)
print('-depsc', '-r600', 'packet_loss_rate_nature.eps');
fprintf('Saved EPS vector image: packet_loss_rate_nature.eps\n');

% 3. Save as PDF (vector format, backup)
print('-dpdf', '-r600', 'packet_loss_rate_nature.pdf');
fprintf('Saved PDF vector image: packet_loss_rate_nature.pdf\n');

% 4. Save as PNG (for preview)
print('-dpng', '-r300', 'packet_loss_rate_nature.png');
fprintf('Saved PNG preview image: packet_loss_rate_nature.png (300 DPI)\n');

% Set graphics properties to ensure font embedding
set(gcf, 'Renderer', 'painters'); % Use vector renderer

% Check file sizes
files = {'packet_loss_rate_link_16.tif', 'packet_loss_rate_link_16.eps', ...
         'packet_loss_rate_link_16.pdf', 'packet_loss_rate_link_16.png'};
for i = 1:length(files)
    if exist(files{i}, 'file')
        file_info = dir(files{i});
        file_size_mb = file_info.bytes / (1024 * 1024);
        fprintf('File %s size: %.2f MB\n', files{i}, file_size_mb);
    end
end

fprintf('\nImage saving completed! Recommended to submit EPS or PDF format for publication.\n');

%% =============== Maximum hops performance plot - Nature style ===============
figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points');
hold on;
xlim([0.0001, max(X)]);

% MPC0
[fit_Max_hops_MPC0, gof_Max_hops_MPC0] = fit(X, Average_Max_Hops_MPC0, fit_type_gauss4);
h1 = plot(fit_Max_hops_MPC0);
set(h1, 'Color', plot_styles.MPC0.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC0.line);
scatter(X, Average_Max_Hops_MPC0, plot_styles.MPC0.size, ...
    plot_styles.MPC0.color, plot_styles.MPC0.marker, 'filled', ...
    'MarkerEdgeColor', plot_styles.MPC0.color, 'LineWidth', marker_line_width);

% LFA
[fit_Max_hops_LFA, gof_Max_hops_LFA] = fit(X, Average_Max_Hops_LFA, fit_type_gauss4);
h3 = plot(fit_Max_hops_LFA);
set(h3, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);
scatter(X, Average_Max_Hops_LFA, plot_styles.LFA.size, ...
    plot_styles.LFA.color, plot_styles.LFA.marker, 'filled', ...
    'MarkerEdgeColor', plot_styles.LFA.color, 'LineWidth', marker_line_width);

% MPC1_oppo
[fit_Max_hops_MPC1_oppo, gof_Max_hops_MPC1_oppo] = fit(X, Average_Max_Hops_MPC1_oppo, fit_type_gauss4);
h4 = plot(fit_Max_hops_MPC1_oppo);
set(h4, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);
scatter(X, Average_Max_Hops_MPC1_oppo, plot_styles.MPC1_oppo.size, ...
    plot_styles.MPC1_oppo.color, plot_styles.MPC1_oppo.marker, 'filled', ...
    'MarkerEdgeColor', plot_styles.MPC1_oppo.color, 'LineWidth', marker_line_width);

% MPC1_side
[fit_Max_hops_MPC1_side, gof_Max_hops_MPC1_side] = fit(X, Average_Max_Hops_MPC1_side, fit_type_gauss4);
h5 = plot(fit_Max_hops_MPC1_side);
set(h5, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);
scatter(X, Average_Max_Hops_MPC1_side, plot_styles.MPC1_side.size, ...
    plot_styles.MPC1_side.color, plot_styles.MPC1_side.marker, 'filled', ...
    'MarkerEdgeColor', plot_styles.MPC1_side.color, 'LineWidth', marker_line_width);

% Nature style graphics beautification
set(gca, 'LineWidth', axis_line_width, 'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation x-coordinate
set(gca, 'XTick', [0.0001, 0.001, 0.01, 0.1, 1]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});
set(gca, 'XScale', 'log');  % Set X-axis to logarithmic scale

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Maximum hops', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend
legend({'NF (Fit)', 'NF (Data)', ...
        'LFA (Fit)', 'LFA (Data)', ...
        'RF-CF (Fit)', 'RF-CF (Data)', ...
        'RF-LF (Fit)', 'RF-LF (Data)'}, ...
    'Location', 'northeast', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off;

% Set graphics to Nature standard dimensions
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters');

% Save images
figure_width_cm = 17.8;
figure_height_cm = 12;
figure_width_inch = figure_width_cm / 2.54;
figure_height_inch = figure_height_cm / 2.54;

set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

print('-dtiff', '-r600', 'max_hops_link_16.tif');
print('-depsc', '-r600', 'max_hops_link_16.eps');
print('-dpdf', '-r600', 'max_hops_link_16.pdf');
print('-dpng', '-r300', 'max_hops_link_16.png');

%% =============== IF forwarding hops ratio plot - Nature style ===============
figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points');
hold on;
xlim([-4,0]);

% MPC1_oppo
[fit_IF_Forward_hops_MPC1_oppo, gof_IF_Forward_hops_MPC1_oppo] = fit(LOGX, IF_Forward_hops_rate_MPC1_oppo, fit_type_gauss2);
h2 = plot(fit_IF_Forward_hops_MPC1_oppo);
set(h2, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);
scatter(LOGX, IF_Forward_hops_rate_MPC1_oppo, plot_styles.MPC1_oppo.size, ...
    plot_styles.MPC1_oppo.color, plot_styles.MPC1_oppo.marker, 'filled', ...
    'MarkerEdgeColor', plot_styles.MPC1_oppo.color, 'LineWidth', marker_line_width);

% MPC1_side
[fit_IF_Forward_hops_MPC1_side, gof_IF_Forward_hops_MPC1_side] = fit(LOGX, IF_Forward_hops_rate_MPC1_side, fit_type_gauss2);
h3 = plot(fit_IF_Forward_hops_MPC1_side);
set(h3, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);
scatter(LOGX, IF_Forward_hops_rate_MPC1_side, plot_styles.MPC1_side.size, ...
    plot_styles.MPC1_side.color, plot_styles.MPC1_side.marker, 'filled', ...
    'MarkerEdgeColor', plot_styles.MPC1_side.color, 'LineWidth', marker_line_width);

% Nature style graphics beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width, 'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation x-coordinate
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('RF hops ratio', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend
legend({'RF-CF (Fit)', 'RF-CF (Data)', ...
        'RF-LF (Fit)', 'RF-LF (Data)'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off;

% Set graphics to Nature standard dimensions
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters');

% Save images
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

print('-dtiff', '-r600', 'if_hops_ratio_link_16.tif');
print('-depsc', '-r600', 'if_hops_ratio_link_16.eps');
print('-dpdf', '-r600', 'if_hops_ratio_link_16.pdf');
print('-dpng', '-r300', 'if_hops_ratio_link_16.png');

%% =============== IF forwarding packets ratio plot - Nature style ===============
figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points');
hold on;
xlim([-4,0]);

% MPC1_oppo
[fit_IF_Forward_packets_MPC1_oppo, gof_IF_Forward_packets_MPC1_oppo] = fit(LOGX, IF_Forward_packets_rate_MPC1_oppo, fit_type_gauss2);
h2 = plot(fit_IF_Forward_packets_MPC1_oppo);
set(h2, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);
scatter(LOGX, IF_Forward_packets_rate_MPC1_oppo, plot_styles.MPC1_oppo.size, ...
    plot_styles.MPC1_oppo.color, plot_styles.MPC1_oppo.marker, 'filled', ...
    'MarkerEdgeColor', plot_styles.MPC1_oppo.color, 'LineWidth', marker_line_width);

% MPC1_side
[fit_IF_Forward_packets_MPC1_side, gof_IF_Forward_packets_MPC1_side] = fit(LOGX, IF_Forward_packets_rate_MPC1_side, fit_type_gauss2);
h3 = plot(fit_IF_Forward_packets_MPC1_side);
set(h3, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);
scatter(LOGX, IF_Forward_packets_rate_MPC1_side, plot_styles.MPC1_side.size, ...
    plot_styles.MPC1_side.color, plot_styles.MPC1_side.marker, 'filled', ...
    'MarkerEdgeColor', plot_styles.MPC1_side.color, 'LineWidth', marker_line_width);

% Nature style graphics beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width, 'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation x-coordinate
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('RF packets ratio', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend
legend({'RF-CF (Fit)', 'RF-CF (Data)', ...
        'RF-LF (Fit)', 'RF-LF (Data)'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off;

% Set graphics to Nature standard dimensions
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters');

% Save images
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

print('-dtiff', '-r600', 'if_packets_ratio_link_16.tif');
print('-depsc', '-r600', 'if_packets_ratio_link_16.eps');
print('-dpdf', '-r600', 'if_packets_ratio_link_16.pdf');
print('-dpng', '-r300', 'if_packets_ratio_link_16.png');