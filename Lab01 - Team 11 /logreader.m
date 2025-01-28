% logreader.m
% Use this script to read data from your micro SD card
% Script modified by Aabhas for Team 11 Lab 1 
clear;
%clf;

filenum = '003'; % file number for the data you want to read
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
data = accelZ
confLev = 0.95;
xbar = mean(data) % Arithmetic mean
S = std(data) % Standard Deviation
N = length(data) % Count
ESE = S/sqrt(N) % Estimated Standard Error
% tinv is for 1-tailed, for 2-tailed we need to halve the range
StdT = tinv((1-0.5*(1-confLev)),N-1) % The Student t value
lambda = StdT*ESE % 1/2 of the confidence interval �lambda
figure(1)
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

Figure to Line plot the data from Accelerometer:
figure(2)
np = plot(accelY)
