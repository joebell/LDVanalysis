function binIdx = equiBin(sig1, nBins)

    oversample = 50;
    binTarget = size(sig1,1)/nBins;
    
    % Generate a cumulative PDF with oversampled equally spaced bins
    initialBins = linspace(min(sig1),max(sig1),nBins*oversample);
    [n, binIdx] = histc(sig1, initialBins);
    cumProb = cumsum(n);
    
    % plot(initialBins,n*oversample,'b'); hold on;

    binEdges(1) = min(sig1)-1;
    binEdges(nBins+1) = max(sig1)+1;
    for n = 2:nBins

        k = find(cumProb >= (n-1)*binTarget);
        binEdges(n) = initialBins(k(1));
    end

    [n,binIdx] = histc(sig1,binEdges);
    
    %plot(binEdges,n,'r');





