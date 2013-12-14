function out = pinkNoise(nSamples)
 
 
    whiteNoise = normrnd(0,1, [nSamples*2,1]);
    
    B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
    A = [1 -2.494956002   2.017265875  -0.522189400];
    pinkNoise = filter(B,A,whiteNoise);    % Apply 1/F roll-off to PSD
    
    out = pinkNoise(round(nSamples/2):(round(nSamples/2)+nSamples-1));