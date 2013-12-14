function harmonicMixingExperiment(expNum,stimAmp,addedNoise)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./harmonicMixingExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];

prepSimulation = false; %
%stimAmp    =  10;
%addedNoise =  0;
noiseFiltOrder = .5;

daqSetup();
sampleRate = inputSampleRate;
Fo         = 200;
maxHarm    = 7;


toneLength = 5;
preStim     = 2;
postStim    = 3;
trialLength = preStim+toneLength+postStim;
riseTime = .050;  % sec

% Generate amplitude envelope
rtVector = (1/sampleRate):(1/sampleRate):riseTime;
riseEnvelope = (.5*(1-cos(pi*rtVector/riseTime)))';
amplitudeEnvelope = zeros(round(preStim*sampleRate),1);
amplitudeEnvelope = cat(1,amplitudeEnvelope,riseEnvelope);
plateau = ones(round((toneLength - 2*riseTime)*sampleRate),1);
amplitudeEnvelope = cat(1,amplitudeEnvelope,plateau);
amplitudeEnvelope = cat(1,amplitudeEnvelope,flipud(riseEnvelope));
postStim = zeros(round(postStim*sampleRate),1);
amplitudeEnvelope = cat(1,amplitudeEnvelope,postStim);

% Generate combinations of harmonics
harms = [0:maxHarm];
stimulusSet = [];
for n=1:maxHarm+1
    f1 = harms(n);
    if n < (maxHarm+1)
        for m=(n+1):(maxHarm+1)
            f2 = harms(m);
            stimulusSet(end+1,:) = [f1,f2];
        end
    end
end

    stimN = 0;
    stimulus = amplitudeEnvelope*0;
    stimulus = stimulus + addedNoise.*filteredNoise(trialLength,sampleRate,noiseFiltOrder,50);
    if ~prepSimulation
        data = recLDV(stimulus);
        data.Fo = Fo;
        data.f1 = f1;
        data.f2 = f2;
        data.amplitude = stimAmp;
        save([baseName,num2str(stimN),'.mat'],'data');
    else
        simulationBatch(stimulus,stimN,stimAmp,addedNoise);
    end



for stimN = 1:length(stimulusSet)
    
    f1  = stimulusSet(stimN,1);
    f2  = stimulusSet(stimN,2);
    
    disp(['f1: ',num2str(f1),' f2: ',num2str(f2)]);
    
    if ~prepSimulation
        stimulus = amplitudeEnvelope.*calibratedTone(stimAmp,f2*Fo,trialLength,sampleRate);
        if (f1 > 0)
            stimulus = stimulus + ...
              amplitudeEnvelope.*calibratedTone(stimAmp,f1*Fo,trialLength,sampleRate);
        end
        stimulus = stimulus + addedNoise.*filteredNoise(trialLength,sampleRate,noiseFiltOrder,50);
        data = recLDV(stimulus);

        data.Fo = Fo;
        data.f1 = f1;
        data.f2 = f2;
        data.amplitude = stimAmp;
        save([baseName,num2str(stimN),'.mat'],'data');

        clear('data');
    else
        calTone = calibratedTone(stimAmp,f2*Fo,trialLength,sampleRate);
        stimulus = amplitudeEnvelope.*calTone./max(calTone);
        if (f1 > 0)
            calTone = calibratedTone(stimAmp,f1*Fo,trialLength,sampleRate); 
            stimulus = stimulus + ...
              amplitudeEnvelope.*calTone./max(calTone);
        end
        stimulus = stimAmp.*stimulus + addedNoise.*filteredNoise(trialLength,sampleRate,noiseFiltOrder,50);
        simulationBatch(stimulus,stimN,stimAmp,addedNoise);
    end
end
    
