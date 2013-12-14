function [pos,vel,accel] = filterAccel(data)

    % Filter at 10 kHz, 20 Hz
    h1=fdesign.lowpass('N,F3dB',4,20000/(data.sampleRate/2));
    d1 = design(h1,'butter');
    h2=fdesign.highpass('N,F3dB',4,20/(data.sampleRate/2));
    d2 = design(h2,'butter');
    
%     vel = data.LDVvelocity;
%     vel = filtfilt(d1.sosMatrix,d1.ScaleValues,vel); % LP
%     vel = filtfilt(d2.sosMatrix,d2.ScaleValues,vel); % HP   
%     pos = cumsum(vel)./data.sampleRate;
%     pos = pos - mean(pos);
%     accel = [diff(vel).*data.sampleRate;0];

    pos = cumsum(data.LDVvelocity)./data.sampleRate;
    pos = filtfilt(d1.sosMatrix,d1.ScaleValues,pos); % LP
    pos = filtfilt(d2.sosMatrix,d2.ScaleValues,pos); % HP   
    vel = [diff(pos).*data.sampleRate;0];
    accel = [diff(vel).*data.sampleRate;0];