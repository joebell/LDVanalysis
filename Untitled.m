

load('C:\Documents and Settings\rwilson\Desktop\Joe\Code\simData\simAMP_D_passiveAntenna_75_-10_-12.mat');
data1 = data;
load('C:\Documents and Settings\rwilson\Desktop\Joe\Code\simData\simAMP_D_passiveAntenna_125_-10_-12.mat');
data2 = data;
load('C:\Documents and Settings\rwilson\Desktop\Joe\Code\simData\simAMP_D_passiveAntenna_250_-10_-12.mat');
data3 = data;
load('C:\Documents and Settings\rwilson\Desktop\Joe\Code\simData\simAMP_D_passiveAntenna_500_-10_-12.mat');
data4 = data;
analyzeAmplitudeSweeps({data1,data2,data3,data4})
