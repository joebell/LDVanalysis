% Poisson noise experiment
function poissonNoiseExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./poissonNoiseExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];
%%
prepSimulation = false; %

daqSetup();
sampleRate = inputSampleRate
scale = 1;
probPerSec = 100;
stimAmps = .5*[0,10^(scale-1),2*10^(scale-1),5*10^(scale-1),10^scale];
%stimAmps = 5;
%stimAmps = [0,10^(scale-1),2*10^(scale-1)];
stimAmps = [0];

trialLength = 20;

for n=1:length(stimAmps)
%for n=1:length(stimAmps)
    
    stimAmp = stimAmps(n);
    stim = poissonSteps(trialLength,probPerSec,sampleRate);
    popWidth = 5;
    %stim = poissonPops(trialLength,probPerSec,sampleRate,popWidth);
    
    if ~prepSimulation
        data = recLDV(stimAmp.*stim); 
        save([baseName,num2str(n),'.mat'],'data');    
        clear('data');
    else
        simulationBatch(stimAmp.*stim,n);
    end
    
    %pause(20);
end
    
