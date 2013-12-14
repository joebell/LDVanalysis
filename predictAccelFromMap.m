function out = predictAccelFromMap()

    load('accumulatedMap256.mat');
    map = interpolated;
    fileToTest = './130301/LDV130301_14_4.mat';
    posRange = [-.75,.75]*10^-3; % mm
    velRange = [-1, 1];          % mm/sec
    nBins = 256;

    load(fileToTest);
    
    % Filter at 5 kHz, 20 Hz
    h1=fdesign.lowpass('N,F3dB',8,5000/(data.sampleRate/2));
    d1 = design(h1,'butter');
    h2=fdesign.highpass('N,F3dB',8,20/(data.sampleRate/2));
    d2 = design(h2,'butter');
    
    % Calculate position and acceleration.
    vel = data.LDVvelocity;
    vel = filtfilt(d1.sosMatrix,d1.ScaleValues,vel); % LP
    vel = filtfilt(d2.sosMatrix,d2.ScaleValues,vel); % HP   
    pos = cumsum(vel)./data.sampleRate;
    pos = pos - mean(pos);
    accel = [diff(vel).*data.sampleRate;0];
    
    % Downsample traces
%     pos = downsample(pos,5);
%     vel = downsample(vel,5);
%     accel = downsample(accel,5);
    sR = 100000;
    stimTime = (1:length(pos))/sR;
    stimPeriod = (1/260); % Sec
    stimPhase = mod(stimTime,stimPeriod); % Sec
    [posIdx, posBins] = evenBin(pos,posRange(1),posRange(2),nBins);
    [velIdx, velBins] = evenBin(vel,velRange(1),velRange(2),nBins);
   
    for n=1:length(posIdx)
        predictedAccel(n) = map.mean(velIdx(n),posIdx(n));
    end
    predictedAccel = predictedAccel';

    phaseNum  = round(128*stimPhase/(1/260));

    abbPos     = pos(2.5*100000:6.5*100000);
    abbVel     = vel(2.5*100000:6.5*100000);
    abbPhaseNum = phaseNum(2.5*100000:6.5*100000);
    abbAccel = accel(2.5*100000:6.5*100000);
    abbPredAccel = predictedAccel(2.5*100000:6.5*100000);
    
    for n=1:128
        ix = find(abbPhaseNum == n);
        out.meanAccel(n) = mean(abbAccel(ix));
        out.stdAccel(n)  =  std(abbAccel(ix));
        out.meanPredAccel(n) = mean(abbPredAccel(ix));
        out.stdPredAccel(n)  =  std(abbPredAccel(ix));
    end
    
    figure();
    plot(abbPos(1:round(3*(1/260)*100000)),abbVel(1:round(3*(1/260)*100000)));
    
    figure;
    plot([1:128]*2*pi/128,out.meanAccel,'m'); hold on;
    plot([1:128]*2*pi/128,out.meanAccel+out.stdAccel,'--m'); hold on;
    plot([1:128]*2*pi/128,out.meanAccel-out.stdAccel,'--m'); hold on;    
    plot([1:128]*2*pi/128,out.meanPredAccel,'b'); hold on;
    plot([1:128]*2*pi/128,out.meanPredAccel+out.stdPredAccel,'--b'); hold on;
    plot([1:128]*2*pi/128,out.meanPredAccel-out.stdPredAccel,'--b'); hold on;    
    plot([1:128]*2*pi/128,(out.meanAccel-out.meanPredAccel),'r'); hold on;
  
    
    xlabel('Stimulus phase');
    ylabel('Acceleration (mm/s^2)');
    xlim([0 2*pi]);
        
    

