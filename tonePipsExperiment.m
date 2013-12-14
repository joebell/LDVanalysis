function tonePipsExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./tonePipsExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];

daqSetup();
sampleRate = inputSampleRate;

nTrials = 1;
stimFreq = 180;
pipAmp = .3;

toneLength = .030;
stopLength = .015;
nTotal  = 512;

for trialN=1:nTrials
    
    stimulus = 0;
    startSamples = [];
    stopSamples = [];
    
    for pipN = 1:nTotal

            segLength = toneLength;
            segment = 10^(pipAmp).*[sin(2*pi*stimFreq*[0:(1/sampleRate):segLength])];
            startSamples(end+1) = length(stimulus);
            stimulus = [stimulus,segment];            
            stopSamples(end+1) = length(stimulus);
            stimulus = [stimulus, zeros(stopLength.*sampleRate,1)'];                     
    end
    
    data = recLDV(stimulus');
    data.startSamples = startSamples;
    data.stopSamples = stopSamples;
    data.Fo = stimFreq;
    
    save([baseName,num2str(trialN),'.mat'],'data'); 
    
%     disp('CO2 ON');
%     pause(30);
%     disp('CO2 OFF');
%     pause(10);
end
    
    
    
end

