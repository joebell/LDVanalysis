function catData()

% fileList = {'./130301/LDV130301_21_1.mat',...
%             './130301/LDV130301_21_2.mat',...
%             './130301/LDV130301_21_3.mat',...
%             './130301/LDV130301_21_4.mat',...
%             './130301/LDV130301_22_1.mat',...
%             './130301/LDV130301_22_2.mat',...
%             './130301/LDV130301_22_3.mat',...
%             './130301/LDV130301_22_4.mat',...
%             './130301/LDV130301_23_1.mat',...
%             './130301/LDV130301_23_2.mat',...
%             './130301/LDV130301_23_3.mat',...
%             './130301/LDV130301_23_4.mat'};


fileList = {'./LDV130302_2_1.mat',...
            './LDV130302_2_2.mat',...
            './LDV130302_2_3.mat',...
            './LDV130302_2_4.mat',...
            './LDV130302_3_1.mat',...
            './LDV130302_3_2.mat',...
            './LDV130302_3_3.mat',...
            './LDV130302_3_4.mat',...
            './LDV130302_4_1.mat',...
            './LDV130302_4_2.mat',...
            './LDV130302_4_3.mat',...
            './LDV130302_4_4.mat',...
            
            };

outFile = './LDVcatDataDead.mat';        

posIdx = [];
velIdx = [];
accel = [];

for fileN=1:length(fileList)
    fileN
    load(fileList{fileN});
    posIdx = [posIdx,data.posIdx'];
    velIdx = [velIdx,data.velIdx'];
    accel  = [accel,data.accel'];
    posBins = data.posBins;
    velBins = data.velBins;
    size(accel)
end


clear data;

data.posIdx = posIdx;
data.velIdx = velIdx;
data.accel  = accel;
data.posBins = posBins;
data.velBins = velBins;

save(outFile,'data');