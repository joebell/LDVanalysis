function phaseSnips(data)

tStart = [6:.5:8]*10^5;
tWin   = .05*10^5;

pos = data.LDVposition;
vel = data.LDVvelocity;
[pos,vel,accel] = filterAccel(data);

for n=1:length(tStart)
    times = round([0:tWin]+tStart(n));
    plot(pos(times),vel(times),'Color',pretty(9-n)); 
    hold on;
end

xlabel('X (mm)')
ylabel('dX/dT (mm/sec)');