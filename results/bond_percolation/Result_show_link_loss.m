close all; clear all;

LOG_AXES = 1; % Enable logarithmic coordinates

%% Load MPC0 packet loss rate data
load link_16_Dropped_rate_MPC0;
link_16_Dropped_rate_MPC0 = Dropped_rate_MPC0;
load link_14_Dropped_rate_MPC0;
link_14_Dropped_rate_MPC0 = Dropped_rate_MPC0;
load link_12_Dropped_rate_MPC0;
link_12_Dropped_rate_MPC0 = Dropped_rate_MPC0;
load link_10_Dropped_rate_MPC0;
link_10_Dropped_rate_MPC0 = Dropped_rate_MPC0;
load link_8_Dropped_rate_MPC0;
link_8_Dropped_rate_MPC0 = Dropped_rate_MPC0;

%% Load MPC1 packet loss rate data
load link_16_Dropped_rate_MPC1;
link_16_Dropped_rate_MPC1 = Dropped_rate_MPC1;
load link_14_Dropped_rate_MPC1;
link_14_Dropped_rate_MPC1 = Dropped_rate_MPC1;
load link_12_Dropped_rate_MPC1;
link_12_Dropped_rate_MPC1 = Dropped_rate_MPC1;
load link_10_Dropped_rate_MPC1;
link_10_Dropped_rate_MPC1 = Dropped_rate_MPC1;
load link_8_Dropped_rate_MPC1;
link_8_Dropped_rate_MPC1 = Dropped_rate_MPC1;

%% Load MPC1_side packet loss rate data
load link_16_Dropped_rate_MPC1_side;
link_16_Dropped_rate_MPC1_side = Dropped_rate_MPC1_side;
load link_14_Dropped_rate_MPC1_side;
link_14_Dropped_rate_MPC1_side = Dropped_rate_MPC1_side;
load link_12_Dropped_rate_MPC1_side;
link_12_Dropped_rate_MPC1_side = Dropped_rate_MPC1_side;
load link_10_Dropped_rate_MPC1_side;
link_10_Dropped_rate_MPC1_side = Dropped_rate_MPC1_side;
load link_8_Dropped_rate_MPC1_side;
link_8_Dropped_rate_MPC1_side = Dropped_rate_MPC1_side;

%% Load MPC1_oppo packet loss rate data
load link_16_Dropped_rate_MPC1_oppo;
link_16_Dropped_rate_MPC1_oppo = Dropped_rate_MPC1_oppo;
load link_14_Dropped_rate_MPC1_oppo;
link_14_Dropped_rate_MPC1_oppo = Dropped_rate_MPC1_oppo;
load link_12_Dropped_rate_MPC1_oppo;
link_12_Dropped_rate_MPC1_oppo = Dropped_rate_MPC1_oppo;
load link_10_Dropped_rate_MPC1_oppo;
link_10_Dropped_rate_MPC1_oppo = Dropped_rate_MPC1_oppo;
load link_8_Dropped_rate_MPC1_oppo;
link_8_Dropped_rate_MPC1_oppo = Dropped_rate_MPC1_oppo;

%% Load LFA packet loss rate data
load link_16_Dropped_rate_LFA;
link_16_Dropped_rate_LFA = Dropped_rate_LFA;
load link_14_Dropped_rate_LFA;
link_14_Dropped_rate_LFA = Dropped_rate_LFA;
load link_12_Dropped_rate_LFA;
link_12_Dropped_rate_LFA = Dropped_rate_LFA;
load link_10_Dropped_rate_LFA;
link_10_Dropped_rate_LFA = Dropped_rate_LFA;
load link_8_Dropped_rate_LFA;
link_8_Dropped_rate_LFA = Dropped_rate_LFA;

%% Load MPC0 maximum hop count data
load link_16_Average_Max_Hops_MPC0;
link_16_Average_Max_Hops_MPC0 = Average_Max_Hops_MPC0;
load link_14_Average_Max_Hops_MPC0;
link_14_Average_Max_Hops_MPC0 = Average_Max_Hops_MPC0;
load link_12_Average_Max_Hops_MPC0;
link_12_Average_Max_Hops_MPC0 = Average_Max_Hops_MPC0;
load link_10_Average_Max_Hops_MPC0;
link_10_Average_Max_Hops_MPC0 = Average_Max_Hops_MPC0;
load link_8_Average_Max_Hops_MPC0;
link_8_Average_Max_Hops_MPC0 = Average_Max_Hops_MPC0;

%% Load MPC1 maximum hop count data
load link_16_Average_Max_Hops_MPC1;
link_16_Average_Max_Hops_MPC1 = Average_Max_Hops_MPC1;
load link_14_Average_Max_Hops_MPC1;
link_14_Average_Max_Hops_MPC1 = Average_Max_Hops_MPC1;
load link_12_Average_Max_Hops_MPC1;
link_12_Average_Max_Hops_MPC1 = Average_Max_Hops_MPC1;
load link_10_Average_Max_Hops_MPC1;
link_10_Average_Max_Hops_MPC1 = Average_Max_Hops_MPC1;
load link_8_Average_Max_Hops_MPC1;
link_8_Average_Max_Hops_MPC1 = Average_Max_Hops_MPC1;

%% Load MPC1_side maximum hop count data
load link_16_Average_Max_Hops_MPC1_side;
link_16_Average_Max_Hops_MPC1_side = Average_Max_Hops_MPC1_side;
load link_14_Average_Max_Hops_MPC1_side;
link_14_Average_Max_Hops_MPC1_side = Average_Max_Hops_MPC1_side;
load link_12_Average_Max_Hops_MPC1_side;
link_12_Average_Max_Hops_MPC1_side = Average_Max_Hops_MPC1_side;
load link_10_Average_Max_Hops_MPC1_side;
link_10_Average_Max_Hops_MPC1_side = Average_Max_Hops_MPC1_side;
load link_8_Average_Max_Hops_MPC1_side;
link_8_Average_Max_Hops_MPC1_side = Average_Max_Hops_MPC1_side;

%% Load MPC1_oppo maximum hop count data
load link_16_Average_Max_Hops_MPC1_oppo;
link_16_Average_Max_Hops_MPC1_oppo = Average_Max_Hops_MPC1_oppo;
load link_14_Average_Max_Hops_MPC1_oppo;
link_14_Average_Max_Hops_MPC1_oppo = Average_Max_Hops_MPC1_oppo;
load link_12_Average_Max_Hops_MPC1_oppo;
link_12_Average_Max_Hops_MPC1_oppo = Average_Max_Hops_MPC1_oppo;
load link_10_Average_Max_Hops_MPC1_oppo;
link_10_Average_Max_Hops_MPC1_oppo = Average_Max_Hops_MPC1_oppo;
load link_8_Average_Max_Hops_MPC1_oppo;
link_8_Average_Max_Hops_MPC1_oppo = Average_Max_Hops_MPC1_oppo;

%% Data preprocessing (ensure column vector format)
X1 = 0.0001:0.0001:0.01;  % 100 points from 0.0001 to 0.01
X2 = 0.001:0.001:0.1;     % 100 points from 0.001 to 0.1
X3 = 0.01:0.01:1;         % 100 points from 0.01 to 1
X4 = [X1,X2(11:100),X3(11:100)];
X = X4(:);  % Force conversion to column vector
LOGX = log10(X);

%% Set global plotting parameters
set(0, 'DefaultAxesFontName', 'Times New Roman', 'DefaultTextFontName', 'Times New Roman');
set(0, 'DefaultAxesFontSize', 20, 'DefaultTextFontSize', 20);
set(0, 'DefaultAxesFontWeight', 'bold', 'DefaultTextFontWeight', 'bold');

%% Define fitting options and types
fit_options = fitoptions('Method', 'NonlinearLeastSquares', 'Display', 'off');
fit_type_exp = fittype('a*exp(b*x)+ c*exp(d*x)', 'options', fit_options);
fit_type_exp1 = fittype('exp1');
fit_type_poly1 = fittype('poly1');
fit_type_poly2 = fittype('poly2'); % Quadratic polynomial
fit_type_power1 = fittype('power1');
fit_type_power2 = fittype('power2');
fit_type_linear = fittype({'(sin(x-pi))', '((x-10)^2)', '1'}, 'independent', 'x', 'dependent', 'y', 'coefficients', {'a', 'b', 'c'});

fit_type_gauss2 = fittype('gauss2');
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

line_width = 1.5;           % Nature style thinner lines
marker_line_width = 0.8;    % Marker edge line width
font_size = 11;             % Larger font size
legend_font_size = 9;       % Legend font size
axis_line_width = 0.8;      % Coordinate axis line width

%% =============== MPC0 loss rate ===============
figure('Position', [100 100 800 600], 'Color', 'w');
xlim([-4, max(LOGX)]);      

% 8
[fit_hops_MPC0_8, gof_hops_MPC0] = lossrate_MPC0_8(LOGX, link_8_Dropped_rate_MPC0);
h1 = plot(fit_hops_MPC0_8);
fit_hops_MPC0_8_value = feval(fit_hops_MPC0_8, LOGX);
set(h1, 'Color', plot_styles.MPC0.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC0.line);
hold on;

% 10
[fit_hops_MPC0_10, gof_hops_MPC1] = lossrate_MPC0_2(LOGX, link_10_Dropped_rate_MPC0);
h2 = plot(fit_hops_MPC0_10);
fit_hops_MPC0_10_value = feval(fit_hops_MPC0_10, LOGX);
set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);

% 12
[fit_hops_MPC0_12, gof_hops_LFA] = lossrate_MPC0_2(LOGX, link_12_Dropped_rate_MPC0);
h3 = plot(fit_hops_MPC0_12);
fit_hops_MPC0_12_value = feval(fit_hops_MPC0_12, LOGX);
set(h3, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);

% 14
 [fit_hops_MPC0_14, gof_hops_MPC1_oppo] = lossrate_MPC0_2(LOGX, link_14_Dropped_rate_MPC0);
h4 = plot(fit_hops_MPC0_14);
fit_hops_MPC0_14_value = feval(fit_hops_MPC0_14, LOGX);
set(h4, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);

% 16
 [fit_hops_MPC0_16, gof_hops_MPC1_oppo] = lossrate_MPC0_2(LOGX, link_16_Dropped_rate_MPC0);
h5 = plot(fit_hops_MPC0_16);
fit_hops_MPC0_16_value = feval(fit_hops_MPC0_16, LOGX);
set(h5, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);

title('Average Loss Performance_MPC0', 'FontSize', 20, 'FontWeight', 'bold')
xlabel('Link Failure Probability', 'FontSize', 20, 'FontWeight', 'bold')
ylabel('Average Loss Rate', 'FontSize', 20, 'FontWeight', 'bold')
legend({'8 x 8',  ...
        '10 x 10',  ...
        '12 x 12', ...
        '14 x 14', ...
        '16 x 16'}, ...
        'Location', 'northwest', 'FontSize', 14, 'NumColumns', 2);
grid on;
set(gca, 'LineWidth', 1.5, 'Box', 'on');


if LOG_AXES ==1
      set(gca, 'XTick', [-4,-3,-2,-1,0]); 
end

%% =============== MPC1 loss rate ===============
figure('Position', [100 100 800 600], 'Color', 'w');
xlim([-4, max(LOGX)]);       

% 8
[fit_hops_MPC1_8, gof_hops_MPC0] = lossrate_MPC1_8(LOGX, link_8_Dropped_rate_MPC1);
h1 = plot(fit_hops_MPC1_8);
fit_hops_MPC1_8_value = feval(fit_hops_MPC1_8, LOGX);
set(h1, 'Color', plot_styles.MPC0.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC0.line);
hold on;

% 10
[fit_hops_MPC1_10, gof_hops_MPC1] = lossrate_MPC1_2(LOGX, link_10_Dropped_rate_MPC1);
h2 = plot(fit_hops_MPC1_10);
fit_hops_MPC1_10_value = feval(fit_hops_MPC1_10, LOGX);
set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);

% 12
[fit_hops_MPC1_12, gof_hops_LFA] = lossrate_MPC1_2(LOGX, link_12_Dropped_rate_MPC1);
h3 = plot(fit_hops_MPC1_12);
fit_hops_MPC1_12_value = feval(fit_hops_MPC1_12, LOGX);
set(h3, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);

% 14
 [fit_hops_MPC1_14, gof_hops_MPC1_oppo] = lossrate_MPC1_2(LOGX, link_14_Dropped_rate_MPC1);
h4 = plot(fit_hops_MPC1_14);
fit_hops_MPC1_14_value = feval(fit_hops_MPC1_14, LOGX);
set(h4, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);

% 16
 [fit_hops_MPC1_16, gof_hops_MPC1_oppo] = lossrate_MPC1_2(LOGX, link_16_Dropped_rate_MPC1);
h5 = plot(fit_hops_MPC1_16);
fit_hops_MPC1_16_value = feval(fit_hops_MPC1_16, LOGX);
set(h5, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);

title('Average Loss Performance MPC1', 'FontSize', 20, 'FontWeight', 'bold')
xlabel('Link Failure Probability', 'FontSize', 20, 'FontWeight', 'bold')
ylabel('Average Loss Rate', 'FontSize', 20, 'FontWeight', 'bold')
legend({'8 x 8',  ...
        '10 x 10',  ...
        '12 x 12', ...
        '14 x 14', ...
        '16 x 16'}, ...
        'Location', 'northwest', 'FontSize', 14, 'NumColumns', 2);
grid on;
set(gca, 'LineWidth', 1.5, 'Box', 'on');

if LOG_AXES ==1
      set(gca, 'XTick', [-4,-3,-2,-1,0]); 
end

%% =============== MPC1_side loss rate ===============
figure('Position', [100 100 800 600], 'Color', 'w');
xlim([-4, max(LOGX)]);       

% 8
[fit_hops_MPC1_side_8, gof_hops_MPC0] = lossrate_MPC1side_8(LOGX, link_8_Dropped_rate_MPC1_side);
h1 = plot(fit_hops_MPC1_side_8);
fit_hops_MPC1_side_8_value = feval(fit_hops_MPC1_side_8, LOGX);
set(h1, 'Color', plot_styles.MPC0.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC0.line);
hold on;

% 10
[fit_hops_MPC1_side_10, gof_hops_MPC1] = lossrate_MPC1side_2(LOGX, link_10_Dropped_rate_MPC1_side);
h2 = plot(fit_hops_MPC1_side_10);
fit_hops_MPC1_side_10_value = feval(fit_hops_MPC1_side_10, LOGX);
set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);

% 12
[fit_hops_MPC1_side_12, gof_hops_LFA] = lossrate_MPC1side_2(LOGX, link_12_Dropped_rate_MPC1_side);
h3 = plot(fit_hops_MPC1_side_12);
fit_hops_MPC1_side_12_value = feval(fit_hops_MPC1_side_12, LOGX);
set(h3, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);

% 14
 [fit_hops_MPC1_side_14, gof_hops_MPC1_oppo] = lossrate_MPC1side_4(LOGX, link_14_Dropped_rate_MPC1_side);
h4 = plot(fit_hops_MPC1_side_14);
fit_hops_MPC1_side_14_value = feval(fit_hops_MPC1_side_14, LOGX);
set(h4, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);

% 16
 [fit_hops_MPC1_side_16, gof_hops_MPC1_oppo] = lossrate_MPC1side_4(LOGX, link_16_Dropped_rate_MPC1_side);
h5 = plot(fit_hops_MPC1_side_16);
fit_hops_MPC1_side_16_value = feval(fit_hops_MPC1_side_16, LOGX);
set(h5, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);

% Õº–Œ√¿ªØ
title('Average Loss Performance MPC1_side', 'FontSize', 20, 'FontWeight', 'bold')
xlabel('Link Failure Probability', 'FontSize', 20, 'FontWeight', 'bold')
ylabel('Average Loss Rate', 'FontSize', 20, 'FontWeight', 'bold')
legend({'8 x 8',  ...
        '10 x 10',  ...
        '12 x 12', ...
        '14 x 14', ...
        '16 x 16'}, ...
        'Location', 'northwest', 'FontSize', 14, 'NumColumns', 2);
grid on;
set(gca, 'LineWidth', 1.5, 'Box', 'on');

if LOG_AXES ==1
      set(gca, 'XTick', [-4,-3,-2,-1,0]); 
end

%% =============== MPC1_oppo loss rate ===============
figure('Position', [100 100 800 600], 'Color', 'w');
xlim([-4, max(LOGX)]);   

% 8
[fit_hops_MPC1_oppo_8, gof_hops_MPC0] = lossrate_MPC1oppo_8(LOGX, link_8_Dropped_rate_MPC1_oppo);
h1 = plot(fit_hops_MPC1_oppo_8);
fit_hops_MPC1_oppo_8_value = feval(fit_hops_MPC1_oppo_8, LOGX);
set(h1, 'Color', plot_styles.MPC0.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC0.line);
hold on;

% 10
[fit_hops_MPC1_oppo_10, gof_hops_MPC1] = lossrate_MPC1oppo_2(LOGX, link_10_Dropped_rate_MPC1_oppo);
h2 = plot(fit_hops_MPC1_oppo_10);
fit_hops_MPC1_oppo_10_value = feval(fit_hops_MPC1_oppo_10, LOGX);
set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);

% 12
[fit_hops_MPC1_oppo_12, gof_hops_LFA] =  lossrate_MPC1oppo_2(LOGX, link_12_Dropped_rate_MPC1_oppo);
h3 = plot(fit_hops_MPC1_oppo_12);
fit_hops_MPC1_oppo_12_value = feval(fit_hops_MPC1_oppo_12, LOGX);
set(h3, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);

% 14
 [fit_hops_MPC1_oppo_14, gof_hops_MPC1_oppo] =  lossrate_MPC1oppo_2(LOGX, link_14_Dropped_rate_MPC1_oppo);
h4 = plot(fit_hops_MPC1_oppo_14);
fit_hops_MPC1_oppo_14_value = feval(fit_hops_MPC1_oppo_14, LOGX);
set(h4, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);

% 16
 [fit_hops_MPC1_oppo_16, gof_hops_MPC1_oppo] =  lossrate_MPC1oppo_2(LOGX, link_16_Dropped_rate_MPC1_oppo);
h5 = plot(fit_hops_MPC1_oppo_16);
fit_hops_MPC1_oppo_16_value = feval(fit_hops_MPC1_oppo_16, LOGX);
set(h5, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);

title('Average Loss Performance MPC1_oppo', 'FontSize', 20, 'FontWeight', 'bold')
xlabel('Link Failure Probability', 'FontSize', 20, 'FontWeight', 'bold')
ylabel('Average Loss Rate', 'FontSize', 20, 'FontWeight', 'bold')
legend({'8 x 8',  ...
        '10 x 10',  ...
        '12 x 12', ...
        '14 x 14', ...
        '16 x 16'}, ...
        'Location', 'northwest', 'FontSize', 14, 'NumColumns', 2);
grid on;
set(gca, 'LineWidth', 1.5, 'Box', 'on');

if LOG_AXES ==1
      set(gca, 'XTick', [-4,-3,-2,-1,0]); 
end

%% =============== LFA loss rate ===============
figure('Position', [100 100 800 600], 'Color', 'w');
xlim([-4, max(LOGX)]);       

% 8
[fit_hops_LFA_8, gof_hops_MPC0] = lossrate_MPC1oppo_8(LOGX, link_8_Dropped_rate_LFA);
h1 = plot(fit_hops_LFA_8);
fit_hops_LFA_8_value = feval(fit_hops_LFA_8, LOGX);
set(h1, 'Color', plot_styles.MPC0.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC0.line);
hold on;

% 10
[fit_hops_LFA_10, gof_hops_MPC1] = lossrate_MPC1oppo_2(LOGX, link_10_Dropped_rate_LFA);
h2 = plot(fit_hops_LFA_10);
fit_hops_LFA_10_value = feval(fit_hops_LFA_10, LOGX);
set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);

% 12
[fit_hops_LFA_12, gof_hops_LFA] =  lossrate_MPC1oppo_2(LOGX, link_12_Dropped_rate_LFA);
h3 = plot(fit_hops_LFA_12);
fit_hops_LFA_12_value = feval(fit_hops_LFA_12, LOGX);
set(h3, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);

% 14
 [fit_hops_LFA_14, gof_hops_MPC1_oppo] =  lossrate_MPC1oppo_2(LOGX, link_14_Dropped_rate_LFA);
h4 = plot(fit_hops_LFA_14);
fit_hops_LFA_14_value = feval(fit_hops_LFA_14, LOGX);
set(h4, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);

% 16
 [fit_hops_LFA_16, gof_hops_MPC1_oppo] =  lossrate_MPC1oppo_2(LOGX, link_16_Dropped_rate_LFA);
h5 = plot(fit_hops_LFA_16);
fit_hops_LFA_16_value = feval(fit_hops_LFA_16, LOGX);
set(h5, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);


title('Average Loss Performance LFA', 'FontSize', 20, 'FontWeight', 'bold')
xlabel('Link Failure Probability', 'FontSize', 20, 'FontWeight', 'bold')
ylabel('Average Loss Rate', 'FontSize', 20, 'FontWeight', 'bold')
legend({'8 x 8',  ...
        '10 x 10',  ...
        '12 x 12', ...
        '14 x 14', ...
        '16 x 16'}, ...
        'Location', 'northwest', 'FontSize', 14, 'NumColumns', 2);
grid on;
set(gca, 'LineWidth', 1.5, 'Box', 'on');

if LOG_AXES ==1
      set(gca, 'XTick', [-4,-3,-2,-1,0]); 
end

%% =============== MPC1_oppo Average Packet Loss Rate Difference Performance Plot ===============

figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points'); % Nature standard dimensions

h1 = plot(LOGX, (fit_hops_MPC0_8_value - fit_hops_MPC1_oppo_8_value));
hold on;
h2 = plot(LOGX, (fit_hops_MPC0_10_value - fit_hops_MPC1_oppo_10_value));
h3 = plot(LOGX, (fit_hops_MPC0_12_value - fit_hops_MPC1_oppo_12_value));
h4 = plot(LOGX, (fit_hops_MPC0_14_value - fit_hops_MPC1_oppo_14_value));
h5 = plot(LOGX, (fit_hops_MPC0_16_value - fit_hops_MPC1_oppo_16_value));

set(h1, 'Color', plot_styles.MPC0.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC0.line);
set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);
set(h3, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);
set(h4, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);
set(h5, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);

% Nature style plot beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width, 'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation for x-axis
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Improvement of packet loss rate (%)', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend (no border, optimized position)
legend({'8 x 8',  ...
        '10 x 10',  ...
        '12 x 12', ...
        '14 x 14', ...
        '16 x 16'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off; % Nature typically doesn't use grid

% Set figure to Nature standard dimensions
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

% Reset figure dimensions
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

% Save in multiple formats to meet different requirements

% 1. Save as high resolution TIFF (for review)
print('-dtiff', '-r600', 'packet_loss_rate_OPPO_improvement.tif');
fprintf('High resolution TIFF saved: packet_loss_rate_OPPO_improvement.tif (600 DPI)\n');

% 2. Save as EPS (vector format, for typesetting)
print('-depsc', '-r600', 'packet_loss_rate_OPPO_improvement.eps');
fprintf('EPS vector image saved: packet_loss_rate_OPPO_improvement.eps\n');

% 3. Save as PDF (vector format, backup)
print('-dpdf', '-r600', 'packet_loss_rate_OPPO_improvement.pdf');
fprintf('PDF vector image saved: packet_loss_rate_OPPO_improvement.pdf\n');

% 4. Save as PNG (for preview)
print('-dpng', '-r300', 'packet_loss_rate_OPPO_improvement.png');
fprintf('PNG preview image saved: packet_loss_rate_OPPO_improvement.png (300 DPI)\n');

% Set figure properties to ensure font embedding
set(gcf, 'Renderer', 'painters'); % Use vector renderer

% Check file sizes
files = {'packet_loss_rate_link_OPPO_improvement.tif', 'packet_loss_rate_link_OPPO_improvement.eps', ...
         'packet_loss_rate_link_OPPO_improvement.pdf', 'packet_loss_rate_link_OPPO_improvement.png'};
for i = 1:length(files)
    if exist(files{i}, 'file')
        file_info = dir(files{i});
        file_size_mb = file_info.bytes / (1024 * 1024);
        fprintf('File %s size: %.2f MB\n', files{i}, file_size_mb);
    end
end

fprintf('\nImage saving completed! Recommended to submit EPS or PDF format for publication.\n');

%% =============== MPC1_side Average Packet Loss Rate Difference Performance Plot ===============

figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points'); % Nature standard dimensions

h1 = plot(LOGX, (fit_hops_MPC0_8_value - fit_hops_MPC1_side_8_value));
hold on;
h2 = plot(LOGX, (fit_hops_MPC0_10_value - fit_hops_MPC1_side_10_value));
h3 = plot(LOGX, (fit_hops_MPC0_12_value - fit_hops_MPC1_side_12_value));
h4 = plot(LOGX, (fit_hops_MPC0_14_value - fit_hops_MPC1_side_14_value));
h5 = plot(LOGX, (fit_hops_MPC0_16_value - fit_hops_MPC1_side_16_value));

set(h1, 'Color', plot_styles.MPC0.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC0.line);
set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);
set(h3, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);
set(h4, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);
set(h5, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);

% Nature style plot beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width, 'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation for x-axis
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Improvement of packet loss rate (%)', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend (no border, optimized position)
legend({'8 x 8',  ...
        '10 x 10',  ...
        '12 x 12', ...
        '14 x 14', ...
        '16 x 16'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off; % Nature typically doesn't use grid

% Set figure to Nature standard dimensions
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters'); % Use vector renderer

%% =============== Save images according to Nature requirements ===============
% Set image dimensions (single column 8.6 cm wide)
figure_width_cm = 17.8; % Nature single column width
figure_height_cm = 12;  % Adjust height based on content
figure_width_inch = figure_width_cm / 2.54;
figure_height_inch = figure_height_cm / 2.54;

% Reset figure dimensions
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

% Save in multiple formats to meet different requirements

% 1. Save as high resolution TIFF (for review)
print('-dtiff', '-r600', 'packet_loss_rate_SIDE_improvement.tif');
fprintf('High resolution TIFF saved: packet_loss_rate_SIDE_improvement.tif (600 DPI)\n');

% 2. Save as EPS (vector format, for typesetting)
print('-depsc', '-r600', 'packet_loss_rate_SIDE_improvement.eps');
fprintf('EPS vector image saved: packet_loss_rate_SIDE_improvement.eps\n');

% 3. Save as PDF (vector format, backup)
print('-dpdf', '-r600', 'packet_loss_rate_SIDE_improvement.pdf');
fprintf('PDF vector image saved: packet_loss_rate_SIDE_improvement.pdf\n');

% 4. Save as PNG (for preview)
print('-dpng', '-r300', 'packet_loss_rate_SIDE_improvement.png');
fprintf('PNG preview image saved: packet_loss_rate_SIDE_improvement.png (300 DPI)\n');

% Set figure properties to ensure font embedding
set(gcf, 'Renderer', 'painters'); % Use vector renderer

% Check file sizes
files = {'packet_loss_rate_link_SIDE_improvement.tif', 'packet_loss_rate_link_SIDE_improvement.eps', ...
         'packet_loss_rate_link_SIDE_improvement.pdf', 'packet_loss_rate_link_SIDE_improvement.png'};
for i = 1:length(files)
    if exist(files{i}, 'file')
        file_info = dir(files{i});
        file_size_mb = file_info.bytes / (1024 * 1024);
        fprintf('File %s size: %.2f MB\n', files{i}, file_size_mb);
    end
end

fprintf('\nImage saving completed! Recommended to submit EPS or PDF format for publication.\n');

%% =============== LFA Average Packet Loss Rate Difference Performance Plot ===============

figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points'); % Nature standard dimensions

h1 = plot(LOGX, (fit_hops_MPC0_8_value - fit_hops_LFA_8_value));
hold on;
h2 = plot(LOGX, (fit_hops_MPC0_10_value - fit_hops_LFA_10_value));
h3 = plot(LOGX, (fit_hops_MPC0_12_value - fit_hops_LFA_12_value));
h4 = plot(LOGX, (fit_hops_MPC0_14_value - fit_hops_LFA_14_value));
h5 = plot(LOGX, (fit_hops_MPC0_16_value - fit_hops_LFA_16_value));

set(h1, 'Color', plot_styles.MPC0.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC0.line);
set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);
set(h3, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);
set(h4, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);
set(h5, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);

% Nature style plot beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width, 'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation for x-axis
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Improvement of packet loss rate (%)', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend (no border, optimized position)
legend({'8 x 8',  ...
        '10 x 10',  ...
        '12 x 12', ...
        '14 x 14', ...
        '16 x 16'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off; % Nature typically doesn't use grid

% Set figure to Nature standard dimensions
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters'); % Use vector renderer

%% =============== Save images according to Nature requirements ===============
% Set image dimensions (single column 8.6 cm wide)
figure_width_cm = 17.8; % Nature single column width
figure_height_cm = 12;  % Adjust height based on content
figure_width_inch = figure_width_cm / 2.54;
figure_height_inch = figure_height_cm / 2.54;

% Reset figure dimensions
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

% Save in multiple formats to meet different requirements

% 1. Save as high resolution TIFF (for review)
print('-dtiff', '-r600', 'packet_loss_rate_LFA_improvement.tif');
fprintf('High resolution TIFF saved: packet_loss_rate_LFA_improvement.tif (600 DPI)\n');

% 2. Save as EPS (vector format, for typesetting)
print('-depsc', '-r600', 'packet_loss_rate_LFA_improvement.eps');
fprintf('EPS vector image saved: packet_loss_rate_LFA_improvement.eps\n');

% 3. Save as PDF (vector format, backup)
print('-dpdf', '-r600', 'packet_loss_rate_LFA_improvement.pdf');
fprintf('PDF vector image saved: packet_loss_rate_LFA_improvement.pdf\n');

% 4. Save as PNG (for preview)
print('-dpng', '-r300', 'packet_loss_rate_LFA_improvement.png');
fprintf('PNG preview image saved: packet_loss_rate_LFA_improvement.png (300 DPI)\n');

% Set figure properties to ensure font embedding
set(gcf, 'Renderer', 'painters'); % Use vector renderer

% Check file sizes
files = {'packet_loss_rate_link_LFA_improvement.tif', 'packet_loss_rate_link_LFA_improvement.eps', ...
         'packet_loss_rate_link_LFA_improvement.pdf', 'packet_loss_rate_link_LFA_improvement.png'};
for i = 1:length(files)
    if exist(files{i}, 'file')
        file_info = dir(files{i});
        file_size_mb = file_info.bytes / (1024 * 1024);
        fprintf('File %s size: %.2f MB\n', files{i}, file_size_mb);
    end
end

fprintf('\nImage saving completed! Recommended to submit EPS or PDF format for publication.\n');

%% =============== 16 Performance Plot ===============
figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points'); % Nature standard dimensions
hold on;

h1 = plot(LOGX, (fit_hops_MPC0_16_value - fit_hops_LFA_16_value));
hold on;
% h2 = plot(LOGX, (fit_hops_MPC0_16_value - fit_hops_MPC1_16_value));
h3 = plot(LOGX, (fit_hops_MPC0_16_value - fit_hops_MPC1_oppo_16_value));
h4 = plot(LOGX, (fit_hops_MPC0_16_value - fit_hops_MPC1_side_16_value));

set(h1, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);
% set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);
set(h3, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);
set(h4, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);

% Nature style plot beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width, 'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation for x-axis
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Improvement of packet loss rate (%)', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend (no border, optimized position)
legend({'LFA (Fit)',  ...
        'RF-CF (Fit)',  ...
        'RF-LF (Fit)'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off; % Nature typically doesn't use grid

% Set figure to Nature standard dimensions
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters'); % Use vector renderer

%% =============== Save images according to Nature requirements ===============
% Set image dimensions (single column 8.6 cm wide)
figure_width_cm = 17.8; % Nature single column width
figure_height_cm = 12;  % Adjust height based on content
figure_width_inch = figure_width_cm / 2.54;
figure_height_inch = figure_height_cm / 2.54;

% Reset figure dimensions
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

% Save in multiple formats to meet different requirements

% 1. Save as high resolution TIFF (for review)
print('-dtiff', '-r600', 'packet_loss_rate_16_improvement.tif');
fprintf('High resolution TIFF saved: packet_loss_rate_16_improvement.tif (600 DPI)\n');

% 2. Save as EPS (vector format, for typesetting)
print('-depsc', '-r600', 'packet_loss_rate_16_improvement.eps');
fprintf('EPS vector image saved: packet_loss_rate_16_improvement.eps\n');

% 3. Save as PDF (vector format, backup)
print('-dpdf', '-r600', 'packet_loss_rate_16_improvement.pdf');
fprintf('PDF vector image saved: packet_loss_rate_16_improvement.pdf\n');

% 4. Save as PNG (for preview)
print('-dpng', '-r300', 'packet_loss_rate_16_improvement.png');
fprintf('PNG preview image saved: packet_loss_rate_16_improvement.png (300 DPI)\n');

% Set figure properties to ensure font embedding
set(gcf, 'Renderer', 'painters'); % Use vector renderer

% Check file sizes
files = {'packet_loss_rate_link_16_improvement.tif', 'packet_loss_rate_link_16_improvement.eps', ...
         'packet_loss_rate_link_16_improvement.pdf', 'packet_loss_rate_link_16_improvement.png'};
for i = 1:length(files)
    if exist(files{i}, 'file')
        file_info = dir(files{i});
        file_size_mb = file_info.bytes / (1024 * 1024);
        fprintf('File %s size: %.2f MB\n', files{i}, file_size_mb);
    end
end

fprintf('\nImage saving completed! Recommended to submit EPS or PDF format for publication.\n');

%% =============== 14 Performance Plot ===============

figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points'); % Nature standard dimensions
hold on;

h1 = plot(LOGX, (fit_hops_MPC0_14_value - fit_hops_LFA_14_value));
% h2 = plot(LOGX, (fit_hops_MPC0_14_value - fit_hops_MPC1_14_value));
h3 = plot(LOGX, (fit_hops_MPC0_14_value - fit_hops_MPC1_oppo_14_value));
h4 = plot(LOGX, (fit_hops_MPC0_14_value - fit_hops_MPC1_side_14_value));

set(h1, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);
% set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);
set(h3, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);
set(h4, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);

% Nature style plot beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width, 'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation for x-axis
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Improvement of packet loss rate (%)', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend (no border, optimized position)
legend({'LFA (Fit)',  ...
        'RF-CF (Fit)',  ...
        'RF-LF (Fit)'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off; % Nature typically doesn't use grid

% Set figure to Nature standard dimensions
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters'); % Use vector renderer

%% =============== Save images according to Nature requirements ===============
% Set image dimensions (single column 8.6 cm wide)
figure_width_cm = 17.8; % Nature single column width
figure_height_cm = 12;  % Adjust height based on content
figure_width_inch = figure_width_cm / 2.54;
figure_height_inch = figure_height_cm / 2.54;

% Reset figure dimensions
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

% Save in multiple formats to meet different requirements

% 1. Save as high resolution TIFF (for review)
print('-dtiff', '-r600', 'packet_loss_rate_14_improvement.tif');
fprintf('High resolution TIFF saved: packet_loss_rate_14_improvement.tif (600 DPI)\n');

% 2. Save as EPS (vector format, for typesetting)
print('-depsc', '-r600', 'packet_loss_rate_14_improvement.eps');
fprintf('EPS vector image saved: packet_loss_rate_14_improvement.eps\n');

% 3. Save as PDF (vector format, backup)
print('-dpdf', '-r600', 'packet_loss_rate_14_improvement.pdf');
fprintf('PDF vector image saved: packet_loss_rate_14_improvement.pdf\n');

% 4. Save as PNG (for preview)
print('-dpng', '-r300', 'packet_loss_rate_14_improvement.png');
fprintf('PNG preview image saved: packet_loss_rate_14_improvement.png (300 DPI)\n');

% Set figure properties to ensure font embedding
set(gcf, 'Renderer', 'painters'); % Use vector renderer

% Check file sizes
files = {'packet_loss_rate_link_14_improvement.tif', 'packet_loss_rate_link_14_improvement.eps', ...
         'packet_loss_rate_link_14_improvement.pdf', 'packet_loss_rate_link_14_improvement.png'};
for i = 1:length(files)
    if exist(files{i}, 'file')
        file_info = dir(files{i});
        file_size_mb = file_info.bytes / (1024 * 1024);
        fprintf('File %s size: %.2f MB\n', files{i}, file_size_mb);
    end
end

fprintf('\nImage saving completed! Recommended to submit EPS or PDF format for publication.\n');

%% =============== 12 Performance Plot ===============

figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points'); % Nature standard dimensions

h1 = plot(LOGX, (fit_hops_MPC0_12_value - fit_hops_LFA_12_value));
hold on;
% h2 = plot(LOGX, (fit_hops_MPC0_12_value - fit_hops_MPC1_12_value));
h3 = plot(LOGX, (fit_hops_MPC0_12_value - fit_hops_MPC1_oppo_12_value));
h4 = plot(LOGX, (fit_hops_MPC0_12_value - fit_hops_MPC1_side_12_value));

set(h1, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);
% set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);
set(h3, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);
set(h4, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);

% Nature style plot beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width, 'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation for x-axis
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Improvement of packet loss rate (%)', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend (no border, optimized position)
legend({'LFA (Fit)',  ...
        'RF-CF (Fit)',  ...
        'RF-LF (Fit)'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off; % Nature typically doesn't use grid

% Set figure to Nature standard dimensions
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters'); % Use vector renderer

%% =============== Save images according to Nature requirements ===============
% Set image dimensions (single column 8.6 cm wide)
figure_width_cm = 17.8; % Nature single column width
figure_height_cm = 12;  % Adjust height based on content
figure_width_inch = figure_width_cm / 2.54;
figure_height_inch = figure_height_cm / 2.54;

% Reset figure dimensions
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

% Save in multiple formats to meet different requirements

% 1. Save as high resolution TIFF (for review)
print('-dtiff', '-r600', 'packet_loss_rate_12_improvement.tif');
fprintf('High resolution TIFF saved: packet_loss_rate_12_improvement.tif (600 DPI)\n');

% 2. Save as EPS (vector format, for typesetting)
print('-depsc', '-r600', 'packet_loss_rate_12_improvement.eps');
fprintf('EPS vector image saved: packet_loss_rate_12_improvement.eps\n');

% 3. Save as PDF (vector format, backup)
print('-dpdf', '-r600', 'packet_loss_rate_12_improvement.pdf');
fprintf('PDF vector image saved: packet_loss_rate_12_improvement.pdf\n');

% 4. Save as PNG (for preview)
print('-dpng', '-r300', 'packet_loss_rate_12_improvement.png');
fprintf('PNG preview image saved: packet_loss_rate_12_improvement.png (300 DPI)\n');

% Set figure properties to ensure font embedding
set(gcf, 'Renderer', 'painters'); % Use vector renderer

% Check file sizes
files = {'packet_loss_rate_link_12_improvement.tif', 'packet_loss_rate_link_12_improvement.eps', ...
         'packet_loss_rate_link_12_improvement.pdf', 'packet_loss_rate_link_12_improvement.png'};
for i = 1:length(files)
    if exist(files{i}, 'file')
        file_info = dir(files{i});
        file_size_mb = file_info.bytes / (1024 * 1024);
        fprintf('File %s size: %.2f MB\n', files{i}, file_size_mb);
    end
end

fprintf('\nImage saving completed! Recommended to submit EPS or PDF format for publication.\n');

%% =============== 10 Performance Plot ===============

figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points'); % Nature standard dimensions

h1 = plot(LOGX, (fit_hops_MPC0_10_value - fit_hops_LFA_10_value));
hold on;
% h2 = plot(LOGX, (fit_hops_MPC0_10_value - fit_hops_MPC1_10_value));
h3 = plot(LOGX, (fit_hops_MPC0_10_value - fit_hops_MPC1_oppo_10_value));
h4 = plot(LOGX, (fit_hops_MPC0_10_value - fit_hops_MPC1_side_10_value));

set(h1, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);
% set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);
set(h3, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);
set(h4, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);

% Nature style plot beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width, 'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation for x-axis
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Improvement of packet loss rate (%)', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend (no border, optimized position)
legend({'LFA (Fit)',  ...
        'RF-CF (Fit)',  ...
        'RF-LF (Fit)'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off; % Nature typically doesn't use grid

% Set figure to Nature standard dimensions
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters'); % Use vector renderer

%% =============== Save images according to Nature requirements ===============
% Set image dimensions (single column 8.6 cm wide)
figure_width_cm = 17.8; % Nature single column width
figure_height_cm = 12;  % Adjust height based on content
figure_width_inch = figure_width_cm / 2.54;
figure_height_inch = figure_height_cm / 2.54;

% Reset figure dimensions
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

% Save in multiple formats to meet different requirements

% 1. Save as high resolution TIFF (for review)
print('-dtiff', '-r600', 'packet_loss_rate_10_improvement.tif');
fprintf('High resolution TIFF saved: packet_loss_rate_10_improvement.tif (600 DPI)\n');

% 2. Save as EPS (vector format, for typesetting)
print('-depsc', '-r600', 'packet_loss_rate_10_improvement.eps');
fprintf('EPS vector image saved: packet_loss_rate_10_improvement.eps\n');

% 3. Save as PDF (vector format, backup)
print('-dpdf', '-r600', 'packet_loss_rate_10_improvement.pdf');
fprintf('PDF vector image saved: packet_loss_rate_10_improvement.pdf\n');

% 4. Save as PNG (for preview)
print('-dpng', '-r300', 'packet_loss_rate_10_improvement.png');
fprintf('PNG preview image saved: packet_loss_rate_10_improvement.png (300 DPI)\n');

% Set figure properties to ensure font embedding
set(gcf, 'Renderer', 'painters'); % Use vector renderer

% Check file sizes
files = {'packet_loss_rate_link_10_improvement.tif', 'packet_loss_rate_link_10_improvement.eps', ...
         'packet_loss_rate_link_10_improvement.pdf', 'packet_loss_rate_link_10_improvement.png'};
for i = 1:length(files)
    if exist(files{i}, 'file')
        file_info = dir(files{i});
        file_size_mb = file_info.bytes / (1024 * 1024);
        fprintf('File %s size: %.2f MB\n', files{i}, file_size_mb);
    end
end

fprintf('\nImage saving completed! Recommended to submit EPS or PDF format for publication.\n');

%% =============== 8 Performance Plot ===============

figure('Position', [100 100 560 420], 'Color', 'w', 'Units', 'points'); % Nature standard dimensions

h1 = plot(LOGX, (fit_hops_MPC0_8_value - fit_hops_LFA_8_value));
hold on;
% h2 = plot(LOGX, (fit_hops_MPC0_8_value - fit_hops_MPC1_8_value));
h3 = plot(LOGX, (fit_hops_MPC0_8_value - fit_hops_MPC1_oppo_8_value));
h4 = plot(LOGX, (fit_hops_MPC0_8_value - fit_hops_MPC1_side_8_value));

set(h1, 'Color', plot_styles.LFA.color, 'LineWidth', line_width, 'LineStyle', plot_styles.LFA.line);
% set(h2, 'Color', plot_styles.MPC1.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1.line);
set(h3, 'Color', plot_styles.MPC1_oppo.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_oppo.line);
set(h4, 'Color', plot_styles.MPC1_side.color, 'LineWidth', line_width, 'LineStyle', plot_styles.MPC1_side.line);

% Nature style plot beautification
xlim([-4, max(LOGX)]);
set(gca, 'LineWidth', axis_line_width, 'FontSize', 11, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0.015 0.015]);

% Set scientific notation for x-axis
set(gca, 'XTick', [-4, -3, -2, -1, 0]);
set(gca, 'XTickLabel', {'10^{-4}', '10^{-3}', '10^{-2}', '10^{-1}', '10^{0}'});

% Nature style labels and titles
xlabel('Link failure probability', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Improvement of packet loss rate (%)', 'FontSize', 11, 'FontName', 'Arial');

% Nature style legend (no border, optimized position)
legend({'LFA (Fit)',  ...
        'RF-CF (Fit)',  ...
        'RF-LF (Fit)'}, ...
    'Location', 'northwest', 'FontSize', 9, 'Box', 'off', 'NumColumns', 2);

grid off; % Nature typically doesn't use grid

% Set figure to Nature standard dimensions
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Renderer', 'painters'); % Use vector renderer

%% =============== Save images according to Nature requirements ===============
% Set image dimensions (single column 8.6 cm wide)
figure_width_cm = 17.8; % Nature single column width
figure_height_cm = 12;  % Adjust height based on content
figure_width_inch = figure_width_cm / 2.54;
figure_height_inch = figure_height_cm / 2.54;

% Reset figure dimensions
set(gcf, 'Units', 'inches', 'Position', [1, 1, figure_width_inch, figure_height_inch]);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, figure_width_inch, figure_height_inch]);

% Save in multiple formats to meet different requirements

% 1. Save as high resolution TIFF (for review)
print('-dtiff', '-r600', 'packet_loss_rate_8_improvement.tif');
fprintf('High resolution TIFF saved: packet_loss_rate_8_improvement.tif (600 DPI)\n');

% 2. Save as EPS (vector format, for typesetting)
print('-depsc', '-r600', 'packet_loss_rate_8_improvement.eps');
fprintf('EPS vector image saved: packet_loss_rate_8_improvement.eps\n');

% 3. Save as PDF (vector format, backup)
print('-dpdf', '-r600', 'packet_loss_rate_8_improvement.pdf');
fprintf('PDF vector image saved: packet_loss_rate_8_improvement.pdf\n');

% 4. Save as PNG (for preview)
print('-dpng', '-r300', 'packet_loss_rate_8_improvement.png');
fprintf('PNG preview image saved: packet_loss_rate_8_improvement.png (300 DPI)\n');

% Set figure properties to ensure font embedding
set(gcf, 'Renderer', 'painters'); % Use vector renderer

% Check file sizes
files = {'packet_loss_rate_link_8_improvement.tif', 'packet_loss_rate_link_8_improvement.eps', ...
         'packet_loss_rate_link_8_improvement.pdf', 'packet_loss_rate_link_8_improvement.png'};
for i = 1:length(files)
    if exist(files{i}, 'file')
        file_info = dir(files{i});
        file_size_mb = file_info.bytes / (1024 * 1024);
        fprintf('File %s size: %.2f MB\n', files{i}, file_size_mb);
    end
end

fprintf('\nImage saving completed! Recommended to submit EPS or PDF format for publication.\n');