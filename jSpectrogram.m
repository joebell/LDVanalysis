function jSpectrogram(timeSeries,sampleRate)



NFFT = 2^(nextpow2(length(timeSeries))-10);
[S,F,T] = spectrogram(timeSeries,2^12,2^11,NFFT,sampleRate);

image(T,F,(abs(S)),'CDataMapping','scaled');
set(gca,'YDir','normal');
ylim([20 2000]);