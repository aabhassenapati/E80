% logreader.m
% Use this script to read data from your micro SD card
% Script modified by Aabhas for Team 11 Lab 1 
clear;
%clf;

filenum = ['178']; % file number for the data you want to read
infofile = strcat('INF', filenum, '.TXT');
datafile = strcat('LOG', filenum, '.BIN');

%% map from datatype to length in bytes
dataSizes.('float') = 4;
dataSizes.('ulong') = 4;
dataSizes.('int') = 4;
dataSizes.('int32') = 4;
dataSizes.('uint8') = 1;
dataSizes.('uint16') = 2;
dataSizes.('char') = 1;
dataSizes.('bool') = 1;

%% read from info file to get log file structure
fileID = fopen(infofile);
items = textscan(fileID,'%s','Delimiter',',','EndOfLine','\r\n');
fclose(fileID);
[ncols,~] = size(items{1});
ncols = ncols/2;
varNames = items{1}(1:ncols)';
varTypes = items{1}(ncols+1:end)';
varLengths = zeros(size(varTypes));
colLength = 256;
for i = 1:numel(varTypes)
    varLengths(i) = dataSizes.(varTypes{i});
end
R = cell(1,numel(varNames));

%% read column-by-column from datafile
fid = fopen(datafile,'rb');
for i=1:numel(varTypes)
    %# seek to the first field of the first record
    fseek(fid, sum(varLengths(1:i-1)), 'bof');
    
    %# % read column with specified format, skipping required number of bytes
    R{i} = fread(fid, Inf, ['*' varTypes{i}], colLength-varLengths(i));
    eval(strcat(varNames{i},'=','R{',num2str(i),'};'));
end
fclose(fid);



%% Process your data here
% Statistics over the collected data and histogram with Mean, Std, etc

accelx = accelX
accely = accelY 
accelz = accelZ 

accelXY = accelx-accely
accelXZ = accelx-accelz
accelYZ = accely-accelz

data = accelXY
confLev = 0.95;
xbar = mean(data) % Arithmetic mean
S = std(data) % Standard Deviation
N = length(data) % Count
ESE = S/sqrt(N) % Estimated Standard Error
% tinv is for 1-tailed, for 2-tailed we need to halve the range
StdT = tinv((1-0.5*(1-confLev)),N-1) % The Student t value
lambda = StdT*ESE % 1/2 of the confidence interval �lambda

%Figure to Line plot the data from Accelerometer in Z axis:
figure(2)
%zp = scatter(1:63,accelZ, "blue")
plot(accelz,"ob")
meanz= mean(accelz)
nz=length(accelz)
stdz = std(accelz)
esez=stdz/sqrt(nz)
stdtz=tinv((1-0.5*(1-confLev)),nz-1)
lambdaz = stdtz*esez
hold on
box on
zmean = yline(meanz,"red", "mean = " + meanz)
legend(zmean, "Mean Z") 
title("Accelerated Z #")
%ylim([800 1400])
xlabel ("Sample No. #")
ylabel ("Acceleration in Z axis")
hold off

figure(3)

%yp = scatter(1:63,accelY, "blue")
plot(accely,"ob")
meany= mean(accely)

meany= mean(accely)
ny=length(accely)
stdy = std(accely)
esey=stdy/sqrt(ny)
stdty=tinv((1-0.5*(1-confLev)),ny-1)
lambday = stdty*esey
hold on
box on
ymean = yline(meany,"red", "mean = " + meany)
legend(ymean, "Mean Y") 
title("Acceleration in Y vs Sample No. #")
%ylim([800 1400])
xlabel ("Sample No. #")
ylabel ("Acceleration in Y axis")
hold off

figure(4)
%xp = scatter(1:63,accelX, "blue")
plot(accelx,"ob")
meanx= mean(accelx)
nx=length(accelx)
stdx = std(accelx)
esex=stdy/sqrt(nx)
stdtx=tinv((1-0.5*(1-confLev)),nx-1)
lambdax = stdtx*esex
hold on
box on
xmean = yline(meanx,"red", "mean = " + meanx)
legend(xmean, "Mean X") 
title("Acceleration in X vs Sample No. #")
%ylim([800 1400])
xlabel ("Sample No. #")
ylabel ("Acceleration in X axis")
hold off

%xp = scatter(1:63,accelX, "blue")
%p1 = plot(accelX)
%p2 = plot(accelY)
%p3 = plot(accelZ)
p4 = plot(A00)
p5 = plot(A01)
p6 = plot(A02)
box on

%legend([p1,p2, p3], {"X Acceleration", "Y Acceleration", "Z Acceleration"})
%title("Acceleration in all Axes vs Sample #")
%xlabel ("Sample No. #")
%ylabel ("Acceleration")






% figure(1) for histogram not needed
% h = histfit(data); % Plot histogram and normal curve
% hold on
% bob = get(h(2)); % Get the normal curve data
% mx = max(h(2).YData); % Get the max in the normal curve data
% line([xbar xbar], [0 mx*1.05], 'LineWidth',3) % Plot a line for the mean
% line([xbar-S xbar-S], [0 mx*0.65], 'LineWidth',3) % Plot a line for 1 S
%                                                   % below the mean
% line([xbar+S xbar+S], [0 mx*0.65], 'LineWidth',3) % Plot a line for
%                                                   % 1 S above the mean
% line([xbar-lambda xbar+lambda], [mx*1.07 mx*1.07]) % Plot the conf. int.
% line([xbar-lambda xbar-lambda], [mx*1.02 mx*1.12])
% line([xbar+lambda xbar+lambda], [mx*1.02 mx*1.12])
% title('Histogram and Fitted Normal Distribution of Data')
% xlabel('Data Range')
% ylabel('Count')
% txt2 = '$\leftarrow \bar{x} + S$';
% text(xbar+S,mx*0.65,txt2,'Interpreter','latex')
% txt3 = '$\bar{x} - S \rightarrow$';
% text(xbar-S-0.55*S,mx*0.65,txt3,'Interpreter','latex')
% txt4 = '  Confidence Interval';
% text(xbar+lambda,mx*1.07,txt4)
% hold off

