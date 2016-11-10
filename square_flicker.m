function square_flicker() 
%%Initiate frequency
% Frames Period Freq. Simulated signal. 0 light. 1 dark
% [#] [ms] [Hz] [-]
% 3.0 50 .00 20.00 011
% 4.0 66.67 15.00 0011
% 5.0 83.33 12.00 00111
% 6.0 100.00 10.00 000111 
% 7.0 116.67 8.57 0001111
% 8.0 133.33 7.50 00001111
% 9.0 150.00 6.66 0000 11111

%According to the paper 1 is blackbox, 0 is white
seven_five =        [0 0 0 0 1 1 1 1];         
ten =               [0 0 0 1 1 1];
six_six =           [0 0 0 0 1 1 1 1 1];            %[0 0 1 1 1];
eight_fiveseven =   [0 0 0 1 1 1 1];%l

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

maxduration = 1000;

if nargin < 2
    frequency = 5;
end
    
 
try
    myScreen = max(Screen('Screens'));
    %Priority(0);
    %myScreen = 2;
    [win,winRect] =   Screen(myScreen,'OpenWindow',[],[0 0 900 900]);
        
    [width, height] = RectSize(winRect);
    
    % Background color dark green, just to make sure
    Screen('FillRect',win,[0 127 0]);
    %%Make movie 
    targetWidth = 100;
    targetHeight = 100;
    % make textures clipped to screen size
    % Draw texture to screen: Draw 16 states or texture depens on the value of
    screenMatrix = flickerTexture(width, height, targetWidth, targetHeight);
    for  i =1:16 
    texture(i) = Screen('MakeTexture', win, uint8(screenMatrix{i})*255);
    end
    
   
    % Define refresh rate.
    ifi = Screen('GetFlipInterval', win);
    
   %Run in this duration
  deadline = GetSecs + maxduration;
        
    % Preview texture briefly before flickering
    % n.b. here we draw to back buffer
    Screen('DrawTexture',win,texture(16)); 
    VBLTimestamp = Screen('Flip', win, ifi);
    WaitSecs(2);
    
    % loop swapping buffers, checking keyboard, and checking time
    % param 2 denotes "dont clear buffer on flip", i.e., we alternate
    % our buffers cum textures
    indexflip = 1;
    % textureValue =0;    
    halfifi = 0.5*ifi;
    vbl =0; 
%% Start looping movie   
    Priority(1);
    while (~KbCheck) && (GetSecs < deadline)
    % Drawing
    %Compute texture value based on display value from freq long matrixes
    textureValue = freqCombine(:, indexflip) .* [1; 2; 4; 8];   
    textureValue = textureValue(4)+textureValue(3)+textureValue(2)+ textureValue(1) +1;
    %Draw it on the back buffer
    Screen('DrawTexture',win,texture(textureValue)); 
    %Display current index
    %Screen('DrawText', win, num2str(indexflip),400,400, 255);
    %Tell PTB no more drawing commands will be issued until the next flip
    Screen('DrawingFinished', win);
    % Fliping     
    %Screen('Flip', win, vbl + halfifi);
    %Flip ASAP
    Screen('Flip', win);
    indexflip = indexflip+1;
    
    %Reset index at the end of freq matrix
        if indexflip > lcmFreq
            indexflip = 1;
            %disp('over');
        end
    end 
    Priority(0); 
    frame_duration = Screen('GetFlipInterval', win);
    Screen('CloseAll');
    Screen('Close');

catch
    Screen('CloseAll');
    Screen('Close');
    psychrethrow(psychlasterror);

end