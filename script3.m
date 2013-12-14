% script3

 baseName = '../Data/131008/LDV131008_';
 load([baseName,num2str(69),'_1.mat']);
 dataA = data;
 load([baseName,num2str(69+5),'_1.mat']);
 dataB = data;
 analyzeAmplitudeSweeps({dataA,dataB});
 for n = 70:73
     
     load([baseName,num2str(n),'_1.mat']);
     data1 = data;
     dataA.LDVvelocity = dataA.LDVvelocity + data1.LDVvelocity;
     load([baseName,num2str(n+5),'_1.mat']);
     data2 = data;
     dataB.LDVvelocity = dataB.LDVvelocity + data2.LDVvelocity;
     analyzeAmplitudeSweeps({data1,data2});
 end
 
 dataA.LDVvelocity = dataA.LDVvelocity ./ 5;
 dataB.LDVvelocity = dataB.LDVvelocity ./ 5;
     