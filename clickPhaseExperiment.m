function clickPhaseExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./clickPhaseExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];
%%

daqSetup();
sampleRate = inputSampleRate;

Fo = 200;
nPhases = 8;
toneAmp = .55*10^-2;

stepAmp = 1;
cyclesBetween = 20;
trialLength = 20;   % Sec
nTrials = 6;

for trialN = 1:nTrials
    stepTimes = [];
    stepSamples = [];
    stepDirections = [];
    stepPhases = [];
    nSamples = sampleRate*trialLength;
    stimulus = calibratedTone(toneAmp,Fo,trialLength,sampleRate);

    clickN = 2;
    sampleN = 1;
    stepPhase = 6;
    while (sampleN < (nSamples - 2*(sampleRate*cyclesBetween/Fo)))
        cycleStartT = clickN*(1/Fo)*cyclesBetween;
        phaseN = randi(nPhases);
        clickT = cycleStartT + phaseN/nPhases*(1/Fo);
        sampleN = round(clickT*sampleRate);
        stepTimes(end+1) = clickT;
        stepSamples(end+1) = sampleN;
        stepPhases(end+1) = phaseN;
        if (stepPhase == 1)
            stimulus(sampleN:end) = stimulus(sampleN:end) + stepAmp;
            stepDirections(end+1) = 1;
            stepPhase = 2;
        elseif (stepPhase == 2)
            stimulus(sampleN:end) = stimulus(sampleN:end) - stepAmp;
            stepDirections(end+1) = 2;
            stepPhase = 3;
        elseif (stepPhase == 3)
            stimulus(sampleN:end) = stimulus(sampleN:end) + 0;
            stepDirections(end+1) = 0;
            stepPhase = 4;
        elseif (stepPhase == 4)
            stimulus(sampleN:end) = stimulus(sampleN:end) - stepAmp;
            stepDirections(end+1) = -1;
            stepPhase = 5;
       elseif (stepPhase == 5)
            stimulus(sampleN:end) = stimulus(sampleN:end) + stepAmp;
            stepDirections(end+1) = -2;
            stepPhase = 6;
       elseif (stepPhase == 6)
            stimulus(sampleN:end) = stimulus(sampleN:end) + 0;
            stepDirections(end+1) = 0;
            stepPhase = 1;
        end
        clickN = clickN+1;
    end
        
    data = recLDV(stimulus);

    data.stepTimes = stepTimes;
    data.stepSamples = stepSamples;
    data.stepPhases = stepPhases;
    data.stepDirections = stepDirections;
    data.Fo = Fo;
    data.nPhases = nPhases;
    data.cyclesBetween = cyclesBetween;
    data.trialLength = trialLength;
  
    save([baseName,num2str(trialN),'.mat'],'data');
    trialN
    clear('data');
end






