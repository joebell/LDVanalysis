function out = mapAccel(dataList)

    nBins = 64;
    % stimShift = 21;
    stimShift = 0;
    stimCoeff =  1;
    sampleLatency = 30;
    sampleWin = 160;
    
    compositePosIdx = [];
    compositeVelIdx = [];
    compositeAccel  = [];
    compositeStim   = [];
    
    for dataN = 1:length(dataList)
        dataN
        data = dataList{dataN};
        [pos,vel,accel] = filterAccel(data);

         posRange = [-1.05 1.05]*max(pos(:)); % mm
         velRange = [-1.05, 1.05]*max(vel(:));          % mm/sec
%        posRange = [-1 1]*.2*10^-3; % mm
%        velRange = [-1, 1]*.3;          % mm/sec

        [posIdx, posBins] = evenBin(pos,posRange(1),posRange(2),nBins);
        [velIdx, velBins] = evenBin(vel,velRange(1),velRange(2),nBins);
        
        clippedPos = pos;
        clippedVel = vel;
        clippedPosIdx = posIdx;
        clippedVelIdx = velIdx;
        clippedAccel = accel;
%         for n=1:length(stopSamples)
%             clippedPos = [clippedPos,pos(stopSamples(n):pairedEnds(n))'];
%             clippedVel = [clippedVel,vel(stopSamples(n):pairedEnds(n))'];  
%             clippedPosIdx = [clippedPosIdx,posIdx(stopSamples(n):pairedEnds(n))'];
%             clippedVelIdx = [clippedVelIdx,velIdx(stopSamples(n):pairedEnds(n))'];
%             clippedAccel = [clippedAccel,accel(stopSamples(n):pairedEnds(n))'];
%         end

        compositePosIdx = [compositePosIdx,clippedPosIdx];
        compositeVelIdx = [compositeVelIdx,clippedVelIdx];
        compositeAccel  = [compositeAccel,clippedAccel];
        compositeStim   = [compositeStim, data.stimulus];
        
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
            ixx = find((ix - stimShift) < 1);
            ix(ixx) = [];
            meanAccel(posN,velN) = nanmean( compositeAccel(ix));
            stdAccel(posN,velN)  = nanstd( compositeAccel(ix));
            nAccel(posN,velN)    = length( compositeAccel(ix));
            med(posN,velN)       = nanmedian(compositeAccel(ix));
            skew(posN,velN)      = skewness(compositeAccel(ix));
            kurt(posN,velN)      = kurtosis(compositeAccel(ix)); 
            meanStim(posN, velN) = nanmean(stimCoeff.*compositeStim(ix - stimShift));
            
        end
    end
    
    out.mean = meanAccel';
    out.std  = stdAccel';
    out.N = nAccel';
%     out.median = med';
%     out.skew = skew';
%     out.kurt = kurt';
     out.posBins = posBins;
     out.velBins = velBins;
%     out.posIdx = compositePosIdx;
%     out.velIdx = compositeVelIdx;
%     out.accel  = compositeAccel;
    out.meanStim = meanStim';

    
    