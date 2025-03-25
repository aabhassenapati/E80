% Plot.m
% Script by Aabhas Senapati from Team 11 - Lab 1 
% asenapati@g.hmc.edu
% 31st January, 2025

clear;
%clf;

%Reading file from SD card
filenum = ['113']; % file number for our tank room data
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


% Data Processing and Plotting for figure 1
figure(1)

time = 1:1915; % This is the length of our data frame, and we are using the full length
time = time/10; % converting time to seconds, as we know sampling rate is 10 Hz

%multiplied all axis with .01, to calibrate and convert accelerometer units
%to m/s^2, as we found 991 units = 9.81 m/s^2 apprximately giving 
% 1 a.u. = 0.01 m/s^2

p1 = plot(time, accelX*0.01) % x-axis accelrometer data plot
hold on
p2 = plot(time, accelY*0.01) % y-axis accelrometer data plot
p3 = plot(time, accelZ*0.01) % z-axis accelrometer data plot

hold on
box on

legend([p1,p2, p3], {"X Acceleration", "Y Acceleration", "Z Acceleration"})
title("Acceleration vs Time")
xlabel ("Time (Secs)")
xlim([0 192]) % Put limits on the xaxis for the plot
ylabel ("Acceleration (m/s^2)")
hold off