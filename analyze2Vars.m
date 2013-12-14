function analyze2Vars()

baseDir = '../Data/130508/';
baseName = 'LDV130508_5_*.mat';
Var1Name = 'stimAmp1';
Vars1Name = 'stimAmps1';
Var2Name = 'stimAmp2';
Vars2Name = 'stimAmps2';
analysisFreqs = [.8,1,3.75,6.5,5,9];

fileList = dir([baseDir,baseName]);
allData = [];

for fileN = 1:size(fileList,1)
    
    load([baseDir,fileList(fileN).name]);
    
    Var1 = getfield(data,Var1Name);
    Vars1 = getfield(data,Vars1Name);
    VarN1 = dsearchn(Vars1(:),Var1);
    Var2 = getfield(data,Var2Name);
    Vars2 = getfield(data,Vars2Name);
    VarN2 = dsearchn(Vars2(:),Var2);
    
        
    % Do an FFT
    input = decimate(data.LDVvelocity,5);
    sampleRate = data.sampleRate/5;    
    L = length(input); Fs = sampleRate;
    NFFT = 2^nextpow2(L);
    Y = fft(input,NFFT)/L;
    freqs = Fs/2*linspace(0,1,NFFT/2+1);
    amplitudes = 2*abs(Y(1:NFFT/2+1));
    
    for freqN = 1:length(analysisFreqs)        
        freq = data.Fo*analysisFreqs(freqN);
        ix = dsearchn(freqs',freq);
        amp = amplitudes(ix); 
        allData(VarN2,VarN1,freqN) = amp;
    end
end

colormap(bone);
for n = 1:length(analysisFreqs)
    subplot(ceil(length(analysisFreqs)/2),2,n);
    
    quickImage(squeeze(log10(allData(:,:,n))));
    set(gca,'XTick',[1,2,5,8]);
    set(gca,'XTickLabel',log10(Vars1([1,2,5,8])));
    xlabel(['log ',Var1Name]);
    set(gca,'YTick',[1,2,5,8]);
    set(gca,'YTickLabel',log10(Vars2([1,2,5,8])));
    ylabel(['log ',Var2Name]);
    
    title([num2str(analysisFreqs(n)),'F']);
end
    