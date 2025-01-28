% Script for analysis of data. It assumes the data set is stationary and
% does not have a functional dependence on other variables. For example, a
% set of readings from a voltmeter or mass readings from a scale would
% qualify.
% The inputs consist of the data set and the desired confidence level.
% The script calculates the following:
%    1. The mean or average of the data
%    2. The sample standard deviation of the data
%    3. The count of the data
%    4. The estimated standard error of the data
%    5. The Student-t value
%    6. The confidence interval
% It plots a histogram of the data, with a fitted normal distribution, and
% the 
data = [4.108   4.367   3.548   4.172   4.064   3.738   3.913   4.069 ...
    4.716   4.554   3.730   4.607]; % Replace these with your data set
confLev = 0.95;
xbar = mean(data) % Arithmetic mean
S = std(data) % Standard Deviation
N = length(data) % Count
ESE = S/sqrt(N) % Estimated Standard Error
% tinv is for 1-tailed, for 2-tailed we need to halve the range
StdT = tinv((1-0.5*(1-confLev)),N-1) % The Student t value
lambda = StdT*ESE % 1/2 of the confidence interval �lambda
h = histfit(data); % Plot histogram and normal curve
hold on
bob = get(h(2)); % Get the normal curve data
mx = max(h(2).YData); % Get the max in the normal curve data
line([xbar xbar], [0 mx*1.05], 'LineWidth',3) % Plot a line for the mean
line([xbar-S xbar-S], [0 mx*0.65], 'LineWidth',3) % Plot a line for 1 S
                                                  % below the mean
line([xbar+S xbar+S], [0 mx*0.65], 'LineWidth',3) % Plot a line for
                                                  % 1 S above the mean
line([xbar-lambda xbar+lambda], [mx*1.07 mx*1.07]) % Plot the conf. int.
line([xbar-lambda xbar-lambda], [mx*1.02 mx*1.12])
line([xbar+lambda xbar+lambda], [mx*1.02 mx*1.12])
title('Histogram and Fitted Normal Distribution of Data')
xlabel('Data Range')
ylabel('Count')
txt2 = '$\leftarrow \bar{x} + S$';
text(xbar+S,mx*0.65,txt2,'Interpreter','latex')
txt3 = '$\bar{x} - S \rightarrow$';
text(xbar-S-0.55*S,mx*0.65,txt3,'Interpreter','latex')
txt4 = '  Confidence Interval';
text(xbar+lambda,mx*1.07,txt4)
hold off

