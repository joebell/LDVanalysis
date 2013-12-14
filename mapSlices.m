function mapSlices(out, plotColor, range)

    nList = round(size(out.mean,1)/2 + [2:-1:-2]*size(out.mean,1)./12)
    nSlices = length(nList);
    numThresh = 5;
    
    scale = -1.25;
    out.mean = 1*out.mean + scale.*out.meanStim;
   
    for nN = 1:nSlices
        n = nList(nN);
        subplot(nSlices,2,2*(nN-1)+1);
        slice = out.mean(n,:);
        Nslice = out.N(n,:);
        ix = find(Nslice < numThresh);
        slice(ix) = NaN;
        plot(out.posBins,slice,'Color',plotColor); hold on;
        xlabel('X'); ylabel('Acc.');
        line(xlim(),[0 0],'Color',[1 1 1]*.75);
        ylim([-1 1]*range);

        subplot(nSlices,2,2*(nN-1)+2);
        slice = out.mean(:,n);
        Nslice = out.N(n,:);
        ix = find(Nslice < numThresh);
        slice(ix) = NaN;
        plot(out.velBins,slice','Color',plotColor); hold on;
        xlabel('dX/dt'); ylabel('Acc.');
        line(xlim(),[0 0],'Color',[1 1 1]*.75);
        ylim([-1 1]*range);
    end