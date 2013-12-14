function correctSRS()

p1s = [20,50,100,200,500];
p2s = [100,115,140,170,200];

for p1N = 1:length(p1s)
    p1 = num2str(p1s(p1N));
    for p2N = 1:length(p2s);
        p2 = num2str(p2s(p2N));
        
        correctSR(p1,p2);
    end
end