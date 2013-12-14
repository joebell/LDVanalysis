function fillHandle = joeArea(xVals, yBottom, yTop)

    xVals = xVals(:)';
    yBottom = yBottom(:)';
    yTop = yTop(:)';
    
    fullX = [xVals(1:end),xVals(end:-1:1)];
    fullY = [yBottom(1:end),yTop(end:-1:1)];
    fillHandle = fill(fullX,fullY,'r');