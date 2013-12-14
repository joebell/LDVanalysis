% script6

dL = makeDataList('../Data/131024/LDV131024_24_',[1]);
out400SW = mapAccel(dL);
dL = makeDataList('../Data/131024/LDV131024_24_',[2]);
out200SW = mapAccel(dL);
dL = makeDataList('../Data/131024/LDV131024_24_',[3]);
out125SW = mapAccel(dL);
dL = makeDataList('../Data/131024/LDV131024_24_',[4]);
out100SW = mapAccel(dL);
dL = makeDataList('../Data/131024/LDV131024_24_',[5]);
out75SW = mapAccel(dL);
dL = makeDataList('../Data/131024/LDV131024_24_',[6]);
out50SW = mapAccel(dL);

% dL = makeDataList('../Data/131024/LDV131024_17_',[2]);
% out300SW = mapAccel(dL);
% dL = makeDataList('../Data/131024/LDV131024_16_',[7]);
% out200SW = mapAccel(dL);
% dL = makeDataList('../Data/131024/LDV131024_16_',[6]);
% out175SW = mapAccel(dL);
% dL = makeDataList('../Data/131024/LDV131024_16_',[5]);
% out150SW = mapAccel(dL);
% dL = makeDataList('../Data/131024/LDV131024_16_',[4]);
% out125SW = mapAccel(dL);
% dL = makeDataList('../Data/131024/LDV131024_16_',[3]);
% out100SW = mapAccel(dL);