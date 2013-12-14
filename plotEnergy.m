function plotEnergy(map)

    load('../Data/131022/LDV131022_16_3.mat');
    [pos,vel,accel] = filterAccel(data);
  
    scale = -1.25;
    out.mean = 1*out.mean + scale.*out.meanStim;