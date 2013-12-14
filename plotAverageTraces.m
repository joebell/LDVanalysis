function plotAverageTraces(dataList, plotColor)

    vel = [];

    for dataN = 1:length(dataList)
        
        dataN
        data = dataList{dataN};
        
        if dataN > 1
            vel = vel + data.LDVvelocity;
        else
            vel = data.LDVvelocity;
        end
        
    end
    
    vel = vel./length(dataList);
    
    hold on;
    plot((vel), plotColor);