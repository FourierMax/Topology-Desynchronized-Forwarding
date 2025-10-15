function [fitresult, gof] = lossrate_MPC1oppo_2(LOGX, Dropped_rate_MPC1_oppo)
%CREATEFIT(LOGX,DROPPED_RATE_MPC1_OPPO)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : LOGX
%      Y Output: Dropped_rate_MPC1_oppo
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 01-Sep-2025 14:46:16 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( LOGX, Dropped_rate_MPC1_oppo );

% Set up fittype and options.
ft = fittype( 'gauss2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0];
opts.Robust = 'LAR';
opts.StartPoint = [0.992 0 1.00372035699134 0.827014581836138 -1.45593195564972 0.218824183359632];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'Dropped_rate_MPC1_oppo vs. LOGX', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel LOGX
% ylabel Dropped_rate_MPC1_oppo
% grid on


