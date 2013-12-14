function backgroundNoiseExperiment(expNum)

% Log this experiment code to the directory
if ~isdir(['../Data/',datestr(now,'yymmdd'),'/'])
    mkdir(['../Data/',datestr(now,'yymmdd'),'/']);
end
experimentFileName = ['../Data/',datestr(now,'yymmdd'),'/Exp',...
                           datestr(now,'yymmdd'),'_',num2str(expNum),'.m'];
copyfile('./backgroundNoiseExperiment.m',experimentFileName);
baseName = ['../Data/',datestr(now,'yymmdd'),'/LDV',datestr(now,'yymmdd'),'_',...
    num2str(expNum),'_'];

    daqSetup();
    sampleRate = outputSampleRate;
    length = 20;

    stim = zeros(sampleRate*length,1);

    data = recLDV(stim);
    
    n = -1;
    numTaken = true;
    while (numTaken)
        n = n+1;
        a = ls([baseName,num2str(n),'.mat']);
        numTaken = (size(a,1) > 0);
    end        
    disp(['Saving: ',baseName,num2str(n),'.mat']);
    save([baseName,num2str(n),'.mat'],'data');
    
    velSpectrum(data,pretty(randi(7)));
    