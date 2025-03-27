%% Numerical Derivative Demo
% This file demonstrates how taking numerical derivatives increases noise
% and gives some info on how to calculate uncertainty.
sigma = 0.1; % Standard Deviation of white noise
nsamp = 65536; % Number of samples in signal
sr = 100; % Sample rate in Hz.
dt = 1/sr; % Sample Period
t = 0:dt:(nsamp-1)*dt; % The time array
en = sigma*randn(nsamp,1); % Generate the white noise waveform
den = diff(en)/dt; % Take the first derivative of the position curve
dden = diff(den)/dt; % Take the first derivative of the position curve
xbar = mean(en); % Arithmetic mean
S = std(en) % Standard Deviation
N = length(en) % Count
figure(1)
h=histfit(en)
bob = get(h(2)); % Get the normal curve data
mx = max(h(2).YData); % Get the max in the normal curve data
line([xbar xbar], [0 mx*1.05], 'LineWidth',3, 'color', 'r') % Plot a line for the mean
line([xbar-S xbar-S], [0 mx*0.65], 'LineWidth',3, 'color', 'r') % Plot a line for 1 S
                                                  % below the mean
line([xbar+S xbar+S], [0 mx*0.65], 'LineWidth',3, 'color', 'r') % Plot a line for
                                                  % 1 S above the mean
title('Histogram and Fitted Normal Distribution of Position Noise')
xlabel('Data Range')
ylabel('Count')
txt2 = '$\leftarrow \bar{x} + S$';
text(xbar+S,mx*0.65,txt2,'Interpreter','latex')
txt3 = '$\bar{x} - S \rightarrow$';
text(xbar-S-0.75*S,mx*0.65,txt3,'Interpreter','latex')

xbar = mean(den); % Arithmetic mean
S = std(den) % Standard Deviation
N = length(den) % Count
figure(2)
hd=histfit(den)
bob = get(hd(2)); % Get the normal curve data
mx = max(hd(2).YData); % Get the max in the normal curve data
line([xbar xbar], [0 mx*1.05], 'LineWidth',3, 'color', 'r') % Plot a line for the mean
line([xbar-S xbar-S], [0 mx*0.65], 'LineWidth',3, 'color', 'r') % Plot a line for 1 S
                                                  % below the mean
line([xbar+S xbar+S], [0 mx*0.65], 'LineWidth',3, 'color', 'r') % Plot a line for
                                                  % 1 S above the mean
title('Histogram and Fitted Normal Distribution of Velocity Noise')
xlabel('Data Range')
ylabel('Count')
txt2 = '$\leftarrow \bar{x} + S$';
text(xbar+S,mx*0.65,txt2,'Interpreter','latex')
txt3 = '$\bar{x} - S \rightarrow$';
text(xbar-S-0.75*S,mx*0.65,txt3,'Interpreter','latex')

xbar = mean(dden); % Arithmetic mean
S = std(dden) % Standard Deviation
N = length(dden) % Count
figure(3)
hdd=histfit(dden)
bob = get(hdd(2)); % Get the normal curve data
mx = max(hdd(2).YData); % Get the max in the normal curve data
line([xbar xbar], [0 mx*1.05], 'LineWidth',3, 'color', 'r') % Plot a line for the mean
line([xbar-S xbar-S], [0 mx*0.65], 'LineWidth',3, 'color', 'r') % Plot a line for 1 S
                                                  % below the mean
line([xbar+S xbar+S], [0 mx*0.65], 'LineWidth',3, 'color', 'r') % Plot a line for
                                                  % 1 S above the mean
title('Histogram and Fitted Normal Distribution of Acceleration Noise')
xlabel('Data Range')
ylabel('Count')
txt2 = '$\leftarrow \bar{x} + S$';
text(xbar+S,mx*0.65,txt2,'Interpreter','latex')
txt3 = '$\bar{x} - S \rightarrow$';
text(xbar-S-0.75*S,mx*0.65,txt3,'Interpreter','latex')

figure(4)
plot(t, en)
title('Position Noise time Series')
xlabel('Time')
ylabel('Position')

