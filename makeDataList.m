function dataList = makeDataList(baseName,list)

    dataList = {};
    for n=1:length(list)
        
        load([baseName,num2str(list(n)),'.mat']);
        dataList{end+1} = data;
    end
    