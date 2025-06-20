% danapointlog.m
% Modified by Aabhas Senapati and Elena Schwartz
%E80 Data Analysis

function output = danapoint(filenum)


%filenum = ['005']; % file number for the data you want to read
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


R1 = 0.1;
R2 = 10000.0;
R3 = 330000.0;

v_sense = double(Current_Sense+1)*3.3/1024; %[V]

Ib = zeros(1,length(Current_Sense)); 

for i = 1:length(Current_Sense)
    Ib(i) = v_sense(i)/(R1*(1 + (R3/R2))); 
end

power = vb.*Ib';
totalpower = trapz(power(120:1500))


%output = [therm1, therm2, vb, Ib];

figure(1)
%plot(t,movmean(therm1,60), "b")
hold on
plot(t,movmean(therm2,60))
xlabel("Time (s)")
xlim([0 400])
ylabel("Temperature (C)")
title("Temperature of Motor Driver IC")
legend("Motor A")
hold off


figure(2)
hold on
%subplot(3,1,1)
plot(t,movmean(vb, 60))
xlim([0 400])
xlabel("Time (s)")
ylabel("Voltage (V)")
title("Voltage of the Battery")
hold off
%subplot(3,1,2)

figure(3)
hold on
plot(t,movmean(1000*Ib, 60))
xlim([0 400])
xlabel("Time (s)")
ylabel("Current (mA)")
title("Current from Battery")
hold off

figure(4)
hold on
yyaxis left
plot(t,therm2)
xlim([0 400])
xlabel("Time (s)")
ylabel("Temperature (C)")
yyaxis right
plot(t, motorA)
ylabel("PWM of Motor A")
title("Step-Response of Motor Driver")
hold off

figure(8)
hold on
plot(max(motorA),max(therm2(1:2500)),'o')
maxtemp = max(therm2(1:2500))
maxpwm = max(motorA)


figure (5)
hold on
plot(t,movmean(power,60))
xlim([0 400])
xlabel("Time (s)")
ylabel("Power consumed in (W)")
title("Power Consumed over Time")
hold off

figure (6)
totalmeanpower = trapz(movmean(power(2000:3000),60));
totalpowers = [5607.2,
3656.3,
2173.1,
1201.8,
619.8581];
pwms = [255,  208, 164, 121, 78];
pwmsnew =linspace(0, 256);
pwmsn = [255, 208, 164, 121, 78];
totalpowersn =[5607.2,
3656.3,
2173.1,
1201.8,
619.8581];
%totalpowersn = [5495.4,  3837.4, 2283.7, 1245.6]
hold on
plot(pwms, totalpowers/10, 'bo')
% p = polyfit(pwmsn, totalpowersn/10, 2);
% v = polyval(p, pwmsnew);
% plot(pwmsnew, v,'r--')
xlim([50 255])
xlabel("PWM")
ylabel("Total Power consumed in 120 secs (W)")
title("Total Power Consumed vs PWM")
batterydfiff = vb(150)-vb(2000)
xlim([50 255])
xlabel("PWM")
ylabel("Total Power consumed in 120 secs (W)")
title("Total Power Consumed vs PWM")
hold off
% predicted = feval(fitresult, pwms); 
% residuals = totalpowersn/10 - predicted;
% n = length(pwms);
% sigma_residuals = sqrt(sum(residuals.^2) / (n - 4));
% batterydfiff = vb(150)-vb(2000)
% ci = confint(fitresult);
hold off

figure(7)
hold on
%pows = [5606.4,4084.9,2409.9,1407.9,619.8581];
mtemps = [38.0056,38.6806,34.0223,31.0953,29.5299];
%powsnew =linspace(0, 6000);
plot(pwms, mtemps, 'bo')
pmt = polyfit(pwms, mtemps, 2);
vmt = polyval(pmt, pwmsnew);
plot(pwmsnew, vmt,'r--')
ylabel("Maximum Temperature of the Motordriver IC (℃)")
xlabel("PWM")
xlim([0 255]);
title("Max. Temp (℃) vs PWM")

figure(9)
hold on

magxsm = movmean(magX,10);
[peaks, locations] = findpeaks(magxsm);
plot(t,magxsm);
xlim([0 200])
xlabel("Time (seconds)")
ylabel("Magnetometer Reading")
%plot(t,magY);
%plot(t,magZ);
%plot(t,motorA);

for i = 1:length(locations)
   if locations(i)>1000 & locations(i)<1470
    peakseligible(i) = peaks(i);
   end
end

threshold = max(peakseligible)-15
count = 0;

for i = 1:length(locations)
   if locations(i)>255 & locations(i)<1470
    if peaks(i) > threshold
        peaksn(count+1)=peaks(i);
        locationsn(count+1)=locations(i);
        count= count+1;
    end
   end
end

revs = count

plot(locationsn/10, peaksn, 'o');
hold off

figure(10);
revs = [37,33,30,26,18];
omega = (2*pi*revs)/120;
omegan = linspace(.5,2,100);
opows = [5613.2,3527.1,2409.9,1407.9,619.8581];
ratio = revs./opows;
hold on
plot(pwms, omega, 'bo')
po = polyfit(pwms, omega, 2);
v = polyval(po, pwmsnew);
plot(pwmsnew, v,'r--')
xlabel('PWM')
xlim([20 260])
ylabel('Angular Veolocity (rads/sec)')
title('Angular Velocity (rads/sec) vs PWM')
hold off

figure(11)
rtherm = [16480,20040,24620,30330,37400,46770,59730];
rtemps = [50.1,45.2,40.1,35.1, 30.3, 25.4, 19.9];

end

%effect of things like kelp getting stuck on motors and increasing current
%draw
