function toneClickExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./toneClickExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];

daqSetup();
sampleRate = inputSampleRate;

stimFreq = 400;
clickSize = 0;
minAmp = -1;
maxAmp =  log10(10-abs(clickSize));
toneLength = .020;
clickLength = 20; % In # samples
trialLength = 20;
nTrials = 5;

for trialN=1:nTrials
    
    time = [0:(trialLength*sampleRate)]./sampleRate;
    stimulus = 0;
    cSample = 1;
    stopSamples = [];
    while (length(stimulus) < length(time))
        
        ampExp = rand(1)*(maxAmp - minAmp) + minAmp;
        segLength = 2*toneLength;
        segment = (10^(ampExp))*sin(2*pi*stimFreq*[0:(1/sampleRate):segLength]);
        clickStartSample = round(sampleRate*(toneLength + rand(1)/stimFreq));
        stopSamples(end+1) = length(stimulus)+clickStartSample;
        segment(clickStartSample:(clickStartSample+clickLength)) = segment(clickStartSample:(clickStartSample+clickLength)) + clickSize;
        stimulus = [stimulus,segment];        
    end
    stimulus(length(time):end) = [];
    ix = find(stopSamples > length(stimulus));
    stopSamples(ix) = [];
    stimulus(end) = 0;
    
%     plot(stimulus);
%     return;
    
    data = recLDV(stimulus');
    data.stopSamples = stopSamples;
    data.Fo = stimFreq;
    
    save([baseName,num2str(trialN),'.mat'],'data'); 
end
    
    
    
end

