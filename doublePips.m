function doublePips(baseN)

baseName = '../Data/130925/LDV130925_';

figure;
load([baseName,num2str(baseN),'_1.mat']);
plotAveragePips(data,'b');
load([baseName,num2str(baseN+1),'_1.mat']);
plotAveragePips(data,'m');
plot(xlim(),[0 0],'k');
