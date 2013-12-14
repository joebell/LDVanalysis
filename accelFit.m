function accelFit(data)

    [pos,vel,accel] = filterAccel(data);
    stim = data.stimulus;
    %accel = [diff(data.LDVvelocity);0].*data.sampleRate;
    
    factor = -505;
    
    plot((accel - mean(accel)),'b'); hold on;
    plot((stim - mean(stim)).*factor,'r'); hold on;
    plot(accel - (stim*factor),'g');