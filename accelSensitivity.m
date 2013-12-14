function accelSensitivity(baseName, Ns)

for n=Ns
    
    figure();
    load([baseName,num2str(n),'.mat']);
        
    accel = [diff(data.LDVvelocity);0].*data.sampleRate; % mm/sec

    
    Fo = data.Fo;    
    nBlocks = 50;
    mic = data.stimulus.*505;
    vAmps = [];
    mAmps = [];
    

    
    sampleInterval = floor(length(accel)./(2*nBlocks));
    for sSamp = 1:sampleInterval:(length(accel)-sampleInterval)
        
        input = accel(sSamp:(sSamp+sampleInterval-1));
        L = length(input); Fs = data.sampleRate;       
        NFFT = min([2^(nextpow2(L)),2^20]);
        chunkSize = 2^(nextpow2(L) - 3);
        overlap = .5;
        %[Pxx, freqs] = pwelch(input,chunkSize,round(overlap*chunkSize),NFFT,data.sampleRate);     
        Pxx = 2*abs(fft(input,NFFT)./L);
        freqs = data.sampleRate/2*linspace(0,1,NFFT/2+1)';
        ix = dsearchn(freqs,Fo);
        vAmps(end+1) = Pxx(ix); %sqrt(Pxx(ix));
        
        input = mic(sSamp:(sSamp+sampleInterval));
        L = length(input); Fs = data.sampleRate;
        NFFT = min([2^(nextpow2(L)),2^20]);
        chunkSize = 2^(nextpow2(L) - 3);
        overlap = .5;
        %[Pxx, freqs] = pwelch(input,chunkSize,round(overlap*chunkSize),NFFT,data.sampleRate);     
        Pxx = 2*abs(fft(input,NFFT)./L);
        freqs = data.sampleRate/2*linspace(0,1,NFFT/2+1)';
        ix = dsearchn(freqs,Fo);
        mAmps(end+1) = Pxx(ix); %sqrt(Pxx(ix));
    end
        
    subplot(2,1,1);
    semilogy(vAmps(1:nBlocks),'b'); hold on;
    semilogy(vAmps(end:-1:(nBlocks+1)),'c'); hold on;
    semilogy(mAmps(1:nBlocks),'r'); hold on;
    semilogy(mAmps(end:-1:(nBlocks+1)),'m'); hold on;
    
    xlabel('Time window');
    ylabel(['Power @ ',num2str(Fo),' Hz  (nm / sqrt(Hz))']);
    %ylim([.5 1000]);
    
    subplot(2,1,2);
    semilogy(vAmps(1:nBlocks)./mAmps(1:nBlocks),'b'); hold on;
    semilogy(vAmps(end:-1:(nBlocks+1))./mAmps(end:-1:(nBlocks+1)),'c');
    
    xlabel('Time window');
    ylabel(['Sensitivity @ ',num2str(Fo),' Hz']);
    %ylim([.1 100]);
end

    