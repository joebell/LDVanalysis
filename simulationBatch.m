function simulationBatch(stimulus, stimN,stimAmp,addedNoise)

    baseName = ['SimMix7_',num2str(stimAmp),'p',num2str(addedNoise),'_'];
    
    load('accelModel.mat');   % Uses 'model'
    batchFile = [baseName,'SimBatch.mat'];
    
    daqSetup();
    aExp.stimulus   = stimulus;
    aExp.sampleRate = inputSampleRate;
    aExp.model      = model;
    aExp.baseName   = baseName;
    aExp.N          = stimN;
    
    if exist(batchFile)
        load(batchFile);
        experiment(end+1) = aExp;
    else
        experiment(1) = aExp;
    end
    
    save(batchFile,'experiment');