function phaseStopSnips(data)
 
[pos,vel,accel] = filterAccel(data);

sampleLag = 30;
sampleWin = 150;

 for n = 1:50
     figure;
     ext = 500;
     sampleList = (data.stopSamples(n)+sampleLag):(data.stopSamples(n)+sampleLag+sampleWin);
     postSampleList = (data.stopSamples(n)+sampleLag+sampleWin):(data.stopSamples(n)+sampleLag+round(.010*data.sampleRate));
     preSampleList = (sampleList(1) - 1000):sampleList(1);

     plot(pos(preSampleList),vel(preSampleList),'k');
     hold on;
     plot(pos(sampleList),vel(sampleList),'g');
     plot(pos(postSampleList),vel(postSampleList),'b');
 
        xlim([-1 1]*2*10^-3);
        ylim([-1 1]*6);
 end
 