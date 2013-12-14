% Filtered noise experiment
function filteredNoiseExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./filteredNoiseExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];
%%

prepSimulation = false; %

daqSetup();
sampleRate = inputSampleRate;
stimAmps = [0];
trialLength = 20;
filterOrder =  0;     % Use 0 (white),.5 (pink),1,2...
filterKnee  =  50;    % Hz

for n=1:length(stimAmps)
    
    stimAmp = stimAmps(n);
    stim = filteredNoise(trialLength,sampleRate,filterOrder,filterKnee);

%     L = length(stim);
%     NFFT = 2^(nextpow2(L)-8);
%     [Pxx, f] = pwelch(stim,2^12,2^11,NFFT,sampleRate);
%     loglog(f,Pxx,'Color','b'); hold on;
%     xlim([20 2500]);  
%     return;
    
    if ~prepSimulation
        data = recLDV((10^stimAmp).*stim);    
        save([baseName,num2str(n),'.mat'],'data');    
        clear('data');
    else
        simulationBatch(stimAmp.*stim,n);
    end
end
    
