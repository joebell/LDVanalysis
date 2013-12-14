function mapDiffSlices(out, plotColor)

    map = out;

    nList = 64 + [2:-1:-2]*10;
    nSlices = length(nList);
    
    dAdP = (map.mean(1:end,2:end) - map.mean(1:end,1:(end-1)))/(map.posBins(2)-map.posBins(1));
    dAdP(:,end+1) = zeros(size(map.mean,1),1);
    
    dAdV = (map.mean(2:end,1:end) - map.mean(1:(end-1),1:end))/(map.velBins(2)-map.velBins(1));
    dAdV(end+1,:) = zeros(1,size(map.mean,1));
    
    useVal = -dAdV;
    useLabel = 'Damping';
   
    for nN = 1:nSlices
        n = nList(nN);
        subplot(nSlices,2,2*(nN-1)+1);
        slice = useVal(n,:);

        plot(out.posBins,slice,plotColor); hold on;
        xlabel('X'); ylabel(useLabel);
        line(xlim(),[0 0],'Color',[1 1 1]*.75);
        ylim([-1 1]*2*10^4);


        subplot(nSlices,2,2*(nN-1)+2);
        slice = useVal(:,n);
        plot(out.velBins,slice',plotColor); hold on;
        xlabel('dX/dt'); ylabel(useLabel);
        line(xlim(),[0 0],'Color',[1 1 1]*.75);
        ylim([-1 1]*2*10^4);

    end