function [fitObj, sampleLag, gof] = plotStopSnips(data)

plotOn = false;
[pos,vel,accel] = filterAccel(data);

% [c, lags] = xcorr(diff(data.stimulus),diff(vel).*data.sampleRate,200);
% ix = find(lags > -15);
% c(ix) =[]; lags(ix) = [];
% ix = find(lags < -50);
% c(ix) =[]; lags(ix) = [];
% [v, ix] = max(c);
% lags(ix)

sampleLag = 21; %abs(lags(ix));
stopWin = [30, 160];
slopeSpan = 2;


sampDetail = 200:2*10^4;
time = [1:length(data.stimulus)]./data.sampleRate;
if plotOn
    figure;
    plot(time(sampDetail),vel(sampDetail + sampleLag),'k.-'); hold on;
    plot(time(sampDetail),data.stimulus(sampDetail)./3 - 0,'g.-');
end

scatterData = [];

 for n = 1:(length(data.stopSamples)-1)

     ext = 500;
     keySamp = data.stopSamples(n);

     if ((data.stopSamples(n) < sampDetail(end)) && plotOn)
         plot(time(keySamp),vel(keySamp + sampleLag),'go');
         plot(time((keySamp - slopeSpan):(keySamp - 1)),...
             vel(((keySamp - slopeSpan):(keySamp - 1))+sampleLag),'ro');
         plot(time((keySamp + 1):(keySamp + slopeSpan)),...
             vel(((keySamp + 1):(keySamp + slopeSpan))+sampleLag),'bo');
         plot(time(keySamp-1), data.stimulus(keySamp-1)./3,'ro');
         plot(time(keySamp), data.stimulus(keySamp)./3,'bo');
     end 
     
     stimDiff = data.stimulus(keySamp) - data.stimulus(keySamp-1);
     preAccel = mean(diff(vel(((keySamp - slopeSpan):(keySamp - 1))+sampleLag)))...
         .*data.sampleRate;
     postAccel = mean(diff(vel(((keySamp + 1):(keySamp + slopeSpan))+sampleLag)))...
         .*data.sampleRate;
     scatterData(end+1,:) = [stimDiff,postAccel-preAccel];    
 end
 
  [fitObj, gof] = fit(scatterData(:,1), scatterData(:,2), 'poly1');
 
  if plotOn
     xlabel('Time (s)');
     ylabel('dX/dT (mm/s) | Probe Voltage');

     figure;
     scatter(scatterData(:,1),scatterData(:,2),'.'); hold on;
     plot(fitObj);
     xlabel('Change in Probe V');
     ylabel('Change in Accel. (mm/s^2)');
  end
 
 