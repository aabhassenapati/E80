% logreader.m
% Use this script to read data from your micro SD card

clear;
clf;

filenum = '005'; % file number for the data you want to read
infofile = strcat('inf', filenum, '.TXT');
datafile = strcat('log', filenum, '.BIN');

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
clf
% Thermistors 
Rp = 47000;
Rg = 49000;
Rf = 20000;
Rn = 10000;
r2 = 47000;

t1 = double(A01+1)*(3.3/1024); %[V]
t2 = double(A02+1)*(3.3/1024); %[V]

% voltage after voltage divider [V]
t1v = -(t1 - (1 + (Rf/Rn))*(5*Rg/(Rg+Rp)))*(Rn/Rf);
t2v = -(t2 - (1 + (Rf/Rn))*(5*Rg/(Rg+Rp)))*(Rn/Rf);

% resistance of thermistor [Ohms]
t1r = arrayfun(@(vo) r2*(5-vo)/vo, t1v);
t2r = arrayfun(@(vo) r2*(5-vo)/vo, t2v);

%recheck the equations and for the range of 15-55 degree celcius range with
%more precision and do a steihert kind of fit
% temp recorded [C]
therm1 = 277 - 23.4*log(t1r);
therm2 =  274 - 23.1*log(t2r);

snum = 1:1:length(A01);
t = snum/10;

% motor a is A02 - red thermistor, motor b is A01 - white thermistor -
figure(1)
plot(t,therm1, "b")
hold on
plot(t,therm2, "r")
xlabel("Time (s)")
ylabel("Temperature (C)")
title("Temperature of Motor Drivers")
legend("Motor B", "Motor A")
hold off

figure(5)
hold on
plot(t, A02+1, "r")
plot(t, A01+1, "b")
hold off

% Voltage circuit - pin A00
Rp2 = 15000;
Rg2 = 100000;
Rf2 = 10000;
Rn2 = 1000;
r22 = 100000;
r1 = 147000;

% [V]
v0 = double(A00+1)*(3.3/1024);

% voltage before op amp
v_ = -(v0-(1+10)*(500/115))/(10);

% voltage of battery
vb = ((100+147)/100)*v_;

figure(2)
%subplot(3,1,1)
plot(t,vb)
xlabel("Time (s)")
ylabel("Voltage (V)")
title("Voltage of the Battery")
%subplot(3,1,2)

figure(3)

R1 = 0.1;
R2 = 10000.0;
R3 = 330000.0;

v_sense = double(Current_Sense+1)*3.3/1024; %[V]

Ib = zeros(1,length(Current_Sense)); 

for i = 1:length(Current_Sense)
    Ib(i) = v_sense(i)*(R2/(R3*R1)); 
end
    

plot(t,1000*Ib)
xlabel("Time (s)")
ylabel("Current (mA)")
title("Current from Battery")


power = Ib.*vb';
figure(4)
plot(t,power)
xlabel("Time (s)")
ylabel("Power (W)")
title("Power draw of Circuit")







%effect of things like kelp getting stuck on motors and increasing current
%draw