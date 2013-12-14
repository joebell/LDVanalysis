function animateLinearResponse()

preName = '../Data/131023/LDV131023_30_1.mat';
baseName = '../Data/131023/LDV131023_';
trials = 31:40;

nPlots = length(trials) - 2;
plotReal = true;

load([baseName,num2str(trials(1)),'_1.mat']);
Z0 = linearResponseFunction(data);
load(preName);
ZL = linearResponseFunction(data);

for plotN = 1:nPlots;
    subplot(4,2,plotN);
    load([baseName,num2str(trials(1+plotN)),'_1.mat']);
    Z1 = linearResponseFunction(data);
    load([baseName,num2str(trials(2+plotN)),'_1.mat']);
    Z2 = linearResponseFunction(data);
    F = data.Fo;
    if plotReal
        semilogx(F,real(ZL)*10^-3,'b'); hold on;
        semilogx(F,real(Z0)*10^-3,'k');
        semilogx(F,real(Z2)*10^-3,'r');
        semilogx(F,real(Z1)*10^-3,'m');
    else
        semilogx(F,imag(ZL)*10^-3,'b'); hold on;
        semilogx(F,imag(Z0)*10^-3,'k');
        semilogx(F,imag(Z2)*10^-3,'r');
        semilogx(F,imag(Z1)*10^-3,'m');
    end
    xlim([10 2000]);
    ylim([-125 50]);
    plot(xlim(),[0 0],'c-.');
    xlabel('Freq. (Hz)');
    ylabel('nm/pN');
end
    
    
    