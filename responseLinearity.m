function responseLinearity()

expList = {'../Data/131022/LDV131022_12_1.mat',...
    '../Data/131022/LDV131022_13_1.mat',...
    '../Data/131022/LDV131022_11_1.mat',...
    '../Data/131022/LDV131022_14_1.mat'};
stimPowerList = 10.^[-1,-.5,0,.5];
    
for expN=1:length(expList)
    
    load(expList{expN});
    powers(expN,:) = extractPSD(data,data.Fo);
    
end

for freqN = 1:size(powers,2)
    subplot(4,2,ceil(freqN/(size(powers,2)/8)));
    loglog(stimPowerList,powers(:,freqN),'Color',pretty(mod(freqN,(size(powers,2)/8))+1));
    hold on;
end

for plotN = 1:8
    
    subplot(4,2,plotN);
    axis tight;
    lims = ylim();
    prop = lims(2)/stimPowerList(end);
    loglog(xlim(),xlim()*prop,'k-.');
    axis tight;
    xlabel('Stimulus Amplitude (V)');
    ylabel('Response Amplitude (m^2)');
end
