%% Accel Demo
% This file simulates a 1-D acceleration measured by an accelerometer with
% noise. It cacluates the true acceleration, velocity and position, and
% then adds gaussian white noise to the true acceleration to generate the
% simulated measured acceleration. It then integrates the measured
% acceleration once to get calculated velocity, and then a second time to
% get calculated position. It calculates the error bounds for the position
% and velocity based on the standard deviation of the sensor and the
% specified confidence level.
dt = 0.01; % The sampling rate
t = 0:dt:dt*length(accelX)-dt; % The time array
%a = 1 + sin( pi*t -pi/2); % The modeled acceleration
a = accelY;
la = length(a);
la2 = round(length(a)/5);
a([la2:end]) = 0; % We only want one cycle of the sine wave.
sigma = std(accelX); % The standard deviation of the noise in the accel.
confLev = 0.95; % The confidence level for bounds
preie = sqrt(2)*erfinv(confLev)*sigma*sqrt(dt); % the prefix to the sqrt(t)
preiie = 2/3*preie; % The prefix to t^3/2a = 1 + sin( pi*t - pi/2);
plusie=preie*t.^0.5; % The positive noise bound for one integration
plusiie = preiie*t.^1.5; % The positive noise bound for double integration
en = sigma*randn(1, la); % Generate the noise
v = cumtrapz(t,a); % Integrate the true acceleration to get the true velocity
r = cumtrapz(t,v); % Integrate the true velocity to get the true position.
an = accelX; % Generate the noisy measured acceleration
vn = cumtrapz(t,an); % Integrate the measured acceleration to get the velocity
vnp = vn + plusie'; % Velocity plus confidence bound
vnm = vn - plusie'; % Velocity minus confidence bound
rn = cumtrapz(t,vn); % Integrate the velocity to get the position
rnp = rn + plusiie'; % Position plus confidence bound
rnm = rn - plusiie'; % Position minus confidence bound
figure(1)
plot(t, a,'linewidth',2)
hold on
plot(t, an)
hold off
xlabel('Time (s)')
ylabel('Acceleration')
title('True and Measured Acceleration')
legend('True Acceleration','Measured Acceleration','location','northeast')
figure(2)
plot(t, v, t, vn, t, vnp,'-.', t, vnm,'-.')
xlabel('Time (s)')
ylabel('Velocity')
title('Y Calculated Velocity from Measured Acceleration')
legend('True Velocity','Calculated Velocity','Upper Confidence Bound',...
    'Lower Confidence Bound','location','southeast')
figure(3)
plot(t, rn, t, rnp,'-.', t, rnm,'-.')
xlabel('Time (s)')
ylabel('Y Position (m)')
title('Calculated Position from Measured Acceleration')
legend('Calculated Y Position','Upper Confidence Bound',...
    'Lower Confidence Bound','location','southeast')

yv = cumtrapz(t, accelY/1000);
yc = cumtrapz(t, yv);

xv = cumtrapz(t, accelX/1000);
xc = cumtrapz(t, xv);

figure(4)
plot(xc, yc)
xlabel('X Coordinate (m)')
ylabel('Y Coordinate (m)')
title('XY Position of Board Stack')
hold on 
x2 = 0:dt:0.5;
y2 = zeros(length(x2));
plot(x2, y2)
xlim = -.1
legend('XY Coordinates of Board Stack', "Ideal 0.5 m Path")


