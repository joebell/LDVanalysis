function analyzeHarmonicMixing2()

maxHarm = 7;
nStims = 28;
baseName = '../Data/130330/SimMix7_500p100_';
nPerPage = 1;

for m = [7,13]
figure();
for n = 1:nPerPage
    
    baseOffset = 7+(m-1)*nPerPage;
       
    load([baseName,num2str(0),'.mat']);
    subplot(nPerPage,2,(n-1)*2+1); 
    spectrum(data.LDVvelocity*10^3,data.sampleRate,'k');
    subplot(nPerPage,2,(n-1)*2+2);
    spectrum(data.mic,data.sampleRate,'k');
    
    load([baseName,num2str(n+baseOffset),'.mat']);   
    f1 = data.f1
    f2 = data.f2

    
    load([baseName,num2str(f1),'.mat']);   
    subplot(nPerPage,2,(n-1)*2+1); 
    spectrum(data.LDVvelocity*10^3,data.sampleRate,'b');
    subplot(nPerPage,2,(n-1)*2+2);
    spectrum(data.mic,data.sampleRate,'b');
    
    load([baseName,num2str(f2),'.mat']);   
    subplot(nPerPage,2,(n-1)*2+1); 
    spectrum(data.LDVvelocity*10^3,data.sampleRate,'g');
    subplot(nPerPage,2,(n-1)*2+2);
    spectrum(data.mic,data.sampleRate,'g');
    
    load([baseName,num2str(n+baseOffset),'.mat']); 
    subplot(nPerPage,2,(n-1)*2+1); 
    spectrum(data.LDVvelocity*10^3,data.sampleRate,'r');
    subplot(nPerPage,2,(n-1)*2+2);
    spectrum(data.mic,data.sampleRate,'r');
    
    pause(.1);
    
    subplot(nPerPage,2,(n-1)*2+1); 
    ylim([10^-3 10^2]);
    subplot(nPerPage,2,(n-1)*2+2);
    ylim([10^-2 10^2]);
end

end
  
 