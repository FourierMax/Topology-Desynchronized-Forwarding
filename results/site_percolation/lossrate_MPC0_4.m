function [fitresult, gof] = lossrate_MPC0_4(LOGX, Dropped_rate_MPC0)
%CREATEFIT(LOGX,DROPPED_RATE_MPC0)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : LOGX
%      Y Output: Dropped_rate_MPC0
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 01-Sep-2025 14:10:22 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( LOGX, Dropped_rate_MPC0 );

% Set up fittype and options.
ft = fittype( 'gauss2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0];
opts.StartPoint = [0.992 -0.00436480540245009 0.972583664668896 0.815450323378554 -1.63827216398241 0.255167082115981];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'Dropped_rate_MPC0 vs. LOGX', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel LOGX
% ylabel Dropped_rate_MPC0
% grid on


