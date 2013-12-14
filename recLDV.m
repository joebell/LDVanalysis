function data = recLDV(varargin)

    daqSetup();
    if nargin == 1
        stimulus = varargin{1};
    else
        stimulus = zeros(10*outputSampleRate,1);
    end
    
    LDVgain = 2/1; % (mm/s)/V
    micGain = (1/.267)/100; % (1/.267 (mm/s)/V) is BL sensitivity
    
    putdata(AO, stimulus);
    start([AI AO]);
    trigger([AI AO]);
    
    %% Wait for playback/recording to finish
    fprintf('     Recording.');
    totalSamples = length(stimulus)*overSample;
    nsampin = AI.SamplesAcquired;
    nsampout = AO.SamplesOutput;
    while (nsampin < totalSamples)
        nsampin = AI.SamplesAcquired;
        nsampout = AO.SamplesOutput;
        pause(.25);
        fprintf('.');
    end 
    disp('.');
    pause(.25);
    
    %% stop playback
    stop([AI AO]);
    disp('     Stopped recording.');
    disp(' ');
    dataStream = getdata(AI,totalSamples); 
    delete([AI AO]);
    clear AI AO;
    
    %plot([1:20000]./(inputSampleRate*overSample),dataStream(1:20000,2),'.-');
    
    data.LDVvelocity = decimate(dataStream(:,1).*LDVgain,overSample);
    data.mic = decimate(dataStream(:,2).*micGain,overSample);
    data.sampleRate = inputSampleRate;
    data.LDVgain = LDVgain;
    data.micGain = micGain;
    data.stimulus = stimulus;
    data.LDVposition = cumsum(data.LDVvelocity - mean(data.LDVvelocity))./data.sampleRate;
    
    
    
