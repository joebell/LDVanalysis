function animateSpectrum()

preName = '../Data/131022/LDV131022_23_0.mat';
baseName = '../Data/131022/LDV131022_24_';
trials = 0:1:9;

nPlots = length(trials) - 2;

load([baseName,num2str(trials(1)),'.mat']);
[spec0,F] = velSpectrum(data,'k','plotOff');
load(preName);
[specL,F] = velSpectrum(data,'b','plotOff');

for plotN = 1:nPlots;
    subplot(4,2,plotN);
    load([baseName,num2str(trials(1+plotN)),'.mat']);
    [spec1,F] = velSpectrum(data,'m','plotOff');
    load([baseName,num2str(trials(2+plotN)),'.mat']);
    [spec2,F] = velSpectrum(data,'r','plotOff');
    
    loglog(F,specL,'b'); hold on;
    loglog(F,spec0,'k');
    loglog(F,spec2,'r');
    loglog(F,spec1,'m');
    xlim([10 1500]);
    xlabel('Freq. (Hz)');
    ylabel('(m/s^2)/Hz');
end
    
    
    