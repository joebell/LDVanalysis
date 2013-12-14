function frequencyPipsExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./frequencyPipsExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];
%%

daqSetup();
sampleRate = inputSampleRate;

pipAmp = -.5;
pipRange  = [20 200]; % Hz
pipLength =  .5; % Sec
pipRamp   = .05; % Sec
pipGap    = .015;
nPips     = 32;
freqs = logspace(log10(pipRange(1)),log10(pipRange(2)),nPips);
freqOrder = randperm(length(freqs));

nTrials = 1;

for trialN=1:nTrials
    
    stimulus = [];
    startSamples = [];
    fullStartSamples = [];
    fullStopSamples  = [];
    stopSamples = [];
    
    for pipN = 1:nPips               
        rampT = [0:(1/sampleRate):pipRamp];
        rampOn = (1/2) - (1/2)*cos(rampT*pi/pipRamp);
        rampSamples = length(rampOn);
        plateau = ones(1,round(pipLength*sampleRate));
        plateauSamples = length(plateau);
        envelope = [rampOn,plateau,fliplr(rampOn)];
        
        stimFreq = freqs(freqOrder(pipN));
        segLength = 2*pipRamp+pipLength;
        t = ([1:length(envelope)]-1)./sampleRate;
        segment = 10^(pipAmp).*envelope.*[sin(2*pi*stimFreq*t)];
 
        startSamples(freqOrder(pipN)) = length(stimulus)+1;
        fullStartSamples(freqOrder(pipN)) = startSamples(freqOrder(pipN))+ rampSamples;
        fullStopSamples(freqOrder(pipN)) = fullStartSamples(freqOrder(pipN)) + plateauSamples;
        stopSamples(freqOrder(pipN)) = fullStopSamples(freqOrder(pipN)) + rampSamples;
        
        stimulus = [stimulus,segment,zeros(1,round(pipGap*sampleRate))];        
    end
    
    data = recLDV(stimulus');
    data.startSamples = startSamples;
    data.stopSamples = stopSamples;
    data.fullStartSamples = fullStartSamples;
    data.fullStopSamples = fullStopSamples;
    data.Fo = freqs;
    data.presentationOrder = freqOrder;
    
    save([baseName,num2str(trialN),'.mat'],'data'); 

    % velSpectrum(data,pretty(randi(7)));
%     disp('CO2 ON');
%     pause(30);
%     disp('CO2 OFF');
%     pause(10);
end
