% Mixing 1 tones at varying amplitudes
function amplitudeExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./amplitudeExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];

daqSetup();
sampleRate = inputSampleRate;

Fo = 400;
stimAmps = [0,1*10^-4,2*10^-4,5*10^-4,...
    1*10^-3,2*10^-3,5*10^-3,...
    1*10^-2,2*10^-2,5*10^-2,...
    10^-1];
 
nReps = 5;
    toneLength = 5;
    preStim     = 2;
    postStim    = 3;
    trialLength = preStim+toneLength+postStim;
    riseTime = .050;  % sec

uniqueStims = stimAmps;
allStims = [];
for repN = 1:nReps
    randOrder = randperm(length(uniqueStims));
    allStims = [allStims,0,uniqueStims(randOrder)];
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
    stimAmp = allStims(trialN);
    calTone1 = calibratedTone(stimAmp,Fo,trialLength,sampleRate);

    stimulus = amplitudeEnvelope.*(calTone1);
    data = recLDV(stimulus);

    data.Fo = Fo;
    data.stimAmp = stimAmp;

   save([baseName,num2str(trialN),'.mat'],'data');
   trialN
   clear('data');
end


    
        
        