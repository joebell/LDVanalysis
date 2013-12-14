function spectrum(input, sampleRate,plotColor,varargin)

    if nargin > 3
        input = decimate(input,varargin{1});
        sampleRate = sampleRate/varargin{1};
    end

    L = length(input);
    NFFT = 2^nextpow2(L);
    chunkSize = 2^(nextpow2(L) - 3);
    overlap = .5;
    
    [Pxx, f] = pwelch(input,chunkSize,round(overlap*chunkSize),NFFT,sampleRate);  
    loglog(f,sqrt(Pxx),'Color',plotColor); hold on;
    xlim([50 2500]);
    xlabel('Freq. (Hz)'); ylabel('PSD (units/root Hz)');

%     input = decimate(input,5);
%     sampleRate = sampleRate/5;
%     
%     L = length(input); Fs = sampleRate;
%     NFFT = 2^nextpow2(L);
%     Y = fft(input,NFFT)/L;
%     freqs = Fs/2*linspace(0,1,NFFT/2+1);
%     ampl = 2*abs(Y(1:NFFT/2+1));
%     semilogx(freqs,ampl,'Color',plotColor); hold on;
%     xlabel('Freq.');
%     ylabel('Power');
%     xlim([50 2500]);