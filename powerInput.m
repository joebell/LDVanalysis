function powerInput(data)


forceScale = 10^3/(1.93*10^-12);
forceScale = 10^3/(4.29*10^-12);
stimShift = 0;

%figure;

[pos,vel,accel] = filterAccel(data);
% Shift stimulus to align
stim = [zeros(stimShift,1);data.stimulus(1:(end-stimShift))];
time = [1:length(vel)]./data.sampleRate;
subtStim = accel - forceScale*stim;
selfPowerInput = subtStim.*vel;
stimPowerInput = forceScale.*stim.*vel;


interval = round(.100*data.Fo)*(1/data.Fo);
meanStim = [];
meanSelf = [];
rmsStim = [];
for stTime = 0:interval:(time(end)-interval)
    
    stIx = dsearchn(time',stTime);
    enIx = dsearchn(time',stTime+interval);
    meanStim(end+1) = mean(stimPowerInput(stIx:enIx));
    meanSelf(end+1) = mean(selfPowerInput(stIx:enIx));
    rmsStim(end+1) = rms(stim(stIx:enIx));
end

plot(meanStim,'m'); hold on;
plot(meanSelf,'b');
plot(meanStim + meanSelf,'r');
plot(xlim(),[0 0],'k-.');
title('{\color{magenta} Stim. Power Input} {\color{blue} Self Power Input}');
xlabel('Time bin');

% ix = find(meanStim < 0);
% loglog(rmsStim(ix),abs(meanStim(ix)),'m.'); hold on;
% ix = find(meanStim >= 0);
% loglog(rmsStim(ix),abs(meanStim(ix)),'r.'); hold on;
% ix = find(meanSelf < 0);
% loglog(rmsStim(ix),abs(meanSelf(ix)),'c.'); hold on;
% ix = find(meanSelf >= 0);
% loglog(rmsStim(ix),abs(meanSelf(ix)),'b.'); hold on;