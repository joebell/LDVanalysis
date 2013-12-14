function impulses = impulseStimuli(length, impulsePeriod, impulseLength, sampleRate)

    iPerSamp = round(impulsePeriod*sampleRate);
    iLenSamp = round(impulseLength*sampleRate);
    
    nSamples = round(length*sampleRate);
    impulses = zeros(nSamples,1);
    
    for sampleN = iPerSamp:iPerSamp:(nSamples - iPerSamp)
        oneAmp = (rand()*2-1);
        impulses(sampleN:(sampleN+iLenSamp)) = oneAmp;
    end