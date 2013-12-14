function spectrumThirds(data)


    L = length(data.LDVvelocity);
    
    data1 = data;
    data2 = data;
    data3 = data;
    
    data1.LDVvelocity = data1.LDVvelocity(1:round(L/3));
    data2.LDVvelocity = data2.LDVvelocity(round(L/3):round(2*L/3));
    data3.LDVvelocity = data3.LDVvelocity(round(2*L/3):end);
    
%     subplot(2,1,1);
%     dispSpectrum(data1,'r');
%     dispSpectrum(data2,'g');
%     dispSpectrum(data3,'b');
%     
%     subplot(2,1,2);
    velSpectrum(data1,'r'); 
    velSpectrum(data2,'g');
    velSpectrum(data3,'b');