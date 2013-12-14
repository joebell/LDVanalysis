function toneAmpSweepExperiment(expNum,n)

% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./toneAmpSweepExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];

fFreqShifts = 20; % Hz
fAmpShifts  = 20; % Hz
freqExpRange   = [-1.3 0.2];  % 10^n Hz
ampExpRange    = [-1.8 .5];

daqSetup();
sampleRate = inputSampleRate;
trialLength = 20;

changeFreq = rand(sampleRate*trialLength,1);
changeAmp  = rand(sampleRate*trialLength,1);
fIx = find(changeFreq < fFreqShifts/sampleRate);
aIx = find(changeAmp  < fAmpShifts/sampleRate);
frequency = 100*ones(sampleRate*trialLength,1);
amplitude = .01*ones(sampleRate*trialLength,1);

for fIxN = 1:(length(fIx)-1)
    stIx = fIx(fIxN);
    enIx = fIx(fIxN+1);
    stFreqExp = log10(frequency(stIx));
    enFreqExp = freqExpRange(1) + (freqExpRange(2)-freqExpRange(1))*rand();
    frequency(stIx:enIx) = logspace(stFreqExp,enFreqExp,enIx-stIx+1);
end

for aIxN = 1:(length(aIx)-1)
    stIx = aIx(aIxN);
    enIx = aIx(aIxN+1);
    stAmpExp = log10(amplitude(stIx));
    enAmpExp = ampExpRange(1) + (ampExpRange(2)-ampExpRange(1))*rand();
    amplitude(stIx:enIx) = logspace(stAmpExp,enAmpExp,enIx-stIx+1);
end



        t = (1:length(amplitude))'./sampleRate;
        stimulus = amplitude.*sin(2.*pi.*frequency.*t);
        
subplot(2,1,1);
semilogy(t,amplitude);
subplot(2,1,2);
semilogy(t,frequency);

        data = recLDV(stimulus);
        save([baseName,num2str(n),'.mat'],'data');    
        clear('data');
