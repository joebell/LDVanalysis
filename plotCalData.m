function plotCalData()

load('calData.mat');

for aN = 1:10
    fN = 1:20;
    
    fs = logspace(log10(50),log10(2000),20);
    semilogx(fs(fN),calData((fN-1)*10+aN,3)); hold on;
end
    
        
        