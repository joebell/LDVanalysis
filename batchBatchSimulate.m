function batchBatchSimulate(keyString)

    fileList = ls(keyString);
    
    for n=1:size(fileList,1)
        disp(fileList(n,:));
        batchSimulate(fileList(n,:));
    end
    