function stim = calibratedTone(power,f,length,sampleRate,varargin)

    if (nargin > 4)
        phase = varargin{1};
    else
        phase = 0;
    end

    t = (1/sampleRate):(1/sampleRate):length;
    baseStim = sin(2*pi*f*t+phase);

    load('cal-4.mat');
    ix = dsearchn(calData(:,1),f);
    calFactor = calData(ix,3);

    stim = power*calFactor*baseStim';