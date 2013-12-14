function falseSpectrogram()

baseName = '../Data/131029/LDV131029_2_';
numbers = [0:80];
% powerList = [50,25,25,25,25,30,35,40,40,40,30,30,30,30,40,40,40,40,...
%     45,45,45,45,45,   50,50,50,50,   30,30,30];
%powerList = [30,30,30,30,   40,40,40,40,40,40,40,  40,40,40,40,40,40,40];
%powerList = [25,25,25,   30,30,30,30,  35,35,35,35,35,35];
powerList([0:3]+1) = 0;
powerList([4:6]+1) = 5;
powerList([7:9]+1) = 10;
powerList([10:12]+1) = 15;
powerList([13:15]+1) = 20;
powerList([16:18]+1) = 25;
powerList([19:28]+1) = 30;
powerList([29:33]+1) = 35;
powerList([34:44]+1) = 40;
powerList([45:52]+1) = 45;
powerList([53:60]+1) = 50;
powerList([61:67]+1) = 45;
powerList([68:74]+1) = 30;
powerList([75:80]+1) = 45;

freqRange = [50 1250];


for expNn = 1:length(numbers)
    
    expN = numbers(expNn)
    
    load([baseName,num2str(expN),'.mat']);
    [Pxx,f] = velSpectrum(data,'b','plotOff');
    fix1 = dsearchn(f,freqRange(1));
    fix2 = dsearchn(f,freqRange(2));
    
    allPowers(expNn,:) = Pxx(fix1:fix2);
    
end

subplot(4,1,1:3);
image(numbers,f(fix1:fix2),log10(allPowers'),'CDataMapping','scaled');
set(gca,'YDir','normal','YScale','linear');
ylim(freqRange); title('Log10(power)');
lims = xlim();
ylabel('Freq. (Hz)');

subplot(4,1,4);
bar(numbers,powerList);
ylabel('V');
xlabel('Exp. #');
ylim([.8*min(powerList) 1.2*max(powerList)]);
xlim(lims);

    