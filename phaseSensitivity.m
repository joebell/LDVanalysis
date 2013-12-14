function phaseSensitivity()

baseName = '../Data/131025/LDV131025_37_';
LDVlag = 21; % Samples
nSegs = 50;

for n = 1:16
   n
   load([baseName,num2str(n),'.mat']);
   Fo = data.Fo;
   LDVvelocity = data.LDVvelocity - mean(data.LDVvelocity);
   LDVposition = cumsum(LDVvelocity)./data.sampleRate;
   for segN = 1:(nSegs-1)
       
       sampPerSeg = round(length(data.LDVvelocity)/nSegs); 
       samples = (1 + (segN-1)*sampPerSeg):((segN)*sampPerSeg);
       pos = LDVposition(samples+LDVlag);
       stim = -data.stimulus(samples);
         
       L = length(pos);
       NFFT = 2^nextpow2(L); % Next power of 2 from length of y
       Y = fft(pos,NFFT)/L;
       Ystim = fft(stim,NFFT)/L;
       f = data.sampleRate/2*linspace(0,1,NFFT/2+1);
       
       Fix = dsearchn(f',Fo);
       realPart(n,segN) = real(Y(Fix)/Ystim(Fix));
       imagPart(n,segN) = imag(Y(Fix)/Ystim(Fix));
       absPart(n,segN) = abs(Y(Fix)/Ystim(Fix));
       phasePart(n,segN) = atan2(real(Y(Fix)/Ystim(Fix)),imag(Y(Fix)/Ystim(Fix)));
       freq(n) = Fo;
   end
       
end

NaNs = 1*(1-isnan(realPart));

subplot(2,2,1);
image(realPart','CDataMapping','scaled','AlphaData',NaNs');
set(gca,'YDir','normal');
colormap(fireAndIce);
title('Real');
colorbar;
caxis([-1 1]*max(abs(caxis())));
set(gca,'XTick',[],'YTick',[]); xlabel('Freq'); ylabel('Intensity');

subplot(2,2,2);
image(imagPart','CDataMapping','scaled','AlphaData',NaNs');
set(gca,'YDir','normal');
colormap(fireAndIce);
title('Imaginary');
colorbar;
caxis([-1 1]*max(abs(caxis())));
set(gca,'XTick',[],'YTick',[]); xlabel('Freq'); ylabel('Intensity');

subplot(2,2,3);
image(absPart','CDataMapping','scaled','AlphaData',NaNs');
set(gca,'YDir','normal');
colormap(fireAndIce);
title('Norm.');
colorbar;
caxis([0 1]*max(abs(caxis())));
set(gca,'XTick',[],'YTick',[]); xlabel('Freq'); ylabel('Intensity');

subplot(2,2,4);
image(phasePart','CDataMapping','scaled','AlphaData',NaNs');
set(gca,'YDir','normal');
colormap(fireAndIce);
title('Phase');
colorbar;
caxis([-1 1]*pi);
set(gca,'XTick',[],'YTick',[]); xlabel('Freq'); ylabel('Intensity');


