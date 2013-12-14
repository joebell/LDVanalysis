function analyzeAmplitudeSweeps(dataList)

for n=1:length(dataList)
    
    
    data = dataList{n};
%    figure();
%    load([baseName,num2str(n),'.mat']);
        
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
        
    subplot(2,1,1);  % (pretty(2*n - 1) + 3.*[1 1 1])./4
    loglog(sAmps,vAmps,'Color',(pretty(n) + 0.*[1 1 1])./1); hold on;
%     semilogy(1:nBlocks,mAmps(1:nBlocks),'k'); hold on;
%     semilogy(1:nBlocks,mAmps(end:-1:(nBlocks+1)),'k'); hold on;
    loglog(sAmps,100*sAmps,'Color','k');
    xlabel('Stimulus power');
    ylabel(['Power @ ',num2str(Fo),' Hz  (nm / sqrt(Hz))']);
    %ylim([.5 1000]);
    axis tight;
    
    subplot(2,1,2); 
    loglog(sAmps,vAmps./sAmps,'Color',(pretty(n) + 0.*[1 1 1])./1); hold on;
    
    xlabel('Stimulus power');
    ylabel(['Sensitivity @ ',num2str(Fo),' Hz']);
    %ylim([.1 100]);
    axis tight;
end

    