function out = gaussConv(sig, width, sampleRate)

    out = conv(sig,makeGaussian(0,width,-6*width:(1/sampleRate):6*width));
    