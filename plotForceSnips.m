function plotForceSnips(data)

forceScale = 10^3/(1.93*10^-12);
forceScale = 10^3/(4.29*10^-12);
timeWindow = [9,9.02];
stimShift = 0;

figure;

%load('../Data/131029/LDV131029_14_2.mat');

[pos,vel,accel] = filterAccel(data);
% Shift stimulus to align
stim = [zeros(stimShift,1);data.stimulus(1:(end-stimShift))];

time = [1:length(vel)]./data.sampleRate;
stIx = dsearchn(time',timeWindow(1));
enIx = dsearchn(time',timeWindow(2));
win = stIx:enIx;

subplot(3,1,1);
%plot(time(win),accel(win)./rms(accel(win)),'r'); hold on;
plot(time(win),vel(win)./rms(vel(win)),'m'); hold on;
plot(time(win),pos(win)./rms(pos(win)),'b'); hold on;
plot(time(win),stim(win)./rms(stim(win)),'g'); hold on;
title('{\color{blue} Pos.} {\color{magenta} Vel.} {\color{green} Stim.}');
xlim(timeWindow);

subplot(3,1,2);
subtStim = accel - forceScale*stim;
%plot(time(win),accel(win)./rms(accel(win)),'r'); hold on;
plot(time(win),stim(win)./rms(stim(win)),'g'); hold on;
plot(time(win),subtStim(win)./rms(subtStim(win)),'m'); hold on;
title('{\color{magenta} Self Forcing} {\color{green} Stim.}');
xlim(timeWindow);

subplot(3,1,3);
selfPowerInput = subtStim.*vel;
stimPowerInput = forceScale.*stim.*vel;
plot(time(win),stim(win)./rms(stim(win)),'g'); hold on;
plot(time(win),selfPowerInput(win)./rms(stimPowerInput(win)),'b'); hold on;
plot(time(win),stimPowerInput(win)./rms(stimPowerInput(win)),'m'); hold on;
plot(time(win),0,'k');
title('{\color{blue} Self Power Input} {\color{magenta} Stim. Power Input} {\color{green} Stim.}');
xlim(timeWindow);

% subplot(4,1,4);
% % stimInput = gaussConv(stimPowerInput,.5,data.sampleRate);
% % selfInput = gaussConv(selfPowerInput,.5,data.sampleRate);
% interval = .1;
% meanStim = [];
% meanSelf = [];
% rmsStim = [];
% for stTime = 0:interval:(time(end)-interval)
%     
%     stIx = dsearchn(time',stTime);
%     enIx = dsearchn(time',stTime+interval);
%     meanStim(end+1) = mean(stimPowerInput(stIx:enIx));
%     meanSelf(end+1) = mean(selfPowerInput(stIx:enIx));
%     rmsStim(end+1) = rms(stim(stIx:enIx));
% end
% 
% % plot(meanStim,'m'); hold on;
% % plot(meanSelf,'b');
% ix = find(meanStim < 0);
% loglog(rmsStim(ix),abs(meanStim(ix)),'m.'); hold on;
% ix = find(meanStim >= 0);
% loglog(rmsStim(ix),abs(meanStim(ix)),'r.'); hold on;
% ix = find(meanSelf < 0);
% loglog(rmsStim(ix),abs(meanSelf(ix)),'c.'); hold on;
% ix = find(meanSelf >= 0);
% loglog(rmsStim(ix),abs(meanSelf(ix)),'b.'); hold on;
    

