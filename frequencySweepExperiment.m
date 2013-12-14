% Freq Sweep experiment
function frequencySweepExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./frequencySweepExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];
%%

prepSimulation = false; %
powerScale = 1;  

daqSetup();
sampleRate = inputSampleRate;
stimFreqRange = [50,1500];
stimPowers = [1]; % in log10
trialLength = 20;

 

for n=1:length(stimPowers)
    
    time = [0:(trialLength*sampleRate)]./sampleRate;    
    sweep = 10^(stimPowers(n)).*chirp(time,stimFreqRange(1),time(end),stimFreqRange(2),'logarithmic');

    stimulus = [sweep];
    
%     NFFT = 2^(nextpow2(length(stimulus))-10);
%     spectrogram(stimulus,2^12,2^11,NFFT,sampleRate);
%     return;
    
    if ~prepSimulation

        data = recLDV(stimulus');
        save([baseName,num2str(n),'.mat'],'data'); 
        clear('data');
    else
        simulationBatch(stimulus,n);
    end
    
%     disp('CO2 ON');
%     pause(30);
%     disp('CO2 OFF');
%     pause(10);
end


