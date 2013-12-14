%script

% dL = makeDataList('../Data/131008/LDV131008_61_',[1:5]);
% out1 = mapAccelFromStops(dL);
% dL = makeDataList('../Data/131008/LDV131008_62_',[1:5]);
% outC1 = mapAccelFromStops(dL);
% 
% dL = makeDataList('../Data/131008/LDV131008_63_',[1:5]);
% out2 = mapAccelFromStops(dL);
% dL = makeDataList('../Data/131008/LDV131008_64_',[1,2,3,5]);
% outC2 = mapAccelFromStops(dL);
% 
% dL = makeDataList('../Data/131008/LDV131008_65_',[1:5]);
% out3 = mapAccelFromStops(dL);
% dL = makeDataList('../Data/131008/LDV131008_66_',[1:5]);
% outC3 = mapAccelFromStops(dL);
% 
% dL = makeDataList('../Data/131008/LDV131008_67_',[1:5]);
% out4 = mapAccelFromStops(dL);
% dL = makeDataList('../Data/131008/LDV131008_68_',[1:5]);
% outC4 = mapAccelFromStops(dL);

% load('../Data/130927/LDV130927_12_0.mat');
% data1 = data;
% load('../Data/130927/LDV130927_20_0.mat');
% data2 = data;
% load('../Data/130927/LDV130927_26_0.mat');
% data3 = data;
% dL = {data1,data2,data3};
% out = mapAccel(dL);
% 
% load('../Data/130927/LDV130927_14_0.mat');
% data1 = data;
% load('../Data/130927/LDV130927_22_0.mat');
% data2 = data;
% load('../Data/130927/LDV130927_29_0.mat');
% data3 = data;
% dL = {data1,data2,data3};
% outC = mapAccel(dL);

% dL = makeDataList('../Data/130927/LDV130927_3_',[1:5]);
% out1 = mapAccelFromStops(dL);
% dL = makeDataList('../Data/130927/LDV130927_4_',[1:5]);
% outC1 = mapAccelFromStops(dL);
% 
% dL = makeDataList('../Data/130927/LDV130927_9_',[1:5]);
% out2 = mapAccelFromStops(dL);
% dL = makeDataList('../Data/130927/LDV130927_10_',[1:5]);
% outC2 = mapAccelFromStops(dL);
% 
% dL = makeDataList('../Data/130927/LDV130927_17_',[1:5]);
% out3 = mapAccelFromStops(dL);
% dL = makeDataList('../Data/130927/LDV130927_18_',[1:5]);
% outC3 = mapAccelFromStops(dL);
% 
% dL = makeDataList('../Data/130927/LDV130927_23_',[1:5]);
% out4 = mapAccelFromStops(dL);
% dL = makeDataList('../Data/130927/LDV130927_24_',[1:5]);
% outC4 = mapAccelFromStops(dL);
% 
% out = out1; out.mean = (out1.mean + out2.mean + out3.mean + out4.mean)./4;
% outC = outC1; outC.mean = (outC1.mean + outC2.mean + outC3.mean + outC4.mean)./4;
% out.N = out1.N + out2.N + out3.N + out4.N;
% outC.N = outC1.N + outC2.N + outC3.N + outC4.N;
% 
% % out = out1; out.mean = (out1.mean + out2.mean )./2;
% % outC = outC1; outC.mean = (outC1.mean + outC2.mean )./2;
% % out.N = out1.N + out2.N ;
% % outC.N = outC1.N + outC2.N;
% 
% out = blurImage(out,1);
% outC = blurImage(outC,1);

% load('../Data/131008/LDV131008_71_1.mat');
% out = mapAccel({data});
% load('../Data/131008/LDV131008_77_1.mat');
% outC = mapAccel({data});

% load('../Data/130927/LDV130927_1_1.mat');
% out = mapAccel({data});
% load('../Data/130927/LDV130927_2_1.mat');
% outC = mapAccel({data});

% load('../Data/130927/LDV130927_17_2.mat');
% out = mapAccel({data});
% load('../Data/130927/LDV130927_24_1.mat');
% outC = mapAccel({data});

% dL = makeDataList('../Data/130927/LDV130927_3_',[1:5]);
% out1 = mapAccel(dL);
% dL = makeDataList('../Data/130927/LDV130927_4_',[1:5]);
% outC1 = mapAccel(dL);
% 
% dL = makeDataList('../Data/130927/LDV130927_9_',[1:5]);
% out2 = mapAccel(dL);
% dL = makeDataList('../Data/130927/LDV130927_10_',[1:5]);
% outC2 = mapAccel(dL);

% dL = makeDataList('../Data/130927/LDV130927_17_',[1:5]);
% out3 = mapAccel(dL);
% dL = makeDataList('../Data/130927/LDV130927_18_',[1:5]);
% outC3 = mapAccel(dL);

% dL = makeDataList('../Data/130927/LDV130927_23_',[1:5]);
% out4 = mapAccel(dL);
% dL = makeDataList('../Data/130927/LDV130927_24_',[1:5]);
% outC4 = mapAccel(dL);

% out = out1; out.mean = (out1.mean + out2.mean + out3.mean + out4.mean)./4;
% outC = outC1; outC.mean = (outC1.mean + outC2.mean + outC3.mean + outC4.mean)./4;
% out.N = out1.N + out2.N + out3.N + out4.N;
% outC.N = outC1.N + outC2.N + outC3.N + outC4.N;
%out.meanStim = (out1.meanStim + out2.meanStim + out3.meanStim + out4.meanStim)./4;
%outC.meanStim = (outC1.meanStim + outC2.meanStim + outC3.meanStim + outC4.meanStim)./4;

dL = makeDataList('../Data/131022/LDV131022_17_',[4]);
out400SW = mapAccel(dL);
dL = makeDataList('../Data/131022/LDV131022_16_',[7]);
out200SW = mapAccel(dL);
dL = makeDataList('../Data/131022/LDV131022_16_',[3]);
out100SW = mapAccel(dL);

% scale = -.58;
% out.mean = 1*out.mean + scale.*out.meanStim;
% outC.mean = 1*outC.mean + scale.*outC.meanStim;
outD = outC; outD.mean = out.mean - outC.mean;

plotMap(out);
axis = caxis();
caxis([-max(abs(axis)) max(abs(axis))]);
plotMap(outC);
caxis([-max(abs(axis)) max(abs(axis))]);
plotMap(outD);
diffAxis = caxis();
caxis([-2000 2000])
set(gcf,'Color','w');

figure;
mapSlices(out,'b',max(abs(axis))); hold on;
mapSlices(outC,'m',max(abs(axis))); hold on;

figure;
mapSlices(outD,'k',2000);

%analyzeAmplitudeSweeps({d1,d2});

% figure;
% load('../Data/130924/LDV130924_23_1.mat');
% plotAveragePips(data,'b'); hold on;
% load('../Data/130924/LDV130924_26_1.mat');
% plotAveragePips(data,'m');

