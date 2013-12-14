function phaseSpectrogram(data)

    % load('../Data/131029/LDV131029_14_3.mat');
    [pos,vel,accel] = filterAccel(data);
    time = [1:length(vel)]./data.sampleRate;

    window = round(data.sampleRate*.10);
    overlap = round(window/2);
    NFFT = 2^nextpow2(window);
    F = [10:10:800];
    [S,F,T] = spectrogram(pos,window,overlap,F,data.sampleRate);
    
    subplot(2,1,1);
    image(T,F,log10(abs(S)),'CDataMapping','scaled');
    set(gca,'YDir','normal');
    ylim([10 800]);caxis([-3 .7]);
    
    subplot(2,1,2);
    trans = log10(abs(S));
    trans = trans - min(trans(:));
    trans = trans./max(trans(:));
    image(T,F,angle(S),'CDataMapping','scaled');%,'AlphaData',trans);
    set(gca,'YDir','normal');
    ylim([10 800]);