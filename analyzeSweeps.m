function analyzeSweeps()

baseName = 'LDV130301_17_';

for n=1:5
    
    load([baseName,num2str(n),'a.mat']);     
    smoothVelA = sqrt(smooth(data.LDVvelocity.^2,2001));
    load([baseName,num2str(n),'b.mat']);     
    smoothVelB = sqrt(smooth(data.LDVvelocity.^2,2001));
    
    figure;
    subplot(2,1,1);
    semilogx(data.frequency, smoothVelA,'b'); hold on;
    semilogx(data.frequency, smoothVelB,'r');
    subplot(2,1,2);
    semilogx(data.frequency, smoothVelB./smoothVelA);
end

    