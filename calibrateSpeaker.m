function calData = calibrateSpeaker(fRange, targetPower)

daqSetup;

precision      = .01;    % How close to require matching
approachFactor = .25;    % How quickly to converge
toneTime       =   2;    % Seconds

calFactor = 10; % Starting cal factor
calData = [];
t = 0:(1/outputSampleRate):toneTime;

for f = fRange
    baseStim = sin(2*pi*f*t);
    
    actualPower = 0;
    m = 0;
    
    while ((abs(actualPower/targetPower - 1) > precision)&(m < 30))
        
        stimulus = targetPower*calFactor*sin(2*pi*f*t);
        data = recLDV(stimulus');
        micSig = data.mic;
        Fs = data.sampleRate;
        clear data;
        
        L = length(micSig);
        NFFT = 2^nextpow2(L);
        Y = fft(micSig,NFFT)/L;
        freqs = Fs/2*linspace(0,1,NFFT/2+1);
        % Plot single-sided amplitude spectrum.
        loglog(freqs,2*abs(Y(1:NFFT/2+1))); hold on;
        scatter(f,targetPower,'or'); hold off;
        xlim([40 2200]);
        ix = dsearchn(freqs',f);
        actualPower = 2*abs(Y(ix));
        ix = dsearchn(freqs',3*f);
        F3power = 2*abs(Y(ix));
        
        disp(['Fo: ',num2str(f),' Target: ',num2str(targetPower),' @f: ',num2str(actualPower),...
            ' @3f: ',num2str(F3power),' cal: ',num2str(calFactor)]);
        
        if abs(actualPower/targetPower - 1) > precision
            calFactor = abs(calFactor*(1 - (actualPower/targetPower - 1)*approachFactor));
            m = m + 1;
        end
    end
    
    calData(end+1,:) = [f,targetPower,abs(calFactor),F3power];
    disp(['Fixed at: ',num2str(calFactor),' after ',...
        num2str(m),' cycles']);
    
end
