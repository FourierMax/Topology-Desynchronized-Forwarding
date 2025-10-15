function [fitresult, gof] = lossrate_MPC1_16(LOGX, Dropped_rate_MPC1)
%CREATEFIT(LOGX,DROPPED_RATE_MPC1)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : LOGX
%      Y Output: Dropped_rate_MPC1
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 01-Sep-2025 14:29:54 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( LOGX, Dropped_rate_MPC1 );

% Set up fittype and options.
ft = fittype( 'gauss2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0];

opts.StartPoint = [0.990666666666667 0 0.600745637233188 0.891478007068039 -1.05060999335509 0.222818617815156];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'Dropped_rate_MPC1 vs. LOGX', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel LOGX
% ylabel Dropped_rate_MPC1
% grid on


