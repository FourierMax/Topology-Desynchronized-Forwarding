close all; clear all;

LOG_AXES = 1; % Enable logarithmic axes

%% Load MPC1 IF hop count ratio data
load link_16_IF_Forward_hops_rate_MPC1;
link_16_IF_Forward_hops_rate_MPC1 = IF_Forward_hops_rate_MPC1;
load link_14_IF_Forward_hops_rate_MPC1;
link_14_IF_Forward_hops_rate_MPC1 = IF_Forward_hops_rate_MPC1;
load link_12_IF_Forward_hops_rate_MPC1
link_12_IF_Forward_hops_rate_MPC1 = IF_Forward_hops_rate_MPC1;
load link_10_IF_Forward_hops_rate_MPC1
link_10_IF_Forward_hops_rate_MPC1 = IF_Forward_hops_rate_MPC1;
load link_8_IF_Forward_hops_rate_MPC1
link_8_IF_Forward_hops_rate_MPC1 = IF_Forward_hops_rate_MPC1;

%% Load MPC1_side IF hop count ratio data
load link_16_IF_Forward_hops_rate_MPC1_side;
link_16_IF_Forward_hops_rate_MPC1_side = IF_Forward_hops_rate_MPC1_side;
load link_14_IF_Forward_hops_rate_MPC1_side;
link_14_IF_Forward_hops_rate_MPC1_side = IF_Forward_hops_rate_MPC1_side;
load link_12_IF_Forward_hops_rate_MPC1_side
link_12_IF_Forward_hops_rate_MPC1_side = IF_Forward_hops_rate_MPC1_side;
load link_10_IF_Forward_hops_rate_MPC1_side
link_10_IF_Forward_hops_rate_MPC1_side = IF_Forward_hops_rate_MPC1_side;
load link_8_IF_Forward_hops_rate_MPC1_side
link_8_IF_Forward_hops_rate_MPC1_side = IF_Forward_hops_rate_MPC1_side;

%% Load MPC1_oppo IF hop count ratio data
load link_16_IF_Forward_hops_rate_MPC1_oppo;
link_16_IF_Forward_hops_rate_MPC1_oppo = IF_Forward_hops_rate_MPC1_oppo;
load link_14_IF_Forward_hops_rate_MPC1_oppo;
link_14_IF_Forward_hops_rate_MPC1_oppo = IF_Forward_hops_rate_MPC1_oppo;
load link_12_IF_Forward_hops_rate_MPC1_oppo
link_12_IF_Forward_hops_rate_MPC1_oppo = IF_Forward_hops_rate_MPC1_oppo;
load link_10_IF_Forward_hops_rate_MPC1_oppo
link_10_IF_Forward_hops_rate_MPC1_oppo = IF_Forward_hops_rate_MPC1_oppo;
load link_8_IF_Forward_hops_rate_MPC1_oppo
link_8_IF_Forward_hops_rate_MPC1_oppo = IF_Forward_hops_rate_MPC1_oppo;

%% Load MPC1 maximum hop count data
load link_16_IF_Forward_packets_rate_MPC1;
link_16_IF_Forward_packets_rate_MPC1 = IF_Forward_packets_rate_MPC1;
load link_14_IF_Forward_packets_rate_MPC1;
link_14_IF_Forward_packets_rate_MPC1 = IF_Forward_packets_rate_MPC1;
load link_12_IF_Forward_packets_rate_MPC1
link_12_IF_Forward_packets_rate_MPC1 = IF_Forward_packets_rate_MPC1;
load link_10_IF_Forward_packets_rate_MPC1
link_10_IF_Forward_packets_rate_MPC1 = IF_Forward_packets_rate_MPC1;
load link_8_IF_Forward_packets_rate_MPC1
link_8_IF_Forward_packets_rate_MPC1 = IF_Forward_packets_rate_MPC1;

%% Load MPC1_side maximum hop count data
load link_16_IF_Forward_packets_rate_MPC1_side;
link_16_IF_Forward_packets_rate_MPC1_side = IF_Forward_packets_rate_MPC1_side;
load link_14_IF_Forward_packets_rate_MPC1_side;
link_14_IF_Forward_packets_rate_MPC1_side = IF_Forward_packets_rate_MPC1_side;
load link_12_IF_Forward_packets_rate_MPC1_side
link_12_IF_Forward_packets_rate_MPC1_side = IF_Forward_packets_rate_MPC1_side;
load link_10_IF_Forward_packets_rate_MPC1_side
link_10_IF_Forward_packets_rate_MPC1_side = IF_Forward_packets_rate_MPC1_side;
load link_8_IF_Forward_packets_rate_MPC1_side
link_8_IF_Forward_packets_rate_MPC1_side = IF_Forward_packets_rate_MPC1_side;

%% Load MPC1_oppo maximum hop count data
load link_16_IF_Forward_packets_rate_MPC1_oppo;
link_16_IF_Forward_packets_rate_MPC1_oppo = IF_Forward_packets_rate_MPC1_oppo;
load link_14_IF_Forward_packets_rate_MPC1_oppo;
link_14_IF_Forward_packets_rate_MPC1_oppo = IF_Forward_packets_rate_MPC1_oppo;
load link_12_IF_Forward_packets_rate_MPC1_oppo
link_12_IF_Forward_packets_rate_MPC1_oppo = IF_Forward_packets_rate_MPC1_oppo;
load link_10_IF_Forward_packets_rate_MPC1_oppo
link_10_IF_Forward_packets_rate_MPC1_oppo = IF_Forward_packets_rate_MPC1_oppo;
load link_8_IF_Forward_packets_rate_MPC1_oppo
link_8_IF_Forward_packets_rate_MPC1_oppo = IF_Forward_packets_rate_MPC1_oppo;

%% Data preprocessing (ensure column vector format)
X1 = 0.0001:0.0001:0.01;  % 100 points from 0.0001 to 0.01
X2 = 0.001:0.001:0.1;     % 100 points from 0.001 to 0.1
X3 = 0.01:0.01:1;         % 100 points from 0.01 to 1
X4 = [X1,X2(11:100),X3(11:100)];
X = X4(:);  % Convert to column vector
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
fit_type_linear = fittype({'(sin(x-pi))', '((x-10)^2)', '1'}, 'independent', 'x', 'dependent', 'y', 'coefficients', {'a', 'b', 'c'});
fit_type_gauss1 = fittype('gauss1');
fit_type_gauss2 = fittype('gauss2');
fit_type_gauss4 = fittype('gauss4');

gauss2opts = fitoptions('Method', 'NonlinearLeastSquares');
gauss2opts.Display = 'Off';
gauss2opts.Lower = [-Inf -Inf 0 -Inf -Inf 0];
gauss2opts.StartPoint = [40.6666666666667 0.014 0.00796852649449246 36.5285783881755 0.033 0.0111119879651678];

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

line_width = 1.5;           % Nature style thin lines
marker_line_width = 0.8;    % Marker border line width
font_size = 11;             % Slightly larger font
legend_font_size = 9;       % Legend font size
axis_line_width = 0.8;      % Axis line width

%% =============== MPC1_side IF packet forwarding ratio ===============
figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points'); % Nature standard size

% 8
[fit_Max_packets_side_8, gof_Max_packets_side_8] = fit(LOGX, link_8_IF_Forward_packets_rate_MPC1_side, fit_type_gauss4);
h1 = plot(fit_Max_packets_side_8);
set(h1, 'Color', plot_styles.MPC0.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC0.line);
hold on;

% 10
[fit_Max_packets_side_10, gof_Max_packets_side_10] = fit(LOGX, link_10_IF_Forward_packets_rate_MPC1_side, fit_type_gauss2);
h2 = plot(fit_Max_packets_side_10);
set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);

% 12
[fit_Max_packets_side_12, gof_Max_packets_side_12] = fit(LOGX, link_12_IF_Forward_packets_rate_MPC1_side, fit_type_gauss2);
h3 = plot(fit_Max_packets_side_12);
set(h3, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);

% 14
[fit_Max_packets_side_14, gof_Max_packets_side_14] = fit(LOGX, link_14_IF_Forward_packets_rate_MPC1_side, fit_type_gauss1);
h4 = plot(fit_Max_packets_side_14);
set(h4, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);

% 16
[fit_Max_packets_side_16, gof_Max_packets_side_16] = fit(LOGX, link_16_IF_Forward_packets_rate_MPC1_side, fit_type_gauss1);
h5 = plot(fit_Max_packets_side_16);
set(h5, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);

% Plot beautification
xlabel('Link Failure Probability', 'FontSize', 20, 'FontWeight', 'bold')
ylabel('IF Packets Percent', 'FontSize', 20, 'FontWeight', 'bold')
legend({'2 inter-orbit link',  ...
        '4 inter-orbit link',  ...
        '8 inter-orbit link', ...
        '15 inter-orbit link'}, ...
        'Location', 'northwest', 'FontSize', 14, 'NumColumns', 2);
grid on;
set(gca, 'LineWidth', 1.5, 'Box', 'on');

if LOG_AXES == 1
    set(gca, 'XTick', [-4,-3,-2,-1,0]); % Set tick labels
end

% Nature style plot beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width ,'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation for x-axis
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('RF packets ratio (%)', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend (no border, optimized position)
legend({'8 x 8',  ...
        '10 x 10',  ...
        '12 x 12', ...
        '14 x 14', ...
        '16 x 16'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off; % Nature typically doesn't use grid

% Set figure to Nature standard size
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters'); % Use vector renderer

%% =============== Save images according to Nature requirements ===============
% Nature journal image requirements:
% - Resolution: 300-600 DPI (bitmap) or vector format
% - Format: TIFF/EPS/PDF (recommended vector format)
% - Size: Single column 8.6 cm wide, double column 17.8 cm wide
% - Font: Embed all fonts

% Set image size (single column 8.6 cm wide)
figure_width_cm = 17.8; % Nature single column width
figure_height_cm = 12;  % Adjust height according to content
figure_width_inch = figure_width_cm / 2.54;
figure_height_inch = figure_height_cm / 2.54;

% Reset figure size
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

% Save in multiple formats to meet different needs

% 1. Save as high-resolution TIFF (for review)
print('-dtiff', '-r600', 'RF_packets_ratio_SIDE.tif');
fprintf('High-resolution TIFF saved: RF_packets_ratio_SIDE.tif (600 DPI)\n');

% 2. Save as EPS (vector format, for typesetting)
print('-depsc', '-r600', 'RF_packets_ratio_SIDE.eps');
fprintf('EPS vector image saved: RF_packets_ratio_SIDE.eps\n');

% 3. Save as PDF (vector format, backup)
print('-dpdf', '-r600', 'RF_packets_ratio_SIDE.pdf');
fprintf('PDF vector image saved: RF_packets_ratio_SIDE.pdf\n');

% 4. Save as PNG (for preview)
print('-dpng', '-r300', 'RF_packets_ratio_SIDE.png');
fprintf('PNG preview image saved: RF_packets_ratio_SIDE.png (300 DPI)\n');

% Set figure properties to ensure font embedding
set(gcf, 'Renderer', 'painters'); % Use vector renderer

% Check file sizes
files = {'RF_packets_ratio_SIDE.tif', 'RF_packets_ratio_SIDE.eps', ...
         'RF_packets_ratio_SIDE.pdf', 'RF_packets_ratio_SIDE.png'};
for i = 1:length(files)
    if exist(files{i}, 'file')
        file_info = dir(files{i});
        file_size_mb = file_info.bytes / (1024 * 1024);
        fprintf('File %s size: %.2f MB\n', files{i}, file_size_mb);
    end
end

fprintf('\nImage saving completed! Recommend submitting EPS or PDF format for publication.\n');

%% =============== MPC1_oppo IF packet forwarding ratio ===============
figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points'); % Nature standard size

% 8
[fit_Max_packets_oppo_8, gof_Max_packets_oppo_8] = fit(LOGX, link_8_IF_Forward_packets_rate_MPC1_oppo, fit_type_gauss2);
h1 = plot(fit_Max_packets_oppo_8);
set(h1, 'Color', plot_styles.MPC0.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC0.line);
hold on;

% 10
[fit_Max_packets_oppo_10, gof_Max_packets_oppo_10] = fit(LOGX, link_10_IF_Forward_packets_rate_MPC1_oppo, fit_type_gauss2);
h2 = plot(fit_Max_packets_oppo_10);
set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);

% 12
[fit_Max_packets_oppo_12, gof_Max_packets_oppo_12] = fit(LOGX, link_12_IF_Forward_packets_rate_MPC1_oppo, fit_type_gauss2);
h3 = plot(fit_Max_packets_oppo_12);
set(h3, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);

% 14
[fit_Max_packets_oppo_14, gof_Max_packets_oppo_14] = fit(LOGX, link_14_IF_Forward_packets_rate_MPC1_oppo, fit_type_gauss1);
h4 = plot(fit_Max_packets_oppo_14);
set(h4, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);

% 16
[fit_Max_packets_oppo_16, gof_Max_packets_oppo_16] = fit(LOGX, link_16_IF_Forward_packets_rate_MPC1_oppo, fit_type_gauss1);
h5 = plot(fit_Max_packets_oppo_16);
set(h5, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);

% Nature style plot beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width ,'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation for x-axis
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('RF packets ratio (%)', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend (no border, optimized position)
legend({'8 x 8',  ...
        '10 x 10',  ...
        '12 x 12', ...
        '14 x 14', ...
        '16 x 16'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off; % Nature typically doesn't use grid

% Set figure to Nature standard size
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters'); % Use vector renderer

%% =============== Save images according to Nature requirements ===============
% Set image size (single column 8.6 cm wide)
figure_width_cm = 17.8; % Nature single column width
figure_height_cm = 12;  % Adjust height according to content
figure_width_inch = figure_width_cm / 2.54;
figure_height_inch = figure_height_cm / 2.54;

% Reset figure size
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

% Save in multiple formats to meet different needs

% 1. Save as high-resolution TIFF (for review)
print('-dtiff', '-r600', 'RF_packets_ratio_OPPO.tif');
fprintf('High-resolution TIFF saved: RF_packets_ratio_OPPO.tif (600 DPI)\n');

% 2. Save as EPS (vector format, for typesetting)
print('-depsc', '-r600', 'RF_packets_ratio_OPPO.eps');
fprintf('EPS vector image saved: RF_packets_ratio_OPPO.eps\n');

% 3. Save as PDF (vector format, backup)
print('-dpdf', '-r600', 'RF_packets_ratio_OPPO.pdf');
fprintf('PDF vector image saved: RF_packets_ratio_OPPO.pdf\n');

% 4. Save as PNG (for preview)
print('-dpng', '-r300', 'RF_packets_ratio_OPPO.png');
fprintf('PNG preview image saved: RF_packets_ratio_OPPO.png (300 DPI)\n');

% Set figure properties to ensure font embedding
set(gcf, 'Renderer', 'painters'); % Use vector renderer

% Check file sizes
files = {'RF_packets_ratio_OPPO.tif', 'RF_packets_ratio_OPPO.eps', ...
         'RF_packets_ratio_OPPO.pdf', 'RF_packets_ratio_OPPO.png'};
for i = 1:length(files)
    if exist(files{i}, 'file')
        file_info = dir(files{i});
        file_size_mb = file_info.bytes / (1024 * 1024);
        fprintf('File %s size: %.2f MB\n', files{i}, file_size_mb);
    end
end

fprintf('\nImage saving completed! Recommend submitting EPS or PDF format for publication.\n');