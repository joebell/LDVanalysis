function xCorrAccel(data)
% 
% [pos,vel,accel] = filterAccel(data);
% stim = data.stimulus;

[c, lags] = xcorr(diff(data.stimulus),diff(data.LDVvelocity).*data.sampleRate,200);
%plot(lags,c);

ix = find(lags > -19);
c(ix) =[]; lags(ix) = [];
ix = find(lags < -50);
c(ix) =[]; lags(ix) = [];
[v, ix] = max(c);
lags(ix)