% Poisson noise repeat experiment
function poissonNoiseRepeatExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./poissonNoiseRepeatExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];
%%
prepSimulation = false; %

daqSetup();
sampleRate = inputSampleRate;
scale = 1;
probPerSec = 100;
stimAmp = 2*10^(scale-1);
trialLength = 11;
waitTime = 10;
nReps = 200;

for n=1:nReps
    
    stim = poissonSteps(trialLength,probPerSec,sampleRate);
    
    if ~prepSimulation
        fileList = dir([baseName,'*.mat']);
        fileN = size(fileList,1) + 1;
        data = recLDV(stimAmp.*stim); 
        save([baseName,num2str(fileN),'.mat'],'data');    
        clear('data');
        disp(['Wrote rep #',num2str(fileN)]);
        pause(waitTime);
    else
        simulationBatch(stimAmp.*stim,n);
    end
end
    
