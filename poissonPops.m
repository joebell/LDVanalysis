function out = poissonPops(trialLength,probPerSec,sampleRate, popWidth)
    
    
    nSamples = round(trialLength*sampleRate);
    probPerSample = probPerSec/sampleRate;
    
    out = zeros(nSamples,1);
    transitions = rand(nSamples,1);
    ix = find(transitions < probPerSample);
    
    for ixN = 1:(size(ix,1)-1)
        shelfAmp = normrnd(0,1);
        if (ix(ixN) + popWidth - 1 <= length(out)) 
            out(ix(ixN):(ix(ixN) + popWidth - 1)) = shelfAmp; 
        else
            out(ix(ixN):end) = shelfAmp;
        end
    end
    
    out(end) = 0;