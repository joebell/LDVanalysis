function deConvolveClick()

    daqSetup();

    clickLength = .001;
    meanClickRate = 50;
    testLength    =  5;
    clickPoint    = round(clickLength*outputSampleRate/2);
    testAmp = .8;

    LDVgain = 2/1; % (mm/s)/V
    micGain = (1/.267)/100; % (1/.267 (mm/s)/V) is BL sensitivity
    
    outOfBounds = true;
    while (outOfBounds)
        testRasterSP = rand(testLength*outputSampleRate,1);
        testRasterSN = rand(testLength*outputSampleRate,1);
        testRasterP = (testRasterSP < meanClickRate/(2*outputSampleRate));    
        testRasterN = (testRasterSN < meanClickRate/(2*outputSampleRate));
        testRaster = testAmp.*(testRasterP - testRasterN);
        testSegment = cumsum(testRaster);
        ix = find(abs(testSegment) > 5);
        if (length(ix) > 0)
            outOfBounds = true;
            disp('.');
%             plot(testSegment);
%             pause(.2);
        else
            outOfBounds = false;
        end
        close all;
    end
    
    
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
            fprintf('.');
        end 
    stop([AI AO]);
    
    dataStream = getdata(AI,totalSamples); 
    recSegment = decimate(dataStream(:,2).*micGain,overSample);
    

    imp = xcorr(recSegment,testRaster,1000,'none');
    figure();
    subplot(2,1,1);
    plot(([1:length(imp)]-length(imp)/2)./outputSampleRate*10^6,imp);
    return;
    convSeg = conv(testSegment,imp,'same')./100;
    figure();
    plot(convSeg,'r'); hold on;
    plot(recSegment,'b'); hold on;


    deConvCmd = fdeconv(testSegment,fliplr(imp));
    size(testSegment)
    size(deConvCmd)
    figure();
    plot(testSegment(1:length(deConvCmd)),'b'); hold on;
    plot(deConvCmd,'r');
    
    intDeConvCmd = (deConvCmd);
    
    putdata(AO, intDeConvCmd*1);
    start([AI AO]);
    trigger([AI AO]);
        totalSamples = length(intDeConvCmd)*overSample;
        nsampin = AI.SamplesAcquired;
        nsampout = AO.SamplesOutput;
        while (nsampin < totalSamples)
            nsampin = AI.SamplesAcquired;
            nsampout = AO.SamplesOutput;
            pause(.25);
            fprintf('.');
        end 
    stop([AI AO]);
    
    dataStream = getdata(AI,totalSamples); 
    recSegment2 = decimate(dataStream(:,2).*micGain,overSample);
    
    figure();
    plot(recSegment,'b'); hold on;
    plot(recSegment2,'r');

    figure();
    imp2 = xcorr(recSegment2,testSegment,1000,'none');
    plot(imp2);
    