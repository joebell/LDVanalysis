%% Nb, the FFT resolution isn't very good here.
function alternateAmplitudeSweeps(data, plotColor)

window = round(.395*data.sampleRate/2)*2;
[S,F,T] = spectrogram(data.LDVvelocity,window,window/2,2^17,data.sampleRate);
Fix = dsearchn(F,data.Fo);
respTrace = abs(S(Fix,:));

[S,F,T] = spectrogram(data.stimulus,window,window/2,2^17,data.sampleRate);
Fix = dsearchn(F,data.Fo);
stimTrace = abs(S(Fix,:));

loglog(stimTrace,respTrace,'Color',plotColor); hold on;
ylims = ylim();
xlims = xlim();
loglog(xlim(),[ylims(1) ylims(1)/xlims(1)*xlims(2)],'k-.');
