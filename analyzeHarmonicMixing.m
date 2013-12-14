function analyzeHarmonicMixing()

maxHarm = 7;
baseName = '../Data/130508/LDV130508_7_';

harms = [0:maxHarm];
stimLength = 0;
stimN = 7;
while (stimN > 0)
    stimLength = stimLength + stimN;
    stimN = stimN - 1;
end

% Calculate baseline (no stimulus mic and LDV spectra)
load([baseName,num2str(0),'.mat']);
micSig = data.mic;
L = length(micSig); Fs = data.sampleRate;
NFFT = 2^nextpow2(L);
Y = fft(micSig,NFFT)/L;
freqs = Fs/2*linspace(0,1,NFFT/2+1);
blMicAmp = 2*abs(Y(1:NFFT/2+1));
Y = fft(data.LDVvelocity,NFFT)/L;
freqs = Fs/2*linspace(0,1,NFFT/2+1);
blLDVAmp = 2*abs(Y(1:NFFT/2+1));

% For all the mixing trials
rowN = 1;
for n=(maxHarm+1):stimLength
    
    n

    load([baseName,num2str(n),'.mat']);
    
    f1 = data.f1;
    f2 = data.f2;
    
    micSig = data.mic;      
    L = length(micSig); Fs = data.sampleRate;
    NFFT = 2^nextpow2(L);
    Y = fft(micSig,NFFT)/L;
    freqs = Fs/2*linspace(0,1,NFFT/2+1);
    pairMicAmp = 2*abs(Y(1:NFFT/2+1));  
    Y = fft(data.LDVvelocity,NFFT)/L;
    freqs = Fs/2*linspace(0,1,NFFT/2+1);
    pairLDVAmp = 2*abs(Y(1:NFFT/2+1)); 
       
    load([baseName,num2str(f1),'.mat']);
    micSig = data.mic;      
    L = length(micSig); Fs = data.sampleRate;
    NFFT = 2^nextpow2(L);
    Y = fft(micSig,NFFT)/L;
    freqs = Fs/2*linspace(0,1,NFFT/2+1);
    f1MicAmp = 2*abs(Y(1:NFFT/2+1));  
    Y = fft(data.LDVvelocity,NFFT)/L;
    freqs = Fs/2*linspace(0,1,NFFT/2+1);
    f1LDVAmp = 2*abs(Y(1:NFFT/2+1));
    
    load([baseName,num2str(f2),'.mat']);
    micSig = data.mic;      
    L = length(micSig); Fs = data.sampleRate;
    NFFT = 2^nextpow2(L);
    Y = fft(micSig,NFFT)/L;
    freqs = Fs/2*linspace(0,1,NFFT/2+1);
    f2MicAmp = 2*abs(Y(1:NFFT/2+1)); 
    Y = fft(data.LDVvelocity,NFFT)/L;
    freqs = Fs/2*linspace(0,1,NFFT/2+1);
    f2LDVAmp = 2*abs(Y(1:NFFT/2+1));
    

    
    dcFactor = 30;
    micResponseMatrix(rowN+0,:) = decimate(blMicAmp,   dcFactor);
    micResponseMatrix(rowN+1,:) = decimate(f1MicAmp,   dcFactor);
    micResponseMatrix(rowN+2,:) = decimate(f2MicAmp,   dcFactor);
    micResponseMatrix(rowN+3,:) = decimate(pairMicAmp, dcFactor);
    
    LDVResponseMatrix(rowN+0,:) = decimate(blLDVAmp,   dcFactor);
    LDVResponseMatrix(rowN+1,:) = decimate(f1LDVAmp,   dcFactor);
    LDVResponseMatrix(rowN+2,:) = decimate(f2LDVAmp,   dcFactor);
    LDVResponseMatrix(rowN+3,:) = decimate(pairLDVAmp, dcFactor);
    rowN = rowN + 4;
    
    
    
end

 figure();
 %subplot(1,2,1);
 image(freqs,1:size(LDVResponseMatrix,1),(abs(LDVResponseMatrix)),'CDataMapping','scaled');
 xlim([50 2500]); hold on;
 for rowN = 0:4:size(LDVResponseMatrix,1)
     plot(xlim(),[rowN rowN]+.5,'k'); 
     plot(xlim(),[rowN rowN]+1.5,'Color',[1 1 1]*.75);
     plot(xlim(),[rowN rowN]+2.5,'Color',[1 1 1]*.75); 
     plot(xlim(),[rowN rowN]+3.5,'Color',[1 1 1]*.75); 
 end
 xlabel('Freq. (Hz)');
 colormap(flipud(bone));
 set(gca,'YTick',[]);
 
% subplot(1,2,2);
%  image(freqs,1:size(micResponseMatrix,1),(abs(micResponseMatrix)),'CDataMapping','scaled');
%  xlim([50 2500]); hold on;
%  for rowN = 0:4:size(micResponseMatrix,1)
%      plot(xlim(),[rowN rowN]+.5,'k'); 
%      plot(xlim(),[rowN rowN]+1.5,'Color',[1 1 1]*.75);
%      plot(xlim(),[rowN rowN]+2.5,'Color',[1 1 1]*.75); 
%      plot(xlim(),[rowN rowN]+3.5,'Color',[1 1 1]*.75); 
%  end
%  xlabel('Freq. (Hz)');
%  colormap(flipud(bone)); colorbar;
% set(gca,'YTick',[]);

%  figure();
%  for n=1:3:size(responseMatrix,1)
%      f1 = responseMatrix(n,:);
%      f2 = responseMatrix(n+1,:);
%      f1f2 = responseMatrix(n+2,:);
%      diffMatrix(n+2,:) = f1f2 - (f1+f2);
%  end
%  image(freqs,1:size(responseMatrix,1),diffMatrix,'CDataMapping','scaled');
%  xlim([50 2500]); hold on;
%  for rowN = 0:3:size(responseMatrix,1)
%      plot(xlim(),[rowN rowN]+.5,'w'); 
%      plot(xlim(),[rowN rowN]+1.5,'Color',[.5 .5 .5]);
%      plot(xlim(),[rowN rowN]+2.5,'Color',[.5 .5 .5]); 
%  end
%  xlabel('Freq. (Hz)');
%   caxis([-1 1]*2*10^-5);
 