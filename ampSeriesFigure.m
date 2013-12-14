function ampSeriesFigure(data)

rawData = data;
middleFract = .35;
divVector = [0,.5-middleFract/2,.5+middleFract/2,1];

subplot(1,2,1);

    data.LDVvelocity = data.LDVvelocity - mean(data.LDVvelocity);
    data.LDVposition = cumsum(data.LDVvelocity)./data.sampleRate;
    % Convert to nm
    data.LDVposition = data.LDVposition*10^6;
    % Convert to um/sec
    data.LDVvelocity = data.LDVvelocity*10^3;
    
    Fo = 1*data.Fo; timeLength = length(data.LDVposition)/data.sampleRate;   
    nCyclesPerDiv = round(Fo*timeLength/100);   
    sampleSize = round(nCyclesPerDiv*(1/Fo)*data.sampleRate);
    overlap = 1;
    %mic = data.mic*10^6;  
    mic = data.stimulus*10^2;
    vAmps = [];
    mAmps = [];
    sAmps = [];
    

    
    sampleShift = round(sampleSize*overlap);
    for sSamp = 1:sampleShift:(length(data.LDVposition)-sampleSize)
        
        input = data.LDVposition(sSamp:(sSamp+sampleSize-1));
        inputStim = data.stimulus(sSamp:(sSamp+sampleSize-1));
        L = length(input); Fs = data.sampleRate;       
        NFFT = 2^(nextpow2(L));
        chunkSize = 2^(nextpow2(L) - 3);
        overlap = .5;
        %[Pxx, freqs] = pwelch(input,chunkSize,round(overlap*chunkSize),NFFT,data.sampleRate);     
        Pxx = 2*abs(fft(input,NFFT)./L);
        PxxStim = 2*abs(fft(inputStim,NFFT)./L);
        freqs = data.sampleRate/2*linspace(0,1,NFFT/2+1)';
        ix = dsearchn(freqs,Fo);
        vAmps(end+1) = (Pxx(ix)); %sqrt(Pxx(ix));
        sAmps(end+1) = (PxxStim(ix));
        
%         input = mic(sSamp:(sSamp+sampleInterval));
%         L = length(input); Fs = data.sampleRate;
%         NFFT = min([2^(nextpow2(L)),2^20]);
%         chunkSize = 2^(nextpow2(L) - 3);
%         overlap = .5;
%         %[Pxx, freqs] = pwelch(input,chunkSize,round(overlap*chunkSize),NFFT,data.sampleRate);     
%         Pxx = 2*abs(fft(input,NFFT)./L);
%         freqs = data.sampleRate/2*linspace(0,1,NFFT/2+1)';
%         ix = dsearchn(freqs,Fo);
%         mAmps(end+1) = Pxx(ix); %sqrt(Pxx(ix));
    end
    
    divVector = [0,.5-middleFract/2,.5+middleFract/2,1];
    divVector = round(divVector*length(vAmps));
    divVector(1) = 1;
    firstPart = [divVector(1):divVector(2),divVector(3):divVector(4)];
    middlePart = [divVector(2):divVector(3)];
    loglog(sAmps(firstPart),vAmps(firstPart),'Color','b'); hold on;
    loglog(sAmps(middlePart),vAmps(middlePart),'Color','m'); hold on;
%     semilogy(1:nBlocks,mAmps(1:nBlocks),'k'); hold on;
%     semilogy(1:nBlocks,mAmps(end:-1:(nBlocks+1)),'k'); hold on;
    loglog(sAmps,100*sAmps,'Color','k');
    xlabel('Stimulus power');
    ylabel(['Power @ ',num2str(Fo),' Hz  (nm / sqrt(Hz))']);
    %ylim([.5 1000]);
    axis tight;





divVector = [0,.5-middleFract/2,.5+middleFract/2,1];

data1 = rawData;
data2 = rawData;

Tlength = length(data.LDVvelocity);
divVector = round(divVector*Tlength);
divVector(1) = 1;

data1.LDVvelocity = [data.LDVvelocity(divVector(1):divVector(2));...
                     data.LDVvelocity(divVector(3):divVector(4))];
data2.LDVvelocity = [data.LDVvelocity(divVector(2):divVector(3))];

subplot(1,2,2);
velSpectrum(data2,'m');
velSpectrum(data1,'b');

set(gcf,'Position',[313,719,678,203]);