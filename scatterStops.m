function scatterStops(dataList)

    sampleLatency = 22;

    for dataN = 1:length(dataList)
        data = dataList{dataN};
        [pos,vel,accel] = filterAccel(data);
        
        stopSamples = data.stopSamples + sampleLatency; % Account for latency
        
        stopPos = pos(stopSamples);
        stopVel = vel(stopSamples);
        
        scatter(stopPos,stopVel,'g.');
    end