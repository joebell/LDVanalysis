function blurred = blurImage(out,nPixels)

    blurred = out;

    rSize = size(out.mean,1);
    cSize = size(out.mean,2);
    blurRange = 4; % # of SD's to blur out to.
    
    x = round(-blurRange*nPixels):round(blurRange*nPixels);
    ampEnv = exp(-(x.^2)./(2*nPixels));
    
    for rN = 1:rSize
        rN
        for cN = 1:cSize
            
            rRange = round(rN-blurRange*nPixels):round(rN+blurRange*nPixels);
            cRange = round(cN-blurRange*nPixels):round(cN+blurRange*nPixels);
            ix = find((rRange < 1) | (rRange > rSize));
            rRange(ix) = [];
            ix = find((cRange < 1) | (cRange > cSize));
            cRange(ix) = [];
            rDiff = rRange - rN;
            cDiff = cRange - cN;
            
            pixVals = out.mean(rRange,cRange);
            pixAmps = exp(-(rDiff'.^2)./(2*nPixels))*exp(-(cDiff.^2)./(2*nPixels));
                        
            scaledPix = pixVals.*pixAmps;
            ix = isnan(scaledPix);
            scaledPix(ix) = [];
            pixAmps(ix) = [];

            blurred.mean(rN,cN) = nansum(scaledPix(:))/nansum(pixAmps(:));
            blurred.N(rN,cN) = length(scaledPix(:));
        end
    end
    
            
            
            
            