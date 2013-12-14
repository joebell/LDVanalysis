function [binIdx, binCenters] = evenBin(sig1, binMin, binMax, nBins)

    
    % Generate a cumulative PDF with oversampled equally spaced bins
    binEdges = linspace(binMin, binMax, nBins + 1);
    [n, binIdx] = histc(sig1, binEdges);
    
    ix = find((binIdx == 0) & (sig1 > mean(sig1)));
    binIdx(ix) = nBins;
    ix = find((binIdx == 0) & (sig1 < mean(sig1)));
    binIdx(ix) = 1;
    
    binL = binEdges(1:end-1);
    binR = binEdges(2:end);
    binCenters = (binL + binR)/2;
 





