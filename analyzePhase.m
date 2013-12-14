function analyzePhase(data)

figure;

subplot(3,1,1);
powerInput(data);

    %load('../Data/131029/LDV131029_14_4.mat');
    [pos,vel,accel] = filterAccel(data);
    time = [1:length(vel)]./data.sampleRate;
    
interval = round(.100*data.Fo)*(1/data.Fo);
response = [];
stimResp = [];
f2 = [];
f3 = [];
f4 = [];
f5 = [];

for stTime = 0:interval:(time(end)-interval)
    
    stIx = dsearchn(time',stTime);
    enIx = dsearchn(time',stTime+interval);
    response(end+1) = fourierComponent(pos(stIx:enIx),data.Fo,data.sampleRate);
    stimResp(end+1) = fourierComponent(data.stimulus(stIx:enIx),data.Fo,data.sampleRate);
    f2(end+1) = fourierComponent(pos(stIx:enIx),data.Fo*2,data.sampleRate);
    f3(end+1) = fourierComponent(pos(stIx:enIx),data.Fo*3,data.sampleRate);
    f4(end+1) = fourierComponent(pos(stIx:enIx),data.Fo*4,data.sampleRate);
    f5(end+1) = fourierComponent(pos(stIx:enIx),data.Fo*5,data.sampleRate);
end

subplot(3,1,2);
semilogy(abs(response),'b'); hold on;
semilogy(abs(stimResp),'g');
semilogy(abs(f2),'Color',pretty(1));
semilogy(abs(f3),'Color',pretty(2));
% semilogy(abs(f4),'Color',pretty(3));
% semilogy(abs(f5),'Color',pretty(4));

title('{\color{green} Stim. Amp.} {\color{blue} Resp. Amp.}');
subplot(3,1,3);
plot(angle(response),'b'); hold on;
plot(angle(stimResp),'g');
plot(angle(f2),'Color',pretty(1));
plot(angle(f3),'Color',pretty(2));
% plot(angle(f4),'Color',pretty(3));
% plot(angle(f5),'Color',pretty(4));
ylim([-pi pi]);
title('{\color{green} Stim. Phase} {\color{blue} Resp. Phase}');
xlabel('Time bin');

    
    
    