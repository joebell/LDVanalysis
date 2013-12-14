function phasePlots()

    fileToTest = '../Data/130508/LDV130508_8_6.mat';
    load(fileToTest);
    
    timeRange = [1.95 3.35]; % Seconds

    [pos,vel,accel] = filterAccel(data);
    
   
    
    pos = pos(round(timeRange(1)*data.sampleRate):round(timeRange(2)*data.sampleRate));
    vel = vel(round(timeRange(1)*data.sampleRate):round(timeRange(2)*data.sampleRate));
    accel = accel(round(timeRange(1)*data.sampleRate):round(timeRange(2)*data.sampleRate));
    
    figure();
    plot([1:length(pos)]./data.sampleRate,pos/std(pos),'b'); hold on;
    %plot([1:length(vel)]./data.sampleRate,vel/std(vel),'m'); hold on;
    %plot([1:length(accel)]./data.sampleRate,accel/std(accel),'r'); hold on;
    
    
    figure();
    subplot(1,2,1);
    plot(pos,vel);
    subplot(1,2,2);
    plot(pos,accel);