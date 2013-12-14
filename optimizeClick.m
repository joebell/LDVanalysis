function optimizeClick()

daqSetup();

clickLength = .001;
meanClickRate = 50;
testLength    =  2;
clickPoint    = round(clickLength*outputSampleRate/2);
idealClick    = zeros(clickLength*outputSampleRate,1);
idealClick(clickPoint) = 1;
clickWaveform = idealClick;
zeroStep = .001;
fracStep = .01;
nChanges = 1;

testWaveform = clickWaveform;
lastErr = Inf;

for n = 1:1000
    
    LDVgain = 2/1; % (mm/s)/V
    micGain = (1/.267)/100; % (1/.267 (mm/s)/V) is BL sensitivity
    
    testRasterSP = rand(testLength*outputSampleRate,1);
    testRasterSN = rand(testLength*outputSampleRate,1);
    testRasterP = (testRasterSP < meanClickRate/(2*outputSampleRate));    
    testRasterN = (testRasterSN < meanClickRate/(2*outputSampleRate));
    testRaster = testRasterP - testRasterN;
    
    testSegment = conv(testRaster,testWaveform,'same');
    idealSegment = conv(testRaster,idealClick,'same');
     
    putdata(AO, testSegment);
    start([AI AO]);
    trigger([AI AO]);
        totalSamples = length(testSegment)*overSample;
        nsampin = AI.SamplesAcquired;
        nsampout = AO.SamplesOutput;
        while (nsampin < totalSamples)
            nsampin = AI.SamplesAcquired;
            nsampout = AO.SamplesOutput;
            pause(.25);
            %fprintf('.');
        end 
    stop([AI AO]);
    
    dataStream = getdata(AI,totalSamples); 
    recSegment = decimate(dataStream(:,2).*micGain,overSample);
    thisErr = norm(recSegment - idealSegment);
    
    if (thisErr < lastErr)
        lastErr = thisErr;
        close all;
        clickWaveform = testWaveform;
        disp(lastErr);
        plot(clickWaveform,'b');hold on;
        ix = find(testRaster > 0);
        plot(recSegment((ix(3)-length(clickWaveform)/2):(ix(3)+length(clickWaveform)/2)),'k');
        plot(idealSegment((ix(3)-length(clickWaveform)/2):(ix(3)+length(clickWaveform)/2)),'g');
        
        pause(1);
    else
        disp(['n = ',num2str(n)]);
    end
      
    testWaveform = clickWaveform;
    for m = 1:nChanges
        testSample = randi(length(testWaveform));
        testVal = testWaveform(testSample);
        if (abs(testVal) < zeroStep)
            if (rand() > .5) 
                testWaveform(testSample) = zeroStep;
            else
                testWaveform(testSample) = -zeroStep;
            end
        else
            if (rand() > .5) 
                testWaveform(testSample) = testWaveform(testSample)*(1+fracStep);
            else
                testWaveform(testSample) = testWaveform(testSample)*(1-fracStep);
            end
        end
    end
        
    
end
    
    
    