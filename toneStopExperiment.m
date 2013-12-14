function toneStopExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./toneStopExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];

daqSetup();
sampleRate = inputSampleRate;

stimFreq = 300;
minAmp = .6;
maxAmp = 1;
toneLength = .010;
stopLength = .015;
trialLength = 20;
nTrials = 5;

for trialN=1:nTrials
    
    time = [0:(trialLength*sampleRate)]./sampleRate;
    stimulus = 0;
    cSample = 1;
    stopSamples = [];
    while (length(stimulus) < length(time))
        
        ampExp = rand(1)*(maxAmp - minAmp) + minAmp;
        segLength = toneLength + rand(2)*(1/stimFreq);
        stimulus = [stimulus,(10^(ampExp))*sin(2*pi*stimFreq*[0:(1/sampleRate):segLength])];
        stopSamples(end+1) = length(stimulus)+1;
        stimulus = [stimulus,zeros(stopLength.*sampleRate,1)'];
        
    end
    stimulus(length(time):end) = [];
    ix = find(stopSamples > length(stimulus));
    stopSamples(ix) = [];
    stimulus(end) = 0;
    
    data = recLDV(stimulus');
    data.stopSamples = stopSamples;
    data.Fo = stimFreq;
    
    save([baseName,num2str(trialN),'.mat'],'data'); 
    
%     disp('CO2 ON');
%     pause(15);
%     disp('CO2 OFF');
%     pause(5);
end
    
    
    
end

