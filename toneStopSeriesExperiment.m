function toneStopSeriesExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./toneStopSeriesExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];

daqSetup();
sampleRate = inputSampleRate;

nTrials = 1;
stimFreq = 800;
minAmp =  -3;
maxAmp =  .8;
toneLength = .030;
stopLength = .010;
nPhases = 8;
nTotal  = 512;
nPowers = nTotal/nPhases;
phaseSeries = linspace(0, 2*pi, nPhases + 1); phaseSeries(end) = [];
powerSeries = linspace(minAmp,maxAmp,nPowers);


for trialN=1:nTrials
    
    stimulus = 0;
    stopSamples = [];
    
    for power = powerSeries    
        for phase = phaseSeries

            segLength = toneLength + (phase/(2*pi))*(1/stimFreq);
            segment = 10^(power).*[sin(2*pi*stimFreq*[0:(1/sampleRate):segLength])];
            stimulus = [stimulus,segment];
            
            stopSamples(end+1) = length(stimulus);
            stimulus = [stimulus, zeros(stopLength.*sampleRate,1)'];                     
        end
    end
    
    data = recLDV(stimulus');
    data.stopSamples = stopSamples;
    data.Fo = stimFreq;
    
    save([baseName,num2str(trialN),'.mat'],'data'); 
    
    disp('CO2 ON');
    pause(30);
    disp('CO2 OFF');
    pause(10);
end
    
    
    
end

