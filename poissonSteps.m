function out = poissonSteps(length,probPerSec,sampleRate)

    nSamples = round(length*sampleRate);
    probPerSample = probPerSec/sampleRate;
    
    out = zeros(nSamples,1);
    transitions = rand(nSamples,1);
    ix = find(transitions < probPerSample);
    
    for ixN = 1:(size(ix,1)-1)
        shelfAmp = rand()*2-1;
        out(ix(ixN):ix(ixN+1)) = shelfAmp;       
    end
    
    