function out = filteredNoise(length, sampleRate, order, cornerFreq)

    whiteNoise = normrnd(0,1,round(length*sampleRate),1);
    h1 = fdesign.highpass('N,F3dB',8,20/(sampleRate/2));
    d1 = design(h1,'butter');
    whiteNoise = filter(d1,whiteNoise);       

    if order >= 1
        h1 = fdesign.lowpass('N,F3dB',order,cornerFreq/(sampleRate/2));
        d1 = design(h1,'butter');
        out = filter(d1,whiteNoise);
    elseif order == .5
        B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
        A = [1 -2.494956002   2.017265875  -0.522189400];
        out = 2.5*filter(B,A,whiteNoise);    % Apply 1/F roll-off to PSD
    elseif order < .5
        out = whiteNoise;
    end
    