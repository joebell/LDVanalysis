

baseName = '../Data/131029/LDV131029_';
expNumList = [13];

Ms = [];
Bs = [];
lags = [];
err = [];

for expN = expNumList
    for trN = [1:5]
        
        load([baseName,num2str(expN),'_',num2str(trN),'.mat']);
%        xCorrAccel(data); hold on;
        
        [fitObj, sampleLag, gof] = plotStopSnips(data)
        
        Ms(end+1) = fitObj.p1;
        Bs(end+1) = fitObj.p2;
        lags(end+1) = sampleLag;
        err(end+1) = gof.rsquare;
        
    end
end

figure;
scatter(err,Ms);
figure;
scatter(err,Bs);


        
        
    