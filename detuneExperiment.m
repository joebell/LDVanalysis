% Mixing 2 tones at varying amplitudes
function detuneExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./detuneExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];

daqSetup();
sampleRate = inputSampleRate;

Fo = 400;
f1 = 2;
f2 = 3;
stimAmp = 1*10^-2;
% f2detunes = [-50,-25,-15,-10,-5,0,5,10,15,25,50]; % Hz
f2detunes = [-20,-10, -5, -2, -1, 0, 1, 2, 5, 10, 20]; % Hz
 
nReps = 1;
    toneLength = 5;
    preStim     = 2;
    postStim    = 3;
    trialLength = preStim+toneLength+postStim;
    riseTime = .050;  % sec

uniqueStims = f2detunes;
allStims = [];
for repN = 1:nReps
    randOrder = randperm(length(uniqueStims));
    allStims = [allStims,uniqueStims(randOrder)];
end


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

for trialN = 1:length(allStims)
    % Do the trials here
    f2detune = allStims(trialN)
    calTone1 = calibratedTone(stimAmp,f1*Fo,trialLength,sampleRate);
    calTone2 = calibratedTone(stimAmp,f2*Fo + f2detune,trialLength,sampleRate);

    stimulus = amplitudeEnvelope.*(calTone1 + calTone2);
    data = recLDV(stimulus);

    data.Fo = Fo;
    data.f1 = f1;
    data.f2 = f2;
    data.stimAmp = stimAmp;
    data.f2detune = f2detune;
    data.f2detunes = f2detunes; 

   save([baseName,num2str(trialN),'.mat'],'data');
   trialN
   clear('data');
end


    
        
        