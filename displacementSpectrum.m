function displacementSpectrum(varargin)

    data = varargin{1};
    if nargin == 2
        plotColor = varargin{2};
    else
        plotColor = 'b';
    end
    
    % Filter at 5 kHz
    %h=fdesign.lowpass('N,F3dB',8,5000/(data.sampleRate/2));
    %d1 = design(h,'butter');
    %data.LDVvelocity = filtfilt(d1.sosMatrix,d1.ScaleValues,data.LDVvelocity);
    
    %data.LDVvoltage = (data.LDVvelocity./data.LDVgain)*10^3;
    
    
    data.LDVvelocity = data.LDVvelocity - mean(data.LDVvelocity);
    data.LDVposition = cumsum(data.LDVvelocity)./data.sampleRate;
    % Convert to nm
    data.LDVposition = data.LDVposition*10^6;
    % Convert to um/sec
    data.LDVvelocity = data.LDVvelocity*10^3;
    data.mic = data.mic*10^3;
    

    L = length(data.LDVposition);
    NFFT = min([2^(nextpow2(L)),2^20]);
    chunkSize = 2^(nextpow2(L) - 3);
    overlap = .5;
    
%     subplot(2,2,1);
%     [Pxx, f] = pwelch(data.LDVposition,chunkSize,round(overlap*chunkSize),NFFT,data.sampleRate);  
%     loglog(f,Pxx,plotColor); hold on;
%     xlim([20 2500]);
%     xlabel('Freq. (Hz)'); ylabel('PSD (nm^2/Hz)');
% %     
%     lineColor = [.9 .9 .9];
%     line(xlim(),[1 1],'Color',lineColor);
%     line([100 100],ylim(),'Color',lineColor);
%     line([2000 2000],ylim(),'Color',lineColor);
    
%    subplot(2,2,2);
%    [Pxx, f] = pwelch(data.LDVposition,chunkSize,round(overlap*chunkSize),NFFT,data.sampleRate);  
    Pxx = fft(data.LDVposition,NFFT)./L;
    f = data.sampleRate/2*linspace(0,1,NFFT/2+1);
    loglog(f,2*abs(Pxx(1:NFFT/2+1)),'Color',plotColor); hold on;
    xlim([20 2500]);
    lims = ylim();
    %ylim([max([lims(1),5*10^-3]),max([lims(2),10])]);
    xlabel('Freq. (Hz)'); 
    %ylabel('ASD (mV / \surd Hz)');
    ylabel('ASD (nm) / sqrt Hz)');
    
    lineColor = [.9 .9 .9];
    line([0 5000],[.02 .02],'Color',lineColor);
%    line([100 100],ylim(),'Color',lineColor);
%    line([2000 2000],ylim(),'Color',lineColor);
 
return;

    subplot(2,2,3);
    micPos = cumsum(data.mic)./data.sampleRate*10^3; % In nm
    [Pxx, f] = pwelch(data.mic,chunkSize,round(overlap*chunkSize),NFFT,data.sampleRate);  
    loglog(f,Pxx,plotColor); hold on;
    xlim([20 2500]);
    xlabel('Freq. (Hz)'); ylabel('PSD nm^2 / Hz');
    title('Mic');
    
    lineColor = [.9 .9 .9];
    line([100 100],ylim(),'Color',lineColor);
    line([2000 2000],ylim(),'Color',lineColor);
    
    subplot(2,2,4);
    [Pxx, f] = pwelch(data.mic,chunkSize,round(overlap*chunkSize),NFFT,data.sampleRate);  
    loglog(f,sqrt(Pxx),plotColor); hold on;
    xlim([20 2500]);
    xlabel('Freq. (Hz)'); ylabel('ASD (\mu m/sec) / \surd Hz)');
    
    lineColor = [.9 .9 .9];
    line([100 100],ylim(),'Color',lineColor);
    line([2000 2000],ylim(),'Color',lineColor);
    title('Mic');
    
    
    
    
    