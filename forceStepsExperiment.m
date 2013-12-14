function forceStepsExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./forceStepsExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];

%%

daqSetup();
sampleRate = inputSampleRate;

powerRange = [-1.5, .5];   % In log10 amplitude
nPowers    = 24;
stepLength = .005;     % sec
stepPostLength = .015; % sec
nTrials = 1;
trialLength = 20;      % sec

stepAmps = logspace(powerRange(1),powerRange(2), floor(nPowers/2));
stepAmps = [-fliplr(stepAmps),stepAmps];
nPowers = length(stepAmps);
nSteps = floor(trialLength ./ (stepLength + stepPostLength)) - 1;


for trialN=1:nTrials
    
    time = [0:(trialLength*sampleRate)]./sampleRate;
    stimulus = zeros(round(stepPostLength*sampleRate),1);
    startSamples = [];
    stopSamples  = [];
    powerNs      = [];
    
    for stepN = 1:nSteps
        
        powerN = randi(nPowers);
        power = stepAmps(powerN);
        startSamples(end+1) = length(stimulus) + 1;
        stimulus = [stimulus; power*ones(round(stepLength*sampleRate),1)];
        stopSamples(end+1) = length(stimulus);
        powerNs(end+1) = powerN;
        stimulus = [stimulus;zeros(round(stepPostLength*sampleRate),1)];  
        
    end
    
    data = recLDV(stimulus);
    data.powers = stepAmps;
    data.startSamples = startSamples;
    data.stopSamples  = stopSamples;
    data.powerNs = powerNs;
    
    save([baseName,num2str(trialN),'.mat'],'data'); 
    
%     disp('CO2 ON');
%     pause(30);
%     disp('CO2 OFF');
%     pause(10);
end
