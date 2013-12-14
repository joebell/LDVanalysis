function alignFromMap(X,dXdT,system)

    fileName = '../Data/130320/LDV130320_8_4.mat';
    load(fileName);
    if ~isfield(data,'sampleRate')
        data.sampleRate = 20000;
    end
    [pos,vel,accel] = filterAccel(data);
    timeWindow = .0005; % Sec
    
    % figure();
    
    Xn = dsearchn(system.posBins',X);
    dXdTn = dsearchn(system.velBins',dXdT);
    
    ix = find((system.posIdx == Xn) & (system.velIdx == dXdTn));
    nSamples = round(timeWindow*data.sampleRate);
    
    traceSegs = [];
    traceSegsDx = [];
    data.diffStim = [diff(data.stimulus);0];
        disp(length(ix));
    
    for ixN= 1:length(ix)
        stSamp = ix(ixN) - nSamples;
        enSamp = ix(ixN) + nSamples;
        if (stSamp < 1) 
            stSamp = 1; 
        end
        if (enSamp > length(data.mic)) 
            enSamp = length(data.mic); 
        end
        %plot(((stSamp:enSamp)-ix(ixN))./data.sampleRate,data.mic(stSamp:enSamp),'Color',[1 1 1]*.8);hold on;
        traceIx = [stSamp:enSamp] - ix(ixN) + 1 + nSamples;
        traceSegs(traceIx,end+1) =   pos(stSamp:enSamp);
        traceSegsDx(traceIx,end+1) = vel(stSamp:enSamp);
        plot(pos(stSamp:enSamp),vel(stSamp:enSamp),'k'); 
        hold on;
    end
    
    figure;
    hist(accel(ix),50);
    
    meanMic = nanmean(traceSegs,2);
    stdMic  = nanstd(traceSegs,0,2);
    %h = joeArea((-nSamples:nSamples)'./(data.sampleRate/dsFactor), meanMic-stdMic, meanMic+stdMic);
    %set(h,'EdgeColor','none','FaceColor','b','FaceAlpha',.2); hold on;    
    %plot((-nSamples:nSamples)./data.sampleRate,meanMic,'b'); hold on;
    
        
        
    
    
    