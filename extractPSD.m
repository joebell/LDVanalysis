function PSD = extractPSD(data, fList)

    data.LDVvelocity = data.LDVvelocity - mean(data.LDVvelocity);
    data.LDVposition = cumsum(data.LDVvelocity)./data.sampleRate;
    % Convert to m
    data.LDVposition = data.LDVposition*10^-3;
    
    posSeg = data.LDVposition;
    window = round(1*data.sampleRate);
    overlap = round(window*.5);
    [Pxx,f] = pwelch(posSeg,window,overlap,[],data.sampleRate);

    for fN = 1:length(fList)
        
        fix = dsearchn(f,fList(fN));
        PSD(fN) = Pxx(fix);
        
    end