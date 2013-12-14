function timeSliceMap()

baseDir = '../Data/130508/';
baseName = 'LDV130508_4_';
fileList = dir([baseDir,baseName,'*.mat']);
nFiles = size(fileList,1);

timeBinWidth = .1;           % sec
timeBins     = [0,.1,.2,.5,1,2,5,10];
nTimeBins = length(timeBins);
posRange = [-.75,.75]*10^-3; % mm
velRange = [-1, 1];          % mm/sec
nBins = 64;

% Filter traces
for fileN=1:nFiles
    
    load([baseDir,fileList(fileN).name]);
    
    disp(['Filtering #',num2str(fileN)]);
    
    % Filter at 10 kHz, 20 Hz
    h1=fdesign.lowpass('N,F3dB',8,10000/(data.sampleRate/2));
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
    time = [1:length(vel)]./data.sampleRate;
    
    % Downsample traces
    pos = downsample(pos,5);
    vel = downsample(vel,5);
    accel = downsample(accel,5);
    time  = downsample(time, 5);
    
    [posIdx, posBins] = evenBin(pos,posRange(1),posRange(2),nBins);
    [velIdx, velBins] = evenBin(vel,velRange(1),velRange(2),nBins);
    
    data.pos = pos;
    data.vel = vel;
    data.accel = accel;
    data.posIdx = posIdx;
    data.velIdx = velIdx;
    data.posBins = posBins;
    data.velBins = velBins;
    data.time = time;
    
    save([baseDir,fileList(fileN).name],'data');
end

for timeBinN = 1:nTimeBins
    
    tStart = timeBins(timeBinN);
    tEnd   = tStart + timeBinWidth;
    idxStart = dsearchn(data.time',tStart);
    idxEnd   = dsearchn(data.time',tEnd);
    
    catPosIdx = [];
    catVelIdx = [];
    catAccel = [];
    for fileN = 1:nFiles
         
        load([baseDir,fileList(fileN).name]);
        
        catPosIdx = [catPosIdx,data.posIdx(idxStart:idxEnd)'];
        catVelIdx = [catVelIdx,data.velIdx(idxStart:idxEnd)'];
        catAccel  = [catAccel,data.accel(idxStart:idxEnd)'];
    end
    
    meanAccel   = zeros(nBins,nBins,1);
    nAccel      = zeros(nBins,nBins,1);
    stdAccel    = zeros(nBins,nBins,1);
    
    for posN = 1:nBins
        disp([' Bin: ',num2str(posN)]);
        for velN = 1:nBins
            % velN
            ix = find( (catPosIdx == posN) & (catVelIdx == velN));
            
            meanAccel(posN,velN)   = nanmean(catAccel(ix));
            stdAccel(posN,velN)    = nanstd(catAccel(ix));
            nAccel(posN,velN)      = length(catAccel(ix));
        end
    end
    map(timeBinN).mean = meanAccel';
    map(timeBinN).std = stdAccel';
    map(timeBinN).N = nAccel';
    map(timeBinN).posBins = posBins;
    map(timeBinN).velBins = velBins;
    map(timeBinN).timeBins = timeBins;
    map(timeBinN).timeBinWidth = timeBinWidth;
    
    save(['./',baseName,'TimeSlicedMaps.mat'],'map');
end




