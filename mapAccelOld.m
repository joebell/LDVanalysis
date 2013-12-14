function out = mapAccel(data)

    nBins = 64;
    
    [pos,vel,accel] = filterAccel(data);
    %accel = [zeros(1,22),data.stimulus'];

    
    %factor = -505;
    %accel = -(accel - (data.stimulus*factor));
    
    %micFactor = 10;
    %accel = (1/20000.*accel -  micFactor*data.mic)./abs(1/20000.*accel +  micFactor*data.mic);
    
%     pos = downsample(pos,5);
%     vel = downsample(vel,5);
%     accel = downsample(accel,5);
    
    
    posSpan = max(pos)-min(pos);
    velSpan = max(vel)-min(vel);
        posRange = [-1 1]*.4*10^-3; % mm
        velRange = [-1, 1]*1;          % mm/sec
%     posRange = [-1 1]*5*10^-5; % mm
%     velRange = [-.1, .1];          % mm/sec
     [posIdx, posBins] = evenBin(pos,posRange(1),posRange(2),nBins);
     [velIdx, velBins] = evenBin(vel,velRange(1),velRange(2),nBins);
%     [posIdx, posBins] = evenBin(pos,-6*std(pos),6*std(pos),nBins);
%     [velIdx, velBins] = evenBin(vel,-6*std(vel),6*std(vel),nBins);   
%     [posIdx, posBins] = evenBin(pos,-5*10^-5,5*10^-5,nBins);
%     [velIdx, velBins] = evenBin(vel,-.15,.15,nBins);  
    
    meanAccel = zeros(nBins,nBins,1);
    stdAccel  = zeros(nBins,nBins,1);
    med       = zeros(nBins,nBins,1);
    nAccel    = zeros(nBins,nBins,1);
    skew      = zeros(nBins,nBins,1);
    kurt      = zeros(nBins,nBins,1);
    
    for posN = 1:nBins
        posN
        for velN = 1:nBins
            
            ix = find( (posIdx == posN) & (velIdx == velN));
             
            meanAccel(posN,velN) = nanmean( accel(ix) );
            stdAccel(posN,velN)  = nanstd( accel(ix) );
            nAccel(posN,velN)    = length( accel(ix) );
            med(posN,velN)       = nanmedian(accel(ix));
            skew(posN,velN)      = skewness(accel(ix));
            kurt(posN,velN)      = kurtosis(accel(ix)); 
            
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
    out.posIdx = posIdx;
    out.velIdx = velIdx;

    
    