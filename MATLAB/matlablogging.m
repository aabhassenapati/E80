% matlablogging
% reads from Teensy data stream

function teensyanalog=matlablogging(length)
    length = 5000;  % 5000 is hardcoded buffer size on Teensy
    s = serial('/dev','BaudRate',115200);
    set(s,'InputBufferSize',2*length)
    fopen(s);
    fprintf(s,'%d',2*length)         % Send length to Teensy
    dat = fread(s,2*length,'uint8');      
    fclose(s);
    teensyanalog = uint8(dat);
    teensyanalog = typecast(teensyanalog,'uint16');
end
data = dat;





figure(1)
plot(data,"ob")
meand= mean(data)
n=length(data)
stdd = std(data)
esez=stdd/sqrt(n)
stdtz=tinv((1-0.5*(1-confLev)),nz-1)
lambda = stdtz*esez
hold on
box on
dmean = yline(meand,"red", "mean = " + meand)
legend(dmean, "Mean") 
title("Accelerated Z #")
%ylim([800 1400])
xlabel ("Sample No. #")
ylabel ("Acceleration in Z axis")
hold off

%str = fscanf(s);
%teensyanalog = str2num(str);

%[teensyanalog, count] = fscanf(s,['%d']);