function analyze1Var()

baseDir = '../Data/130521/';
baseName = 'LDV130521_20_*.mat';
VarName = 'stimAmp';
VarsName = [VarName,'s'];
analysisFreqs = [.62,1,2,3,4,5];

fileList = dir([baseDir,baseName]);
allData = [];
dataList = [];

for fileN = 1:size(fileList,1)
    
    load([baseDir,fileList(fileN).name]);
    
    data.stimAmps = [0,1*10^-4,2*10^-4,5*10^-4,...
    1*10^-3,2*10^-3,5*10^-3,...
    1*10^-2,2*10^-2,5*10^-2,...
    10^-1];
    
    Var = getfield(data,VarName);
    Vars = getfield(data,VarsName);
    VarN = dsearchn(Vars(:),Var);
    
    % Do an FFT
    input = decimate(data.LDVvelocity,10);
    sampleRate = data.sampleRate/10;    
    L = length(input); Fs = sampleRate;
    NFFT = 2^nextpow2(L);
    Y = fft(input,NFFT)/L;
    freqs = Fs/2*linspace(0,1,NFFT/2+1);
    amplitudes = 2*abs(Y(1:NFFT/2+1));
    
    for freqN = 1:length(analysisFreqs)        
        freq = data.Fo*analysisFreqs(freqN);
        ix = dsearchn(freqs',freq);
        amp = amplitudes(ix); 
        allData(VarN,freqN) = amp;
        dataList(end+1,:) = [VarN, freqN, amp];
    end
end

for n = 1:length(analysisFreqs)
    subplot(ceil(length(analysisFreqs)/2),2,n);

    %plot(log10(Vars),log10(allData(:,n)),'.-'); hold on;
    %plot((Vars(1)-5),log10(allData(1,n)),'o'); hold on;
    ix = find(dataList(:,2) == n);
    scatter(log10(Vars(dataList(ix,1))),log10(dataList(ix,3)),'.'); hold on;
    ixx = find( Vars(dataList(ix,1)) == 0);
    scatter( 0*Vars(dataList(ix(ixx),1))-5,log10(dataList(ix(ixx),3)),'o'); hold on;
    
    xlabel(VarName);
    title([num2str(analysisFreqs(n)),'F']);
end
        
