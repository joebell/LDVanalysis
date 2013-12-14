function plotAveragePips(data, plotColor)

    stimLagSamples = 21;
    plotLength = .045;
    plotSamples = floor(data.sampleRate.*plotLength);
    
    nPips = 1;
    ss = data.startSamples(2);
    totalPip  = data.LDVvelocity((ss - 100):(ss + plotSamples));
    totalStim = data.stimulus((ss - 100):(ss + plotSamples));
    
    for pipN = 3:length(data.startSamples)
        
        ss = data.startSamples(pipN);
        totalPip  = totalPip  + data.LDVvelocity((ss - 100):(ss + plotSamples));
        totalStim = totalStim + data.stimulus((ss - 100):(ss + plotSamples));
        
        nPips = nPips + 1;
    end
    
    meanPip = totalPip./nPips;
    ss = data.startSamples(2);
    totalPipErr  = (meanPip - data.LDVvelocity((ss - 100):(ss + plotSamples))).^2;
    for pipN = 3:length(data.startSamples)
        
        ss = data.startSamples(pipN);
        totalPipErr  = totalPipErr  + (meanPip - data.LDVvelocity((ss - 100):(ss + plotSamples))).^2;
        
        nPips = nPips + 1;
    end
    
    pipSTD = sqrt(totalPipErr./nPips);
    
    % Center velocities on 0
    meanPip = meanPip - mean(meanPip);
    
    hold on;
    p = cumsum(meanPip)./data.sampleRate;
    t = [0:(length(p)-1)]./data.sampleRate;
    plot(t,p, plotColor);
    
%     plot(meanPip , plotColor);
%     plot(meanPip + pipSTD, plotColor);
%     plot(meanPip + pipSTD, plotColor);
     
%     plot(diff(meanPip).*20, plotColor);
     p = [zeros(stimLagSamples,1);(totalStim./nPips).*.25*10^-3];
     t = [0:(length(p)-1)]./data.sampleRate;
     plot(t,p,'g');
     
     xlim([0 .015]);
     
     set(gcf,'Position',[ 272   562   700   156],'Color','w');
     xlims = xlim();
     ylims = ylim();
     myText = [num2str(data.Fo), ' Hz'];
     text(xlims(2),ylims(2),myText,'VerticalAlignment','top','HorizontalAlignment','right')

    

   