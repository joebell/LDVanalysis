function Z = linearResponseFunction(data)

    forceCoeff = 450*2;
    Fs = data.sampleRate;
    stimLag = 21; % Samples
        
for fN = 1:length(data.Fo)
    
    velSnip = data.LDVvelocity((data.startSamples(fN):data.stopSamples(fN))+stimLag);
    velSnip = velSnip - mean(velSnip);
    posSnip = cumsum(velSnip)./data.sampleRate*10^-3; % Convert to m
    stimSnip = data.stimulus((data.startSamples(fN):data.stopSamples(fN)));
        
%     figure;
%     plot(posSnip./rms(posSnip),'b'); hold on;
%     plot(stimSnip./rms(stimSnip),'g');
    
    
    L = length(posSnip);
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    posW = fft(posSnip,NFFT)/L;
    stimW = fft(stimSnip,NFFT)/L;
    posW = posW(NFFT/2+1:end);
    stimW = stimW(NFFT/2+1:end);
    f = Fs/2*linspace(1,0,NFFT/2+1);
    
    fix = dsearchn(f',data.Fo(fN));
    
    Z(fN) = posW(fix)/stimW(fix);
end

%     semilogx(data.Fo,real(Z),'b'); hold on;
%     semilogx(data.Fo,imag(Z),'g');
    Z = Z./(forceCoeff/1000*5*10^-12); % Convert to m/N
    return;