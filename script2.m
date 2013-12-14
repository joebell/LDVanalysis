% script2

% load('../Data/131001/LDV131001_20_1.mat');
% powerSpectrum(data,'m');
% load('../Data/131001/LDV131001_17_1.mat');
% powerSpectrum(data,'b');

% load('../Data/131001/LDV131001_19_1.mat');
% data1 = data;
% load('../Data/131001/LDV131001_10_1.mat');
% data2 = data;
% load('../Data/131001/LDV131001_25_1.mat');
% data3 = data;
% dataAct = data;
% dataAct.LDVvelocity = (data1.LDVvelocity + data2.LDVvelocity + data3.LDVvelocity)./3;
% 
% 
% load('../Data/131001/LDV131001_22_1.mat');
% data1 = data;
% load('../Data/131001/LDV131001_15_1.mat');
% data2 = data;
% load('../Data/131001/LDV131001_28_1.mat');
% data3 = data;
% dataPass = data;
% dataPass.LDVvelocity = (data1.LDVvelocity + data2.LDVvelocity + data3.LDVvelocity)./3;
% 
% 
% powerSpectrum(dataAct,'b');
% powerSpectrum(dataPass,'m');

amplitudes = [-1.25:.5:-.25];
baseName = '../Data/131007/LDV131007_';
fileList = [18,20,8];
for n = 1:length(fileList)
    
    subplot(4,1,n); hold on;
    title(['Sensitivity @ Power = ',num2str(amplitudes(n))]);
    fileN = fileList(n);
    load([baseName,num2str(fileN),'_1.mat']);
    powers = analyzeFreqPips(data)./10^amplitudes(n); 
    semilogx(data.Fo,powers,'b');
    actPowers(n,:) = powers;
    set(gca,'XScale','log');
end
fileList = [22,24,13];
for n = 1:length(fileList)
    subplot(4,1,n); hold on;
    title(['log10 Stimulus Power: ',num2str(amplitudes(n))]);
    fileN = fileList(n);
    load([baseName,num2str(fileN),'_1.mat']);
    powers = analyzeFreqPips(data)./10^amplitudes(n); 
    semilogx(data.Fo,powers,'m');
    passPowers(n,:) = powers;
    set(gca,'XScale','log');
    xlim([80 1500]);
    ylim([0 1.8]);
    ylabel('Sensitivity');
end

return;
figure;
subplot(3,1,1);
image(data.Fo,amplitudes,(actPowers),'CDataMapping','scaled'); 
set(gca,'YDir','normal','XScale','log');
title('Active sensitivity'); colorbar;
caxis([0 .8]);
subplot(3,1,2);
image(data.Fo,amplitudes,(passPowers),'CDataMapping','scaled'); 
set(gca,'YDir','normal','XScale','log');
title('Passive sensitivity'); colorbar;
caxis([0 .8]);
subplot(3,1,3);
image(data.Fo,amplitudes,(actPowers) - (passPowers),'CDataMapping','scaled'); 
set(gca,'YDir','normal','XScale','log');
title('Difference'); colorbar;
caxis([-.3 .3]);

% for n = 1:length(data.Fo)
%     figure;
%     plot(1:9, log10(actPowers(:,n)),'b');
%     hold on;
%     plot(1:9, log10(passPowers(:,n)),'m');
%     title(['Fo = ',num2str(data.Fo(n)),' Hz']);
% end



