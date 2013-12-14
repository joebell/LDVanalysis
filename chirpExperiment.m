function chirpExperiment(expNum)

%% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./chirpExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];
%%

daqSetup();
sampleRate = inputSampleRate;

chirpRange = [100,1500]; % Hz
chirpLength = .650;
ISI = .100;
nChirps = 25;
logChirp = 'linear'; % 'logarithmic' or 'linear'
chirpAmp = 1; % log10

time = 0:(1/sampleRate):chirpLength;
oneChirp = chirp(time,chirpRange(1),time(end),chirpRange(2),logChirp);
betweenChirps = zeros(1,round(ISI*sampleRate));

stimulus = betweenChirps;
for chirpN = 1:nChirps
    stimulus = [stimulus,(10^chirpAmp)*oneChirp,betweenChirps];
end    

data = recLDV(stimulus');
data.chirpRange = chirpRange;
data.chirpLength = chirpLength;
data.ISI = ISI;
data.nChirps = nChirps;
data.logChirp = logChirp;
data.chirpAmp = chirpAmp;
save([baseName,num2str(1),'.mat'],'data'); 

velSpectrum(data,pretty(randi(7)));
