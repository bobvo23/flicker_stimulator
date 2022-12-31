%% Scenario 2
% start
% flicker frequency_4 for flicker_time
% continue after rest_time for rest purpose
% flicker frequency_3 for flicker_time
% continue after rest_time for rest purpose
% flicker frequency_2 for flicker_time
% continue after rest_time for rest purpose
% flicker frequency_1 for flicker_time
% continue after rest_time for rest purpose
% continue the above process for the value of repeat_all 

function scenario_2(freqCombine,lcmFreq)
    
    %Set user rest time
    rest_time=6;

    %Set flicker time
    flicker_time=4;

    %Set repeat
    repeat_all=2;

    % full screen
    full_screen=0; % 1 for full screen, 0 for other

    %%% set trigger 
    SendTrigger=1;
    if SendTrigger==1
       ioObj = io64;
       status = io64(ioObj);
       address = hex2dec('3FD8'); %standard LPT1 output port address
    end
    
    try
        %%%% Screen('Preference', 'SkipSyncTests', 1);
        myScreen = max(Screen('Screens'));

        if full_screen == 1
            [win,winRect] = Screen(myScreen,'OpenWindow'); %% full screen
        else
            [win,winRect] =   Screen(myScreen,'OpenWindow',[],[0 0 1200 1200]);
        end
                    
        [width, height] = RectSize(winRect);
        
        % Background color dark green, just to make sure
        Screen('FillRect',win,[0 127 0]);

        %%Make movie 
        targetWidth = 300;
        targetHeight = 300;

        % make textures clipped to screen size
        % Draw texture to screen: Draw 16 states or texture depens on the value of
        screenMatrix = flickerTexture(width, height, targetWidth, targetHeight);
        for  i =1:16 
        texture(i) = Screen('MakeTexture', win, uint8(screenMatrix{i})*255);
        end
               
        % Define refresh rate.
        ifi = Screen('GetFlipInterval', win);
        
            
        % Preview texture briefly before flickering
        % n.b. here we  draw to back buffer
        %%%%% Screen('DrawTexture',win,texture(16)); 
        VBLTimestamp = Screen('Flip', win, ifi);

        % Define keyboard keys    
        KbName('UnifyKeyNames');      
        escKey = KbName('ESCAPE');
        
        % repeat process
        for k = 1:repeat_all;
         
        pwd % current folder address

        % set trigger to 0
        io64(ioObj,address,0);

        % continue after rest_time for rest purpose
        WaitSecs(rest_time-1);
        
        % show image for 1 second
        Start = imread([pwd, '/','start_after_1_sec.png']);

        Eyeopen_toScreen = Screen('MakeTexture',win,Start);
        Screen('FillRect',win);
        Screen('DrawTexture', win, Eyeopen_toScreen);
        Screen('Flip',win);
        WaitSecs(1);


        % set trigger to 4
        io64(ioObj,address,4);

        % loop swapping buffers, checking keyboard, and checking time
        % param 2 denotes "dont clear buffer on flip", i.e., we alternate
        % our buffers cum textures
        indexflip = 1;
        % textureValue =0;    
        halfifi = 0.5*ifi;
        vbl =0;
        
        %% Start looping movie   
        Priority(1);
        [keyIsDown, secs, keyCode] = KbCheck;
        
        % flicker target 4
        time = clock;
        while (etime(clock, time) < flicker_time) && ~keyCode(escKey)

        % Drawing
        %Compute texture value based on display value from freq long matrixes
        textureValue = freqCombine(:, indexflip) .* [1; 2; 4; 8];

        % flicker 4 targets
        %%%%%%% textureValue = textureValue(4)+textureValue(3)+textureValue(2)+ textureValue(1) +1;

        % flicker only one target
        textureValue = textureValue(4) + 1;

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
            end    
            
            [keyIsDown, secs, keyCode] = KbCheck;
            disp('pass 1');
        end

        % set trigger to 0    
        io64(ioObj,address,0);
    
        % continue after rest_time for rest purpose
        WaitSecs(rest_time-1);
        
        % show image for 1 second
        Start = imread([pwd, '/','start_after_1_sec.png']);

        Eyeopen_toScreen = Screen('MakeTexture',win,Start);
        Screen('FillRect',win);
        Screen('DrawTexture', win, Eyeopen_toScreen);
        Screen('Flip',win);
        WaitSecs(1);
    
        % set trigger to 4
        io64(ioObj,address,6);
        
        % flicker target 3
        time = clock;
        while (etime(clock, time) < flicker_time) && ~keyCode(escKey)
        % Drawing
        %Compute texture value based on display value from freq long matrixes
        textureValue = freqCombine(:, indexflip) .* [1; 2; 4; 8];   
        
        % flicker only one target
        textureValue = textureValue(3) + 1;

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
            end    
            
            [keyIsDown, secs, keyCode] = KbCheck;
            disp('pass 2');
        end
    
        % set trigger to 0  
        io64(ioObj,address,0);
    
        % continue after rest_time for rest purpose
        WaitSecs(rest_time-1);
        
        % show image for 1 second
        Start = imread([pwd, '/','start_after_1_sec.png']);

        Eyeopen_toScreen = Screen('MakeTexture',win,Start);
        Screen('FillRect',win);
        Screen('DrawTexture', win, Eyeopen_toScreen);
        Screen('Flip',win);
        WaitSecs(1);
        
        % set trigger to 8
        io64(ioObj,address,8);

        % flicker target 2
        time = clock;
        while (etime(clock, time) < flicker_time) && ~keyCode(escKey)
        % Drawing
        %Compute texture value based on display value from freq long matrixes
        textureValue = freqCombine(:, indexflip) .* [1; 2; 4; 8];
        
        % flicker only one target
        textureValue = textureValue(2) + 1;

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
            
            [keyIsDown, secs, keyCode] = KbCheck;
            disp('pass 3');
        end

        % set trigger to 0  
        io64(ioObj,address,0);
        
        % continue after rest_time for rest purpose
        WaitSecs(rest_time-1);
        
        % show image for 1 second
        Start = imread([pwd, '/','start_after_1_sec.png']);

        Eyeopen_toScreen = Screen('MakeTexture',win,Start);
        Screen('FillRect',win);
        Screen('DrawTexture', win, Eyeopen_toScreen);
        Screen('Flip',win);
        WaitSecs(1);
     
        % set trigger to 10
        io64(ioObj,address,10);

        % flicker target 1
        time = clock;
        while (etime(clock, time) < flicker_time) && ~keyCode(escKey)
        % Drawing
        %Compute texture value based on display value from freq long matrixes
        textureValue = freqCombine(:, indexflip) .* [1; 2; 4; 8];   

        % flicker only one target
        textureValue = textureValue(1) + 1;

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
            end    
            
            [keyIsDown, secs, keyCode] = KbCheck;
            disp('pass 4');
        end

        % set trigger to 0       
        io64(ioObj,address,0);   %output command    
     
            
        % continue after rest_time for rest purpose
        WaitSecs(rest_time-1);
        
        % show image for 1 second
        Start = imread([pwd, '/','end_after_1_sec.png']);

        Eyeopen_toScreen = Screen('MakeTexture',win,Start);
        Screen('FillRect',win);
        Screen('DrawTexture', win, Eyeopen_toScreen);
        Screen('Flip',win);
        WaitSecs(1);
    
        Priority(0); 
        frame_duration = Screen('GetFlipInterval', win);
        k = k+1;
        end
    catch
        Screen('CloseAll');
        Screen('Close');
        psychrethrow(psychlasterror);
    end

Screen('CloseAll');
Screen('Close');