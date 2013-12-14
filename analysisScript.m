
baseName = 'LDV130221_3_';
plotColor = ['k','b','m','r','g','k','b','m','r','g','k','b','m','r','g'];

spectFig = figure();
sliceFig = figure();

for n=1:5
    load([baseName,num2str(n),'.mat']); 
%      figure(spectFig);
%      powerSpectrum(data,plotColor(n));
     out = plotAccel(data); 
     figure(sliceFig);
     mapSlices(out,plotColor(n));
end

% for n=3:5
% load([baseName,num2str(n),'.mat']); 
% 
% sampleRate = 100000;
% trialLength = 20;
% time = [0:(trialLength*sampleRate)]./sampleRate;
% midSample = round(trialLength*sampleRate/2);
% sweepTime = trialLength/2;
% startPower = -2;
%     endPower   = .5;
%     sweepTime = trialLength/2;
%     amplitude = 10.^(startPower + (endPower - startPower)*time/sweepTime);
%     amplitude(midSample:end) = 10.^(endPower +(endPower - startPower)*(1 - time(midSample:end)/sweepTime));
% 
% smoothVel = sqrt(smooth(data.LDVvelocity.^2,2001));
% 
% figure();
% plot(log10(amplitude(1:midSample)),log10(smoothVel(1:midSample)),'b'); hold on;
% plot(log10(amplitude(midSample:end)),log10(smoothVel(midSample:end)),'r'); 
% end