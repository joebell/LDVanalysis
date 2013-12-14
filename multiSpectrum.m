function multiSpectrum()

baseDir = '../Data/130508/';
baseName = 'LDV130508_8_*.mat';

fileList = dir([baseDir,baseName]);

for fileN = 1:size(fileList,1)
    
    load([baseDir,fileList(fileN).name]);
    powerSpectrum(data,pretty(randi(7)));
    fileList(fileN).name
    data.stimAmp
end