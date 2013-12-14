function plotPhases(f1,f2,phases)

    figure;


    
    t = 0:.01:2*pi;    
    for n=1:length(phases)
        subplot(2,1,1);
        plot(2.4*n + sin(f1*t) + sin(f2*t+phases(n)),f1*t); hold on;
        set(gca,'XTick',[]);
        subplot(2,1,2);
        scatter(2.4*n,max(sin(f1*t) + sin(f2*t+phases(n))),'bo'); hold on;
        % scatter(2.4*n,max(abs(sin(f1*t) + sin(f2*t+phases(n)))),'ro'); hold on;
        set(gca,'XTick',[]);
    end
    subplot(2,1,1);
    ylim([0 2*pi]); 
    xlabel('Harmonic phase');
    ylabel('Cycle phase');
    subplot(2,1,2);
    ylim([1 2.5]);
    ylabel('Max Ampl.');
    xlabel('Harmonic phase');
    
    
    
    