function correctSR(p1,p2)

baseName = ['../Data/130330/SimMix7_',p1,'p',p2,'_']
Fo = 200;
maxHarm = 7;

% Generate combinations of harmonics
harms = [0:maxHarm];
stimulusSet = [0,0];
for n=1:maxHarm+1
    f1 = harms(n);
    if n < (maxHarm+1)
        for m=(n+1):(maxHarm+1)
            f2 = harms(m);
            stimulusSet(end+1,:) = [f1,f2];
        end
    end
end

for n=0:28

    load([baseName,num2str(n),'.mat']);
    
    data.sampleRate = 20000;
    data.Fo = Fo;
    data.f1 = stimulusSet(n+1,1);
    data.f2 = stimulusSet(n+1,2);
    
    save([baseName,num2str(n),'.mat'],'data');
end
