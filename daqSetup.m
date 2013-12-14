%% daqSetup.m

% A configuration file to setup DAQ for rig recording

%% Reset the daq, get configuration constants.

daqreset;

overSample       = 5;    % Only oversample the inputs
inputSampleRate  = 80000;
outputSampleRate = 80000;

%% Setup input constants

ldvInput = 1;
micInput = 2;
inputList = [ldvInput, micInput];

%% configure analog input
AI = analoginput ('nidaq', 'Dev1');
addchannel (AI, inputList);
set(AI, 'SampleRate', inputSampleRate*overSample);
set(AI, 'SamplesPerTrigger', inf);
%set(AI, 'InputType', 'SingleEnded');
%set(AI, 'InputType', 'NonReferencedSingleEnded');
set(AI, 'InputType', 'Differential');
set(AI, 'TriggerType', 'Manual'); 
set(AI, 'ManualTriggerHwOn','Trigger');

%% configure analog output
AO = analogoutput ('nidaq', 'Dev1');
addchannel (AO, 0:0);
set(AO.Channel(1),'OutputRange',[-10 10]);
set(AO, 'SampleRate', outputSampleRate);
set(AO, 'TriggerType', 'Manual');

%% configure digital output
DIO = digitalio('nidaq','Dev1');
addline(DIO,0:7,'out');