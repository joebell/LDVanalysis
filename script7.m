
% To Do:
%
% Subtract fit linear response from phase plots.


% load('../Data/131022/LDV131022_16_1.mat');
% out50SW = mapAccel({data});

load('../Data/131029/LDV131029_10_1.mat');
out40S = mapAccel({data});
load('../Data/131029/LDV131029_10_2.mat');
out60S = mapAccel({data});
load('../Data/131029/LDV131029_10_3.mat');
out80S = mapAccel({data});
load('../Data/131029/LDV131029_10_4.mat');
out100S = mapAccel({data});
load('../Data/131029/LDV131029_10_5.mat');
out120S = mapAccel({data});
load('../Data/131029/LDV131029_10_6.mat');
out140S = mapAccel({data});
load('../Data/131029/LDV131029_10_7.mat');
out160S = mapAccel({data});

load('../Data/131029/LDV131029_14_1.mat');
out40HS = mapAccel({data});
load('../Data/131029/LDV131029_14_2.mat');
out60HS = mapAccel({data});
load('../Data/131029/LDV131029_14_3.mat');
out80HS = mapAccel({data});
load('../Data/131029/LDV131029_14_4.mat');
out100HS = mapAccel({data});
load('../Data/131029/LDV131029_14_5.mat');
out120HS = mapAccel({data});
load('../Data/131029/LDV131029_14_6.mat');
out140HS = mapAccel({data});
load('../Data/131029/LDV131029_14_7.mat');
out160HS = mapAccel({data});

save('131029-maps.mat','out40S','out40HS',...
    'out60S','out60HS',...
    'out80S','out80HS',...
    'out100S','out100HS',...
    'out120S','out120HS',...
    'out140S','out140HS',...
    'out160S','out160HS');

