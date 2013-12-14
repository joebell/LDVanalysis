function analyzeForceSteps(data, plotColor)

    for powerN =   length(data.powers);
        
        ix = find(data.powerNs == powerN);
        vel = data.LDVvelocity(data.startSamples(ix(1)):data.stopSamples(ix(1)));
        for ixN = 2:length(ix)           
            vel = vel + data.LDVvelocity(data.startSamples(ix(ixN)):data.stopSamples(ix(ixN)));
        end
        vel = vel./length(ix);
        
        pos = cumsum(vel)./data.sampleRate;
        accel = [diff(vel).*data.sampleRate;0];
        
        plot([1:length(vel)]./data.sampleRate,vel,plotColor); hold on;
        pause(.25)
        
%         power = data.powers(powerN);
%         amp   = pos(end);
%         logPower = log10(abs(data.powers(powerN)));
%         logAmp = log10(abs(pos(end)));
%         
%         scatter(powerN, logAmp); hold on;
%         pause(.25)
    end