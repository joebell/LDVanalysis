function dispSpectrum(varargin)

    data = varargin{1};
    if nargin == 2
        plotColor = varargin{2};
    else
        plotColor = 'b';
    end
    

        
    % Native mm/sec
    data.LDVvelocity = data.LDVvelocity - mean(data.LDVvelocity);
    data.LDVposition = cumsum(data.LDVvelocity)./data.sampleRate;
    % Convert to m
    data.LDVposition = data.LDVposition*10^-3;

% Test seg
%     L = length(data.LDVvelocity)/2;
%     t = ((1:L)./L)*10;
%     data.LDVposition = 10^1*rand(1,L)+(10^2).*sin(2*pi*300*t);

        posSeg = data.LDVposition;
        L = length(posSeg);
        NFFT = 2^(nextpow2(L));
        window = round(5*data.sampleRate);
        overlap = round(window*.5);
        [Pxx,f] = pwelch(posSeg,window,overlap,[],data.sampleRate);

    
    loglog(f,Pxx,'Color',plotColor); hold on;
    xlabel('F (Hz)');
    ylabel('<X^2> (nm^2/Hz)');
    plot([1 10000],[1 1].*10^-18,'k-.');
    xlim([10 1500]);
    %ylim([10^-22 10^-16]);

    