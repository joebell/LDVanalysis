function powers = analyzeFreqPips(data)

for Fn = 1:length(data.Fo)
    
    snip = data.LDVvelocity(data.fullStartSamples(Fn):data.fullStopSamples(Fn));
    
    NFFT = 2^(nextpow2(length(snip)));
    Pxx = 2*abs(fft(snip,NFFT)./length(snip));
    freqs = data.sampleRate/2*linspace(0,1,NFFT/2+1)';
    ix = dsearchn(freqs,data.Fo(Fn));
    
    powers(Fn) = Pxx(ix);
    
end

