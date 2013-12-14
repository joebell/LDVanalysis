function fluctuationDissipationTheorem()

load('../Data/131025/LDV131025_23_1.mat');
Flist = data.Fo;
%compData = makeCompositeData('../Data/131028/LDV131028_4_',[1:30]);
compData = data;
Z = linearResponseFunction(compData); % in m/N
forcedResp = extractPSD(compData,Flist);

figure;

% Get free response from each free epoch in the file, average
totalFree = data; totalFree.LDVvelocity = [];
for freeStartN=1:length(data.freeStartSamples)
    subData = data;
    subData.LDVvelocity = data.LDVvelocity(data.freeStartSamples(freeStartN):data.freeStopSamples(freeStartN));
    freeResps(freeStartN,:) = extractPSD(subData,Flist);
    totalFree.LDVvelocity = [totalFree.LDVvelocity;subData.LDVvelocity];
end
freeResp = mean(freeResps,1);

% Get total forced response 
totalForced = data; totalForced.LDVvelocity = [];
for startN=1:length(data.startSamples)
    subSeg = data.LDVvelocity(data.startSamples(startN):data.stopSamples(startN));
    totalForced.LDVvelocity = [totalForced.LDVvelocity;subSeg];
end

subplot(2,2,1);
    velSpectrum(totalFree,'k');
    velSpectrum(totalForced,'b');
    title('Velocity Power Spectra');
    xlim([10 2000]); hold on;
    xlabel('Hz');
    
subplot(2,2,2);
    loglog(Flist,forcedResp,'bo-'); hold on;
    loglog(Flist,freeResp,'ko-');
    xlim([10 2000]); hold on;
    title('Measurement Pos. Power Spectra');
    ylabel('m^2/Hz');
    xlabel('Hz');

subplot(2,2,3);
    semilogx(Flist,10^-3*real(Z),'b'); hold on;
    semilogx(Flist,10^-3*imag(Z),'g');
    semilogx(Flist,10^-3*abs(Z),'m');
    title('Linear Response {\color{blue}Real\color{black}, \color{green}Imag.}\color{black}, and \color{magenta}Norm.')
    xlim([10 2000]); hold on;
    ylabel('(nm/pN)');
    plot(xlim(),[0 0],'k-.');
    xlabel('Hz');
    
subplot(2,2,4);
    kB = 1.3806*10^-23;
    Teff = (293*kB*imag(Z))./(pi*Flist.*freeResp);
    semilogx(Flist,Teff,'bo-');
    xlim([10 2000]); hold on;
    plot(xlim(),[0 0],'k-.');
    plot(xlim(),[1 1],'k-.');
    ylabel('T/Teff');
    xlabel('Hz');
