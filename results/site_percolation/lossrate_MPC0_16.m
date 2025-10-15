function [fitresult, gof] = lossrate_MPC0_16(LOGX, Dropped_rate_MPC0)
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
%  ������� FIT, CFIT, SFIT.

%  �� MATLAB �� 01-Sep-2025 10:54:30 �Զ�����


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( LOGX, Dropped_rate_MPC0 );

% Set up fittype and options.
ft = fittype( 'gauss2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0];
opts.StartPoint = [0.990666666666667 0 0.83246225507681 0.885056453095607 -1.29242982390206 0.221116296739844];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );



