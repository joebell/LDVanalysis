function harmonicPhaseExperiment(expNum)

% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./harmonicPhaseExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];

%%
    prepSimulation = false; %
    stimAmp    = 1*10^-2;

    daqSetup();
    sampleRate = inputSampleRate;
    Fo         = 200;
    f1         = 2;
    f2         = 3;

    phases     = [0:11]*(2*pi)/12;

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

% Record baseline
    stimN = 0;
    stimulus = amplitudeEnvelope*0;
    if ~prepSimulation
        data = recLDV(stimulus);
        data.Fo = Fo;
        data.f1 = f1;
        data.f2 = f2;
        data.amplitude = stimAmp;
        data.phase = 0;
        save([baseName,num2str(stimN),'.mat'],'data');
    else
        simulationBatch(stimulus,stimN);
    end
    
% Record F1
    stimN = 1;
    calTone = calibratedTone(stimAmp,f1*Fo,trialLength,sampleRate);
    if ~prepSimulation
        stimulus = amplitudeEnvelope.*calTone;   
        data = recLDV(stimulus);
        data.Fo = Fo;
        data.f1 = f1;
        data.f2 = f2;
        data.amplitude = stimAmp;
        data.phase = 0;
        save([baseName,num2str(stimN),'.mat'],'data');
    else
        stimulus = amplitudeEnvelope.*calTone/max(calTone);
        simulationBatch(stimAmp*stimulus,stimN);
    end
    
% Record F2
    stimN = 2;
    calTone = calibratedTone(stimAmp,f2*Fo,trialLength,sampleRate);
    if ~prepSimulation
        stimulus = amplitudeEnvelope.*calTone;
        data = recLDV(stimulus);
        data.Fo = Fo;
        data.f1 = f1;
        data.f2 = f2;
        data.amplitude = stimAmp;
        data.phase = 0;
        save([baseName,num2str(stimN),'.mat'],'data');
    else
        stimulus = amplitudeEnvelope.*calTone/max(calTone);
        simulationBatch(stimAmp*stimulus,stimN);
    end

for stimN = 1:length(phases)
       
    phase = phases(stimN);
    calTone1 = calibratedTone(stimAmp,f1*Fo,trialLength,sampleRate);
    calTone2 = calibratedTone(stimAmp,f2*Fo,trialLength,sampleRate,phase);
    
    if ~prepSimulation
        stimulus = amplitudeEnvelope.*(calTone1 + calTone2);
        data = recLDV(stimulus);

        data.Fo = Fo;
        data.f1 = f1;
        data.f2 = f2;
        data.amplitude = stimAmp;
        data.phase = phase;
        save([baseName,num2str(stimN+2),'.mat'],'data');

        clear('data');
    else
        stimulus = amplitudeEnvelope.*(calTone1./max(calTone1)+calTone2./max(calTone2));
        simulationBatch(stimAmp*stimulus,stimN+2);
    end
end
    
