% Mixing 2 tones at varying amplitudes
function mix2Experiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./mix2Experiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];

daqSetup();
sampleRate = inputSampleRate;

Fo = 200;
f1 = 5;
f2 = 9;
stimAmps1 = [0,...
            1*10^-3,2*10^-3,5*10^-3,...
            1*10^-2,2*10^-2,5*10^-2,...
            1*10^-1]; 
stimAmps2 = [0,...
            1*10^-3,2*10^-3,5*10^-3,...
            1*10^-2,2*10^-2,5*10^-2,...
            1*10^-1]; 
nReps = 1;
    toneLength = 5;
    preStim     = 2;
    postStim    = 3;
    trialLength = preStim+toneLength+postStim;
    riseTime = .050;  % sec

stimAmpList = [];
[stim1,stim2] = meshgrid(stimAmps1,stimAmps2);
uniqueStims = [stim1(:),stim2(:)];
allStims = [];
for repN = 1:nReps
    randOrder = randperm(size(uniqueStims,1));
    allStims = [allStims;uniqueStims(randOrder,:)];
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

for trialN = 1:size(allStims,1)
    % Do the trials here
    stimAmp1 = allStims(trialN,1)
    stimAmp2 = allStims(trialN,2)
    calTone1 = calibratedTone(stimAmp1,f1*Fo,trialLength,sampleRate);
    calTone2 = calibratedTone(stimAmp2,f2*Fo,trialLength,sampleRate);

    stimulus = amplitudeEnvelope.*(calTone1 + calTone2);
   data = recLDV(stimulus);

   data.Fo = Fo;
   data.f1 = f1;
   data.f2 = f2;
   data.stimAmp1 = stimAmp1;
   data.stimAmp2 = stimAmp2;
   data.stimAmps1 = stimAmps1;
   data.stimAmps2 = stimAmps2;

   save([baseName,num2str(trialN),'.mat'],'data');
   trialN
   clear('data');
end


    
        
        