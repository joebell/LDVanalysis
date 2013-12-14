function compData = makeCompositeData(baseName, numbers)

load([baseName,num2str(numbers(2)),'.mat']);
%figure;
%plot(data.LDVvelocity,'Color',pretty(1)); hold on;
compData = data;

for fileN = 2:length(numbers)
    
    load([baseName,num2str(numbers(fileN)),'.mat'])
    compData.LDVvelocity = compData.LDVvelocity + data.LDVvelocity;
    %plot(data.LDVvelocity,'Color',pretty(fileN+1));
end

compData.LDVvelocity = compData.LDVvelocity./length(numbers);
figure;
pos = cumsum(compData.LDVvelocity - mean(compData.LDVvelocity))./data.sampleRate;
plot(compData.stimulus./1000,'Color','g'); hold on;
plot(pos,'Color','b');

