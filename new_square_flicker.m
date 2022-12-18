%%Initiate frequency
% Frames Period Freq. Simulated signal. 0 light. 1 dark
% [#] [ms] [Hz] [-] 
% 3.0 50 .00 20.00 011
% 4.0 66.67  15.00 0011
% 5.0 83.33  12.00 00111
% 6.0 100.00 10.00 000111 
% 7.0 116.67 8.57  0001111
% 8.0 133.33 7.50  00001111  
% 9.0 150.00 6.66  000011111
       
%According to the paper 1 is blackbox, 0 is white
seven_five =        [0 0 0 0 1 1 1 1];         
ten =               [0 0 0 1 1 1];
six_six =           [0 0 0 0 1 1 1 1 1];
eight_fiveseven =   [0 0 0 1 1 1 1];
       
% initiate freq table
freq{1} = six_six;   %4/8
freq{2} = seven_five;    %3/6
freq{3} = eight_fiveseven; %3/5
freq{4} = ten; %4/7

%%Generate display matrixes for movies
% Find LCM of freq matrix to create equal matrixes for all freqs 
lcmFreq = lcms([length(freq{1}),length(freq{2}),length(freq{3}),length(freq{4})]);

%Generate full movie matrix of frequency 
for i=1:4
freqCombine(i,:) = repmat(freq{i},1,lcmFreq/length(freq{i})); 
end
%Revert value because in Matlab 255 is white and 0 is black
freqCombine = 1 - freqCombine;
      
    
scenario_without_trigger(freqCombine,lcmFreq)
%scenario_0(freqCombine,lcmFreq)
