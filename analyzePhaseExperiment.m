function analyzePhaseExperiment()

baseName = '../Data/130320/LDV130320_19_';

load([baseName,'0.mat']);
Fo = 200;

phases     = [0:11]*(2*pi)/12;
multiples = [160/Fo,1,2,3,4,5,6,7];
allData = zeros(15,length(multiples));

for n=0:14
    n
    load([baseName,num2str(n),'.mat']);
    
    input = decimate(data.LDVvelocity,10);
    sampleRate = data.sampleRate/10;    
    L = length(input); Fs = sampleRate;
    NFFT = 2^nextpow2(L);
    Y = fft(input,NFFT)/L;
    freqs = Fs/2*linspace(0,1,NFFT/2+1);
    amplitudes = 2*abs(Y(1:NFFT/2+1));
    
    for m=1:length(multiples)
        
        freq = multiples(m)*Fo;
        ix = dsearchn(freqs',freq);
        amp = amplitudes(ix);        
        allData(n+1,m) = amp;       
    end
end

for m = 1:length(multiples)
    subplot(length(multiples),1,m);
    plot(1:3,allData(1:3,m),'o'); 
    hold on;
    plot(4:size(allData,1),allData(4:end,m),'o-'); 
    ylabel(['P @ ',num2str(multiples(m)),'Fo']);
    set(gca,'XTick',[]);
end

plotPhases(data.f1,data.f2,phases);

    