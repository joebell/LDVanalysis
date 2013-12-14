function sweepSpectrograms()

%baseName = '../Data/130308/LDV130308_25_';
baseName = '../Data/130321/LDV130321_6_';
%baseName = '../Data/130318/SimAmpSweep_100_';
%baseName = '../Data/130318/SimMix50_1_';
Ns = 1:2;

for Nn = 1:length(Ns)
    n = Ns(Nn);
    load([baseName,num2str(n),'.mat']);
    
    %data.LDVvelocity = decimate(data.LDVvelocity,5);
    
    subplot(length(Ns),1,Nn);
    spectrogram(data.LDVvelocity,2^9,2^8,2^10,20000,'yaxis'); ylim([0 2500]);
end