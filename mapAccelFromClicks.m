function out = mapAccelFromClicks(dataList)

    nBins = 64;
    sampleLatency = 22;
    clickLength = 20;
    
    compositePosIdx = [];
    compositeVelIdx = [];
    compositeAccel  = [];
    
    for dataN = 1:length(dataList)
        dataN
        data = dataList{dataN};
        [pos,vel,accel] = filterAccel(data);

        posRange = [-1 1]*12*10^-4; % mm
        velRange = [-1, 1]*3;          % mm/sec
        [posIdx, posBins] = evenBin(pos,posRange(1),posRange(2),nBins);
        [velIdx, velBins] = evenBin(vel,velRange(1),velRange(2),nBins);

        stopSamples = data.stopSamples + sampleLatency; % Account for latency
        pairedEnds  = data.stopSamples + sampleLatency + clickLength;
        ix = find(pairedEnds > length(pos));
        stopSamples(ix) = [];
        pairedEnds(ix) = [];

        clippedPos = [];
        clippedVel = [];
        clippedPosIdx = [];
        clippedVelIdx = [];
        clippedAccel = [];
        for n=1:length(stopSamples)
            clippedPos = [clippedPos,pos(stopSamples(n):pairedEnds(n))'];
            clippedVel = [clippedVel,vel(stopSamples(n):pairedEnds(n))'];  
            clippedPosIdx = [clippedPosIdx,posIdx(stopSamples(n):pairedEnds(n))'];
            clippedVelIdx = [clippedVelIdx,velIdx(stopSamples(n):pairedEnds(n))'];
            clippedAccel = [clippedAccel,accel(stopSamples(n):pairedEnds(n))'];
        end

        compositePosIdx = [compositePosIdx,clippedPosIdx];
        compositeVelIdx = [compositeVelIdx,clippedVelIdx];
        compositeAccel  = [compositeAccel,clippedAccel];
        
    end
    
%     plot(accel./5000,'r'); hold on;
%     plot(clippedVel,'g');
%     plot(clippedPos.*5000,'b');
        
    
    meanAccel = zeros(nBins,nBins,1);
    stdAccel  = zeros(nBins,nBins,1);
    med       = zeros(nBins,nBins,1);
    nAccel    = zeros(nBins,nBins,1);
    skew      = zeros(nBins,nBins,1);
    kurt      = zeros(nBins,nBins,1);
    
    for posN = 1:nBins
        posN
        for velN = 1:nBins
            
            ix = find( (compositePosIdx == posN) & (compositeVelIdx == velN));
             
            meanAccel(posN,velN) = nanmean( compositeAccel(ix) );
            stdAccel(posN,velN)  = nanstd( compositeAccel(ix) );
            nAccel(posN,velN)    = length( compositeAccel(ix) );
            med(posN,velN)       = nanmedian(compositeAccel(ix));
            skew(posN,velN)      = skewness(compositeAccel(ix));
            kurt(posN,velN)      = kurtosis(compositeAccel(ix)); 
            
        end
    end
    
    out.mean = meanAccel';
    out.std  = stdAccel';
    out.N = nAccel';
    out.median = med';
    out.skew = skew';
    out.kurt = kurt';
    out.posBins = posBins;
    out.velBins = velBins;
    out.posIdx = compositePosIdx;
    out.velIdx = compositeVelIdx;
    out.accel  = compositeAccel;

    
    