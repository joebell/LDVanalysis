function scaleSpectra()

expList = {'../Data/131022/LDV131022_24_0.mat',...
'../Data/131022/LDV131022_26_0.mat',...
'../Data/131022/LDV131022_28_0.mat',...
    };
scalingList = {'../Data/131022/LDV131022_3_0.mat',...
    '../Data/131022/LDV131022_5_0.mat',...
    '../Data/131022/LDV131022_6_0.mat',...
    };
%scalingList = expList;
peakRange = [250,290];
%peakRange = [1000,1050];

load(scalingList{1});
refData = data;
[RefPxx,RefF] = velSpectrum(refData,pretty(1),'plotOff'); 
peakIx = dsearchn(RefF,peakRange');
meanRefPower = mean(RefPxx(peakIx(1):peakIx(2)));

for expN = 1:length(expList)
    
    subplot(3,1,1);
    load(scalingList{expN});
    velSpectrum(data,pretty(expN));
    xlim([10 5000]);
    title('Raw Scaling Spectra');
    
    
    load(scalingList{expN});
    scalingData = data;
    [scalingPxx,scalingF] = velSpectrum(scalingData,'k','plotOff'); 
    peakIx = dsearchn(scalingF,peakRange');
    meanScalingPower = mean(scalingPxx(peakIx(1):peakIx(2)));
    scaleFactor = sqrt(meanRefPower/meanScalingPower)
    scalingData.LDVvelocity = scaleFactor*scalingData.LDVvelocity;
    subplot(3,1,2);
    velSpectrum(scalingData,pretty(expN));
    xlim([10 5000]);
    title('Scaling Spectra');
    
    load(expList{expN});
    testData = data;
    testData.LDVvelocity = scaleFactor*testData.LDVvelocity;
    subplot(3,1,3);
    velSpectrum(testData,pretty(expN));
    title('Test spectra');
    xlim([10 5000]);

end
    
    
    