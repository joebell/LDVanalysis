function out = fakeMap()



    nBins = 64;
    posRange = [-1 1]*5*10^-5; % mm
    velRange = [-.1, .1];          % mm/sec
    pos = 1;vel = 1;
    [posIdx, posBins] = evenBin(pos,posRange(1),posRange(2),nBins);
    [velIdx, velBins] = evenBin(vel,velRange(1),velRange(2),nBins);
    
    out.posBins = posBins;
    out.velBins = velBins;
    
    k = -3.95*10^6;
    c = -502;
    
    for nP=1:length(posBins);
        for nV = 1:length(velBins);
            
            out.mean(nV,nP) = posBins(nP)*k + velBins(nV)*c;
            
        end
    end
    