function out = accumulateMap()

% fileList = {'./130301/LDV130301_21_1.mat',...
%             './130301/LDV130301_21_2.mat',...
%             './130301/LDV130301_21_3.mat',...
%             './130301/LDV130301_21_4.mat',...
%             './130301/LDV130301_22_1.mat',...
%             './130301/LDV130301_22_2.mat',...
%             './130301/LDV130301_22_3.mat',...
%             './130301/LDV130301_22_4.mat',...
%             './130301/LDV130301_23_1.mat',...
%             './130301/LDV130301_23_2.mat',...
%             './130301/LDV130301_23_3.mat',...
%             './130301/LDV130301_23_4.mat'};

fileList = {'./LDV130302_2_1.mat',...
            './LDV130302_2_2.mat',...
            './LDV130302_2_3.mat',...
            './LDV130302_2_4.mat',...
            './LDV130302_3_1.mat',...
            './LDV130302_3_2.mat',...
            './LDV130302_3_3.mat',...
            './LDV130302_3_4.mat',...
            './LDV130302_4_1.mat',...
            './LDV130302_4_2.mat',...
            './LDV130302_4_3.mat',...
            './LDV130302_4_4.mat',...
            
            };


posRange = [-.75,.75]*10^-3; % mm
posRange = posRange/5;
velRange = [-1, 1];          % mm/sec
velRange = velRange/5;
nBins = 128;

meanAccel   = zeros(nBins,nBins,1);
nAccel      = zeros(nBins,nBins,1);
stdAccel    = zeros(nBins,nBins,1);

% Filter traces
for fileN=1:length(fileList)
    
    load(fileList{fileN});
    
    fileN
    
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
    
    % Downsample traces
    pos = downsample(pos,5);
    vel = downsample(vel,5);
    accel = downsample(accel,5);
    
    [posIdx, posBins] = evenBin(pos,posRange(1),posRange(2),nBins);
    [velIdx, velBins] = evenBin(vel,velRange(1),velRange(2),nBins);

    
    data.pos = pos;
    data.vel = vel;
    data.accel = accel;
    data.posIdx = posIdx;
    data.velIdx = velIdx;
    data.posBins = posBins;
    data.velBins = velBins;
    
    save(fileList{fileN},'data');
end

catData();

    
outFile = './LDVcatDataDead.mat';      
load(outFile);

for posN = 1:nBins
    disp([' Bin: ',num2str(posN)]);
    for velN = 1:nBins
        % velN
        ix = find( (data.posIdx == posN) & (data.velIdx == velN));

        meanAccel(posN,velN)   = nanmean(data.accel(ix));
        stdAccel(posN,velN)    = nanstd(data.accel(ix));
        nAccel(posN,velN)      = length(data.accel(ix));
    end
end

out.mean = meanAccel';
out.std  = stdAccel';
out.N    = nAccel';
out.posBins = data.posBins;
out.velBins = data.velBins;

save('accumulatedMapDeadLow.mat','out');