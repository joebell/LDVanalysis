function testFDTExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./testFDTExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];
%%
% This stimulus interleaves force-free blocks between
% equal amplitude sine bursts arranged in a random order.
%

daqSetup();
sampleRate = inputSampleRate;

pipAmp = -.5;
pipRange  = [20 1500]; % Hz
pipLength =  .250;     % Sec
pipRamp   = .05;       % Sec
pipGap    = .015;      % Sec
nPips     = 32;        % Sec 
nPipBlocks = 8;
freeBlockLength = 8/nPipBlocks;   % Sec

pipsPerBlock = nPips/nPipBlocks;
freqs = logspace(log10(pipRange(1)),log10(pipRange(2)),nPips);


nTrials = 1;

for trialN=1:nTrials
    trialN
    %freqOrder = randperm(length(freqs));
    load('freqOrder32.mat');
    
    stimulus = [];
    
    % When pips start
    startSamples = [];
    fullStartSamples = [];
    fullStopSamples  = [];
    stopSamples = [];
    % When free fluctuation epochs start
    freeStartSamples = [];
    freeStopSamples  = [];
    
    for blockN=1:nPipBlocks
        % Add a free block
        freeStartSamples(end+1) = length(stimulus)+1;
        stimulus = [stimulus,zeros(1,round(freeBlockLength*sampleRate))];
        freeStopSamples(end+1) = length(stimulus);
        
        % Add pips
        for pipN = 1:pipsPerBlock
            
            rampT = [0:(1/sampleRate):pipRamp];
            rampOn = (1/2) - (1/2)*cos(rampT*pi/pipRamp);
            rampSamples = length(rampOn);
            plateau = ones(1,round(pipLength*sampleRate));
            plateauSamples = length(plateau);
            envelope = [rampOn,plateau,fliplr(rampOn)];

            stimFreq = freqs(freqOrder(pipN + (blockN-1)*pipsPerBlock));
            segLength = 2*pipRamp+pipLength;
            t = ([1:length(envelope)]-1)./sampleRate;
            segment = 10^(pipAmp).*envelope.*[sin(2*pi*stimFreq*t)];

            startSamples(freqOrder(pipN + (blockN-1)*pipsPerBlock)) = length(stimulus)+1;
            fullStartSamples(freqOrder(pipN + (blockN-1)*pipsPerBlock)) = startSamples(freqOrder(pipN + (blockN-1)*pipsPerBlock))+ rampSamples;
            fullStopSamples(freqOrder(pipN + (blockN-1)*pipsPerBlock)) = fullStartSamples(freqOrder(pipN + (blockN-1)*pipsPerBlock)) + plateauSamples;
            stopSamples(freqOrder(pipN + (blockN-1)*pipsPerBlock)) = fullStopSamples(freqOrder(pipN + (blockN-1)*pipsPerBlock)) + rampSamples;

            stimulus = [stimulus,segment,zeros(1,round(pipGap*sampleRate))];             
        end
    end
    % Pad zeros at the end.
    stimulus = [stimulus,zeros(1,round(pipGap*sampleRate))];             
    
%     plot([1:length(stimulus)]./sampleRate,stimulus);
%     return;
    
    data = recLDV(stimulus');
    data.startSamples = startSamples;
    data.stopSamples = stopSamples;
    data.fullStartSamples = fullStartSamples;
    data.fullStopSamples = fullStopSamples;
    data.Fo = freqs;
    data.presentationOrder = freqOrder;
    data.freeStartSamples = freeStartSamples;
    data.freeStopSamples  = freeStopSamples;
    
    save([baseName,num2str(trialN),'.mat'],'data'); 

    % velSpectrum(data,pretty(randi(7)));
%     disp('CO2 ON');
%     pause(10);
%     disp('CO2 OFF');
%     pause(3);
end
    




