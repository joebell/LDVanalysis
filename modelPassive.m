function model = modelPassive()

    posRange = [-.75,.75]*10^-3; % mm
    velRange = [-1, 1];          % mm/sec
    nBins = 64;
     
    binEdges = linspace(posRange(1), posRange(2), nBins + 1);
    binL = binEdges(1:end-1);
    binR = binEdges(2:end);
    model.posBins = (binL + binR)/2;
    binEdges = linspace(velRange(1), velRange(2), nBins + 1);
    binL = binEdges(1:end-1);
    binR = binEdges(2:end);
    model.velBins = (binL + binR)/2;
    
    for posN = 1:nBins
        for velN = 1:nBins
            model.mean(velN,posN) = -1000*model.posBins(posN)/max(model.posBins(:)) + ...
                -200*model.velBins(velN)/max(model.velBins(:));
        end
    end
                