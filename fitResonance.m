%function fitResonance(data)

    fitRange = [10 1500];

    % Native mm/sec
    data.LDVvelocity = data.LDVvelocity - mean(data.LDVvelocity);
    data.LDVposition = cumsum(data.LDVvelocity)./data.sampleRate;
    % Convert to nm
    data.LDVposition = data.LDVposition*10^6;
    
    posSeg = data.LDVposition;
    L = length(posSeg);
    NFFT = 2^(nextpow2(L));
    window = round(5*data.sampleRate);
    overlap = round(window*.5);
    [Pxx,f] = pwelch(posSeg,window,overlap,[],data.sampleRate);

    fStIx = dsearchn(f,fitRange(1));
    fEnIx = dsearchn(f,fitRange(2));
    
    % Data to fit
    P = Pxx(fStIx:fEnIx);
    F = f(fStIx:fEnIx);
    
    %%
    
%     ix = find((F > 112) & (F < 116));
%     P(ix) = [];
%     F(ix) = [];
%     ix = find((F > 55) & (F < 65));
%     P(ix) = [];
%     F(ix) = [];
%     ix = find((F > 73) & (F < 79));
%     P(ix) = [];
%     F(ix) = [];
%     ix = find((F > 97) & (F < 102));
%     P(ix) = [];
%     F(ix) = [];
    
    opts = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,10,0],...
               'Upper',[10^8,1500,10],...
               'StartPoint',[10^6,150,1.2]);
    LORENTZIAN = fittype( @(A, Fo, Q, x) ...
        log10(A./(((Fo./(2*pi)).^2 - (x./(2*pi)).^2).^2+(x.*Fo/(4*pi.^2*Q)).^2)),...
        'options',opts);

    fitObj = fit(F,log10(P), LORENTZIAN,...
        'Weights',1./F,'Normalize','off',...
        'Display','iter','TolFun',10^-12,'TolX',10^-12,'Robust','off')
    
    loglog(F,P,'b');
    hold on;
    Pmodel = feval(fitObj,F);
    loglog(F,10.^Pmodel,'r');
    xlim([10 1500]);


    
    
    
    
    
    
    
    
    
    
    