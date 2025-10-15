function [fitresult, gof] = createFit(LOGX, Dropped_rate_MPC1_side)
%CREATEFIT(LOGX,DROPPED_RATE_MPC1_SIDE)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : LOGX
%      Y Output: Dropped_rate_MPC1_side
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 14-Sep-2025 13:51:15 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( LOGX, Dropped_rate_MPC1_side );

% Set up fittype and options.
ft = fittype( 'gauss5' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0];
opts.StartPoint = [0.9919 -0.0604807473813815 0.160539092256616 0.968348157734735 -0.468521082957745 0.112065389358655 0.925172450573989 -0.744727494896694 0.10255469336105 0.835151703937759 -0.958607314841775 0.112892872563411 0.772621796344104 -0.292429823902064 0.197276336680344];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% plot( fitresult, xData, yData );
% % Label axes
% xlabel LOGX
% ylabel Dropped_rate_MPC1_side
% grid on


