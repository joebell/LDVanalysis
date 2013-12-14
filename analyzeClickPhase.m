function analyzeClickPhase()

baseDir = '../Data/130521/';
baseName = 'LDV130521_18_*.mat';

fileList = dir([baseDir,baseName]);

load([baseDir,fileList(1).name]);
nPhases = data.nPhases;
Fo = data.Fo;
sampleRate = data.sampleRate;
sampleSpan = 1*round((1/Fo)*sampleRate);
preRange = 2;
postRange = 6;

traceFig = figure();
avgFig = figure();
diffFig = figure();
posFig = figure();
diffPosFig = figure();
phaseFig = figure();
powersList = [];
phasesList = [];
direcsList = [];

for phaseN = 1:nPhases
    pTraces = [];
    zTraces = [];
    nTraces = [];
    NpTraces = 0;
    NzTraces = 0;
    NnTraces = 0;
    figure(traceFig);
    subplot(nPhases,1,phaseN); hold on;
    
    for fileN = 1:length(fileList)
        
        load([baseDir,fileList(fileN).name]);
        [pos,vel,accel] = filterAccel(data);
        
        ix = find((data.stepPhases == phaseN) & (data.stepDirections == 0));
        for ixN = ix
            cSample = data.stepSamples(ixN);
            sampRange = [(cSample-preRange*sampleSpan):(cSample+postRange*sampleSpan)];
            %plot(pos(sampRange),vel(sampRange),'k');
            plot((sampRange-cSample)./sampleRate,vel(sampRange),'k');
            if NzTraces == 0
                zTraces = vel(sampRange); NzTraces = 1;
            else
                zTraces(:,end+1) = vel(sampRange); 
                NzTraces = NzTraces + 1;
            end
        end
        ix = find((data.stepPhases == phaseN) & (data.stepDirections == 1));
        for ixN = ix
            cSample = data.stepSamples(ixN);
            sampRange = [(cSample-preRange*sampleSpan):(cSample+postRange*sampleSpan)];
            %plot(pos(sampRange),vel(sampRange),'g');
            plot((sampRange-cSample)./sampleRate,vel(sampRange),'g');
            if NpTraces == 0
                pTraces = vel(sampRange); NpTraces = 1;
            else
                pTraces(:,end+1) = vel(sampRange); 
                NpTraces = NpTraces + 1;
            end
        end
        ix = find((data.stepPhases == phaseN) & (data.stepDirections == -1));
        for ixN = ix
            cSample = data.stepSamples(ixN);
            sampRange = [(cSample-preRange*sampleSpan):(cSample+postRange*sampleSpan)];
            %plot(pos(sampRange),vel(sampRange),'r');
            plot((sampRange-cSample)./sampleRate,vel(sampRange),'r');
            if NnTraces == 0
                nTraces = vel(sampRange); NnTraces = 1;
            else
                nTraces(:,end+1) = vel(sampRange);  
                NnTraces = NnTraces + 1;
            end
        end
    end
    
  figure(avgFig);
    subplot(nPhases,1,phaseN); hold on;
        h = joeArea((sampRange-cSample)./sampleRate, mean(zTraces,2)-std(zTraces,0,2), mean(zTraces,2)+std(zTraces,0,2));
    plot((sampRange-cSample)./sampleRate,mean(zTraces,2),'k');
    set(h,'EdgeColor','none','FaceColor','k','FaceAlpha',.3);   
        h = joeArea((sampRange-cSample)./sampleRate, mean(pTraces,2)-std(pTraces,0,2), mean(pTraces,2)+std(pTraces,0,2));
    plot((sampRange-cSample)./sampleRate,mean(pTraces,2),'g');
    set(h,'EdgeColor','none','FaceColor','g','FaceAlpha',.3);
        h = joeArea((sampRange-cSample)./sampleRate, mean(nTraces,2)-std(nTraces,0,2), mean(nTraces,2)+std(nTraces,0,2));
    plot((sampRange-cSample)./sampleRate,mean(nTraces,2),'r');
    set(h,'EdgeColor','none','FaceColor','r','FaceAlpha',.3);
    
    figure(phaseFig);
        subplot(nPhases/2,2,phaseN);
        pP = cumsum(mean(pTraces,2))./sampleRate;
        pZ = cumsum(mean(zTraces,2))./sampleRate;
        pN = cumsum(mean(nTraces,2))./sampleRate;
        plot(pP-mean(pP),mean(pTraces,2),'g'); hold on;
        plot(pZ-mean(pZ),mean(zTraces,2),'k'); hold on;
        plot(pN-mean(pN),mean(nTraces,2),'r'); hold on;
        xlim([-2 2]*10^-4);
        plot(xlim(),[0 0],'Color',[1 1 1].*.8);
        plot([0 0],ylim(),'Color',[1 1 1].*.8);

        
    figure(posFig);
    subplot(nPhases,1,phaseN); hold on;
    pPos = cumsum(mean(pTraces,2))./sampleRate;
    pPos = pPos - mean(pPos);
    nPos = cumsum(mean(nTraces,2))./sampleRate;
    nPos = nPos - mean(nPos);
    zPos = cumsum(mean(zTraces,2))./sampleRate;
    zPos = zPos - mean(zPos);
    plot((sampRange-cSample)./sampleRate,zPos,'k');
    plot((sampRange-cSample)./sampleRate,pPos,'g');
    plot((sampRange-cSample)./sampleRate,nPos,'r');
    
    
    figure(diffFig);
    subplot(nPhases,1,phaseN); hold on;
    h = joeArea((sampRange-cSample)./sampleRate, mean(pTraces,2)-std(pTraces,0,2)-mean(zTraces,2), mean(pTraces,2)+std(pTraces,0,2)-mean(zTraces,2));
    plot((sampRange-cSample)./sampleRate,mean(pTraces,2)-mean(zTraces,2),'g');
    set(h,'EdgeColor','none','FaceColor','g','FaceAlpha',.3);    
    h = joeArea((sampRange-cSample)./sampleRate, -(mean(nTraces,2)-std(nTraces,0,2)-mean(zTraces,2)), -(mean(nTraces,2)+std(nTraces,0,2)-mean(zTraces,2)));   
    plot((sampRange-cSample)./sampleRate,-(mean(nTraces,2)-mean(zTraces,2)),'r');
    set(h,'EdgeColor','none','FaceColor','r','FaceAlpha',.3);
    plot(xlim(),[0 0],'Color',[.8 .8 .8]);
    
    figure(diffPosFig);    
    subplot(nPhases,1,phaseN); hold on;
    plot((sampRange-cSample)./sampleRate,pPos-zPos,'g');
    plot((sampRange-cSample)./sampleRate,nPos-zPos,'r');
    plot(xlim(),[0 0],'Color',[.8 .8 .8]);
    maxPPosDiff(phaseN) = max(abs(pPos - zPos));
    minNPosDiff(phaseN) = max(abs(nPos - zPos));
    maxDiffPPos(phaseN) = max(abs(pPos)) - max(abs(zPos));
    minDiffNPos(phaseN) = max(abs(nPos)) - max(abs(zPos));
    
    newPowers = sqrt(mean((pTraces - mean(zTraces,2)*ones(1,size(pTraces,2))).^2,1));
    powersList((end+1):(end+length(newPowers))) = newPowers;
    meanPowers(phaseN,1) = mean(newPowers);
    phasesList((end+1):(end+length(newPowers))) = ones(length(newPowers),1).*phaseN;
    direcsList((end+1):(end+length(newPowers))) = ones(length(newPowers),1);
    newPowers = sqrt(mean((nTraces - mean(zTraces,2)*ones(1,size(nTraces,2))).^2,1));
    powersList((end+1):(end+length(newPowers))) = newPowers;
    meanPowers(phaseN,2) = mean(newPowers);
    phasesList((end+1):(end+length(newPowers))) = ones(length(newPowers),1).*phaseN;
    direcsList((end+1):(end+length(newPowers))) = -1*ones(length(newPowers),1);
    
end

figure(); hold on;
ix = find(direcsList == 1);
scatter(phasesList(ix)./nPhases*2*pi+.05,powersList(ix),'go');
plot((1:nPhases)./nPhases*2*pi,meanPowers(:,1),'g');
ix = find(direcsList == -1);
scatter(phasesList(ix)./nPhases*2*pi-.05,powersList(ix),'ro');
plot((1:nPhases)./nPhases*2*pi,meanPowers(:,2),'r');

ylabel('RMS power over sinusoid');
xlabel('Step phase');
set(gca,'XTick',(1:nPhases)/nPhases*2*pi);

figure(); hold on;
plot(maxPPosDiff,'g'); hold on;
plot(minNPosDiff,'r');
ylabel('Max( Pos - mean ) (mm)');

figure(); hold on;
plot(maxDiffPPos,'g'); hold on;
plot(minDiffNPos,'r');
ylabel('Max(Pos) - Max(mean) (mm)');

        
        
        