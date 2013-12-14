% Amp Sweep experiment
function amplitudeSweepExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./amplitudeSweepExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];
%%

prepSimulation = false; %
powerScale = 1;  

daqSetup();
sampleRate = inputSampleRate;
%stimFreqs = [500,600,700,800];
%stimFreqs = [800,400,200,100];
%stimFreqs = logspace(log10(10),log10(1500),16);
%stimFreqs = 50*ones(20,1);
%stimFreqs = [790]
stimFreqs = [40,60,80,100,120,140,160];
trialLength = 20;
startPower = -2.5;    % In log10
%startPower = -1.5;    % In log10
endPower   =  1;    % in log10
 

for n=1:length(stimFreqs)
    
    time = [0:(trialLength*sampleRate)]./sampleRate;
    midSample = round(trialLength*sampleRate/2);
    
    sweepTime = trialLength/2;
    amplitude = 10.^(startPower + (endPower - startPower)*time/sweepTime);
    amplitude(midSample:end) = 10.^(endPower +(endPower - startPower)*(1 - time(midSample:end)/sweepTime));
    frequency = stimFreqs(n);
    
    stimulus = powerScale*amplitude.*sin(time.*(2*pi).*frequency);

    if ~prepSimulation

        data = recLDV(stimulus');
        data.Fo = frequency;
        save([baseName,num2str(n),'.mat'],'data'); 
        if ~prepSimulation
            analyzeAmplitudeSweeps({data});
        end
        clear('data');
    else
        simulationBatch(stimulus,n);
    end
%     
%     disp('CO2 ON');
%     pause(30);
%     disp('CO2 OFF');
%     pause(10);

end


