% logreader.m
% Use this script to read data from your micro SD card

clear;
%clf;

filenum = '178'; % file number for the data you want to read
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

% Thermistors 
Rp = 47000;
Rg = 49000;
Rf = 20000;
Rn = 10000;
r2 = 47000;

t1 = double(A01)*3.3/1023; %[V]
t2 = double(A02)*3.3/1023; %[V]

% voltage after voltage divider [V]
t1v = -(t1 - (1 + (Rf/Rn))*(5*Rg/(Rg+Rp)))*(Rn/Rf);
t2v = -(t2 - (1 + (Rf/Rn))*(5*Rg/(Rg+Rp)))*(Rn/Rf);

% resistance of thermistor [Ohms]
t1r = arrayfun(@(vo) r2*(5-vo)/vo, t1v);
t2r = arrayfun(@(vo) r2*(5-vo)/vo, t2v);

% temp recorded [C]
therm1 = -0.000681527*t1r + 58.13793;
therm2 = -0.000681527*t2r + 58.13793;

snum = 1:1:length(A01);
t = snum/10;

% motor a is A02, motor b is A01
figure(1)
plot(t,therm1)
hold on
plot(t,therm2)
xlabel("Time (s)")
ylabel("Temperature (C)")
title("Temperature of Motor Drivers")
legend("Motor B", "Motor A")


% Voltage circuit - pin A00
Rp2 = 15000;
Rg2 = 100000;
Rf2 = 10000;
Rn2 = 1000;
r22 = 100000;
r1 = 147000;

% [V]
v0 = double(A00)*3.3/1023;

% voltage before op amp
v1 = -(v0 - (1 + (Rf2/Rn2))*(5*Rg2/(Rg2+Rp2)))*(Rn2/Rf2);

% voltage of battery
vb = ((r22+r1)/r1)*v1;

figure(2)
%subplot(3,1,1)
plot(t,vb)
xlabel("Time (s)")
ylabel("Voltage (V)")
title("Voltage of the Battery")
%subplot(3,1,2)

figure(3)

R1 = 0.01;
R2 = 10000;
R3 = 330000;

v_sense = double(Current_Sense)*3.3/1023; %[V]

Ib = zeros(length(Current_Sense));

for i = 1:length(Current_Sense)
    Ib(i) = (vb(i)/R1) + (v_sense(i)/R3);
end
    

plot(t,Ib)
xlabel("Time (s)")
ylabel("Current (A)")
title("Current from Battery")









