function out = fourierComponent(signal,freq,sampleRate)

    t = [1:length(signal)]./sampleRate;   
    out = sum(signal'.*exp(-2*pi*i.*t*freq))./length(t);