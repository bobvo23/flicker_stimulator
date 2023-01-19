%% Scenario 3
% start
% flicker frequency_4 or random target for random_flicker_time
% continue after random_rest_time for rest purpose
% flicker frequency_4 or random target for random_flicker_time
% continue after random_rest_time for rest purpose
% flicker frequency_4 or random target for random_flicker_time
% continue after random_rest_time for rest purpose
% flicker frequency_4 or random target for random_flicker_time
% continue after random_rest_time for rest purpose
% continue the above process for the value of repeat_all

function scenario_3(freqCombine, lcmFreq)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SET TEST PARAMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Set user rest time
    random_rest_time_enable = 0;

    if (random_rest_time_enable == 1)
        rest_time = [1:6];
        random_rest_time = randsample(rest_time, size(rest_time, 2));
    else
        rest_time = 6;
        random_rest_time = rest_time;
    end

    %Set flicker time
    random_flicker_time_enable = 0;

    if (random_flicker_time_enable == 1)
        flicker_time = [1:5];
        random_flicker_time = randsample(flicker_time, size(flicker_time, 2));
    else
        flicker_time = 4;
        random_flicker_time = flicker_time;
    end

    % do you want to show target in random order!
    random_target_enable = 1

    if (random_target_enable == 1)
        random_target = randsample([1:4], 4);
    end

    %Set repeat
    repeat_all = 1;

    % full screen
    full_screen = 0; % 1 for full screen, 0 for other

    %%% set trigger
    SendTrigger = 1;
    if SendTrigger==1
       ioObj = io64;
       status = io64(ioObj);
       address = hex2dec('3FD8'); %standard LPT1 output port address
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% END SET TEST PARAMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN TRY CATCH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    try
        %%%% Screen('Preference', 'SkipSyncTests', 1);
        myScreen = max(Screen('Screens'));

        if full_screen == 1
            [win, winRect] = Screen(myScreen, 'OpenWindow'); % % full screen
        else
            [win, winRect] = Screen(myScreen, 'OpenWindow', [], [0 0 600 600]);
        end

        [width, height] = RectSize(winRect);

        % Background color dark green, just to make sure
        Screen('FillRect', win, [0 127 0]);

        %%Make movie
        targetWidth = 300;
        targetHeight = 300;

        % make textures clipped to screen size
        % Draw texture to screen: Draw 16 states or texture depens on the value of
        screenMatrix = flickerTexture(width, height, targetWidth, targetHeight);

        for i = 1:16
            texture(i) = Screen('MakeTexture', win, uint8(screenMatrix{i}) * 255);
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
        for k = 1:repeat_all

            % for in rest time
            for kk = 1:size(random_rest_time, 2)

                % for in flicker time
                for jj = 1:size(random_flicker_time, 2)

                    flicker_time = random_flicker_time(jj);
                    rest_time = random_rest_time(kk);

                    disp(["flicker time is: ", num2str(flicker_time)]);
                    disp(["rest time is: ", num2str(rest_time)]);
                    pwd % current folder address

                    % set trigger to 0
                    io64(ioObj,address,0);

                    % show image for 1 second
                    Start = imread([pwd, '/', 'start_after_1_sec.png']);

                    Eyeopen_toScreen = Screen('MakeTexture', win, Start);
                    Screen('FillRect', win);
                    Screen('DrawTexture', win, Eyeopen_toScreen);
                    Screen('Flip', win);

                    if rest_time ~= 1
                        WaitSecs(1);
                    end

                    % loop swapping buffers, checking keyboard, and checking time
                    % param 2 denotes "dont clear buffer on flip", i.e., we alternate
                    % our buffers cum textures
                    indexflip = 1;
                    % textureValue =0;
                    halfifi = 0.5 * ifi;
                    vbl = 0;

                    %% Start looping movie
                    Priority(1);
                    [keyIsDown, secs, keyCode] = KbCheck;

                    % flicker target 4
                    time = clock;

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SHOWING TARGET 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    while (etime(clock, time) < flicker_time) && ~keyCode(escKey)

                        % Drawing
                        %Compute texture value based on display value from freq long matrixes
                        textureValue = freqCombine(:, indexflip) .* [1; 2; 4; 8];

                        % flicker 4 targets
                        %%%%%%% textureValue = textureValue(4)+textureValue(3)+textureValue(2)+ textureValue(1) +1;

                        % flicker only one target with random or none random
                        if (random_target_enable == 0)
                            textureValue = textureValue(4) + 1;
                            % set trigger to 4
                            trigger_value = 4;
                            io64(ioObj,address,trigger_value);
                        else
                            textureValue = textureValue(random_target(4)) + 1;

                            % select trigger value (4+1 for 6.66Hz, 6+1 for 7.50Hz, 8+1 for 8.57Hz, 10+1 for 10Hz)
                            %%% In our EEG recorder system, base trigger value is 1, when we set trigger value to 4, it save 4 + 1
                            %%% then for 6.66Hz ---> trigger value is 5
                            %%% then for 7.50Hz ---> trigger value is 7
                            %%% then for 8.57Hz ---> trigger value is 9
                            %%% then for 10Hz ---> trigger value is 11
                            switch random_target(4)
                                case 4
                                    % set trigger to 4
                                    trigger_value = 4;
                                    io64(ioObj,address,trigger_value);
                                case 3
                                    % set trigger to 6
                                    trigger_value = 6;
                                    io64(ioObj,address,trigger_value);
                                case 2
                                    % set trigger to 8
                                    trigger_value = 8;
                                    io64(ioObj,address,trigger_value);
                                otherwise
                                    % set trigger to 10
                                    trigger_value = 10;
                                    io64(ioObj,address,trigger_value);
                            end

                        end

                        disp(['Trigger value is: ', num2str(trigger_value)])

                        %Draw it on the back buffer
                        Screen('DrawTexture', win, texture(textureValue));

                        %Display current index
                        %Screen('DrawText', win, num2str(indexflip),400,400, 255);
                        %Tell PTB no more drawing commands will be issued until the next flip
                        Screen('DrawingFinished', win);

                        % Fliping
                        %Screen('Flip', win, vbl + halfifi);

                        %Flip ASAP
                        Screen('Flip', win);
                        indexflip = indexflip + 1;

                        %Reset index at the end of freq matrix
                        if indexflip > lcmFreq
                            indexflip = 1;
                        end

                        [keyIsDown, secs, keyCode] = KbCheck;
                    end

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% END SHOWING TARGET 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % set trigger to 0
                    io64(ioObj,address,0);

                    % show image for 1 second
                    Start = imread([pwd, '/', 'start_after_1_sec.png']);

                    Eyeopen_toScreen = Screen('MakeTexture', win, Start);
                    Screen('FillRect', win);
                    Screen('DrawTexture', win, Eyeopen_toScreen);
                    Screen('Flip', win);

                    if rest_time ~= 1
                        WaitSecs(1);
                    end

                    % flicker target 3
                    time = clock;

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SHOWING TARGET 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    while (etime(clock, time) < flicker_time) && ~keyCode(escKey)
                        % Drawing
                        %Compute texture value based on display value from freq long matrixes
                        textureValue = freqCombine(:, indexflip) .* [1; 2; 4; 8];

                        % flicker only one target with random or none random
                        if (random_target_enable == 0)
                            textureValue = textureValue(3) + 1;
                            % set trigger to 6
                            trigger_value = 6;
                            io64(ioObj,address,trigger_value);
                        else
                            textureValue = textureValue(random_target(3)) + 1;

                            % select trigger value (4+1 for 6.66Hz, 6+1 for 7.50Hz, 8+1 for 8.57Hz, 10+1 for 10Hz)
                            %%% In our EEG recorder system, base trigger value is 1, when we set trigger value to 4, it save 4 + 1
                            %%% then for 6.66Hz ---> trigger value is 5
                            %%% then for 7.50Hz ---> trigger value is 7
                            %%% then for 8.57Hz ---> trigger value is 9
                            %%% then for 10Hz ---> trigger value is 11
                            switch random_target(3)
                                case 4
                                    % set trigger to 4
                                    trigger_value = 4;
                                    io64(ioObj,address,trigger_value);
                                case 3
                                    % set trigger to 6
                                    trigger_value = 6;
                                    io64(ioObj,address,trigger_value);
                                case 2
                                    % set trigger to 8
                                    trigger_value = 8;
                                    io64(ioObj,address,trigger_value);
                                otherwise
                                    % set trigger to 10
                                    trigger_value = 10;
                                    io64(ioObj,address,trigger_value);
                            end

                        end

                        disp(['Trigger value is: ', num2str(trigger_value)])

                        %Draw it on the back buffer
                        Screen('DrawTexture', win, texture(textureValue));

                        %Display current index
                        %Screen('DrawText', win, num2str(indexflip),400,400, 255);
                        %Tell PTB no more drawing commands will be issued until the next flip
                        Screen('DrawingFinished', win);

                        % Fliping
                        %Screen('Flip', win, vbl + halfifi);

                        %Flip ASAP
                        Screen('Flip', win);
                        indexflip = indexflip + 1;

                        %Reset index at the end of freq matrix
                        if indexflip > lcmFreq
                            indexflip = 1;
                        end

                        [keyIsDown, secs, keyCode] = KbCheck;
                    end

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% EDN SHOWING TARGET 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % set trigger to 0
                    io64(ioObj,address,0);

                    % show image for 1 second
                    Start = imread([pwd, '/', 'start_after_1_sec.png']);

                    Eyeopen_toScreen = Screen('MakeTexture', win, Start);
                    Screen('FillRect', win);
                    Screen('DrawTexture', win, Eyeopen_toScreen);
                    Screen('Flip', win);

                    if rest_time ~= 1
                        WaitSecs(1);
                    end

                    % flicker target 2
                    time = clock;

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SHOWING TARGET 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    while (etime(clock, time) < flicker_time) && ~keyCode(escKey)
                        % Drawing
                        %Compute texture value based on display value from freq long matrixes
                        textureValue = freqCombine(:, indexflip) .* [1; 2; 4; 8];

                        % flicker only one target with random or none random
                        if (random_target_enable == 0)
                            textureValue = textureValue(2) + 1;
                            % set trigger to 8
                            trigger_value = 8;
                            io64(ioObj,address,trigger_value);
                        else
                            textureValue = textureValue(random_target(2)) + 1;

                            % select trigger value (4+1 for 6.66Hz, 6+1 for 7.50Hz, 8+1 for 8.57Hz, 10+1 for 10Hz)
                            %%% In our EEG recorder system, base trigger value is 1, when we set trigger value to 4, it save 4 + 1
                            %%% then for 6.66Hz ---> trigger value is 5
                            %%% then for 7.50Hz ---> trigger value is 7
                            %%% then for 8.57Hz ---> trigger value is 9
                            %%% then for 10Hz ---> trigger value is 11
                            switch random_target(2)
                                case 4
                                    % set trigger to 4
                                    trigger_value = 4;
                                    io64(ioObj,address,trigger_value);
                                case 3
                                    % set trigger to 6
                                    trigger_value = 6;
                                    io64(ioObj,address,trigger_value);
                                case 2
                                    % set trigger to 8
                                    trigger_value = 8;
                                    io64(ioObj,address,trigger_value);
                                otherwise
                                    % set trigger to 10
                                    trigger_value = 10;
                                    io64(ioObj,address,trigger_value);
                            end

                        end

                        disp(['Trigger value is: ', num2str(trigger_value)])

                        %Draw it on the back buffer
                        Screen('DrawTexture', win, texture(textureValue));

                        %Display current index
                        %Screen('DrawText', win, num2str(indexflip),400,400, 255);

                        %Tell PTB no more drawing commands will be issued until the next flip
                        Screen('DrawingFinished', win);

                        % Fliping
                        %Screen('Flip', win, vbl + halfifi);

                        %Flip ASAP
                        Screen('Flip', win);
                        indexflip = indexflip + 1;

                        %Reset index at the end of freq matrix
                        if indexflip > lcmFreq
                            indexflip = 1;
                            %disp('over');
                        end

                        [keyIsDown, secs, keyCode] = KbCheck;
                    end

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% END SHOWING TARGET 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % set trigger to 0
                    io64(ioObj,address,0);

                    % show image for 1 second
                    Start = imread([pwd, '/', 'start_after_1_sec.png']);

                    Eyeopen_toScreen = Screen('MakeTexture', win, Start);
                    Screen('FillRect', win);
                    Screen('DrawTexture', win, Eyeopen_toScreen);
                    Screen('Flip', win);

                    if rest_time ~= 1
                        WaitSecs(1);
                    end

                    % flicker target 1
                    time = clock;

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SHOWING TARGET 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    while (etime(clock, time) < flicker_time) && ~keyCode(escKey)
                        % Drawing
                        %Compute texture value based on display value from freq long matrixes
                        textureValue = freqCombine(:, indexflip) .* [1; 2; 4; 8];

                        % flicker only one target with random or none random
                        if (random_target_enable == 0)
                            textureValue = textureValue(1) + 1;
                            % set trigger to 10
                            trigger_value = 10;
                            io64(ioObj,address,trigger_value);
                        else
                            textureValue = textureValue(random_target(1)) + 1;

                            % select trigger value (4+1 for 6.66Hz, 6+1 for 7.50Hz, 8+1 for 8.57Hz, 10+1 for 10Hz)
                            %%% In our EEG recorder system, base trigger value is 1, when we set trigger value to 4, it save 4 + 1
                            %%% then for 6.66Hz ---> trigger value is 5
                            %%% then for 7.50Hz ---> trigger value is 7
                            %%% then for 8.57Hz ---> trigger value is 9
                            %%% then for 10Hz ---> trigger value is 11
                            switch random_target(1)
                                case 4
                                    % set trigger to 4
                                    trigger_value = 4;
                                    io64(ioObj,address,trigger_value);
                                case 3
                                    % set trigger to 6
                                    trigger_value = 6;
                                    io64(ioObj,address,trigger_value);
                                case 2
                                    % set trigger to 8
                                    trigger_value = 8;
                                    io64(ioObj,address,trigger_value);
                                otherwise
                                    % set trigger to 10
                                    trigger_value = 10;
                                    io64(ioObj,address,trigger_value);
                            end

                        end

                        disp(['Trigger value is: ', num2str(trigger_value)])

                        %Draw it on the back buffer
                        Screen('DrawTexture', win, texture(textureValue));

                        %Display current index
                        %Screen('DrawText', win, num2str(indexflip),400,400, 255);

                        %Tell PTB no more drawing commands will be issued until the next flip
                        Screen('DrawingFinished', win);

                        % Fliping
                        %Screen('Flip', win, vbl + halfifi);

                        %Flip ASAP
                        Screen('Flip', win);
                        indexflip = indexflip + 1;

                        %Reset index at the end of freq matrix
                        if indexflip > lcmFreq
                            indexflip = 1;
                        end

                        [keyIsDown, secs, keyCode] = KbCheck;
                    end

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% END SHOWING TARGET 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    % set trigger to 0
                    io64(ioObj,address,0);

                    % show image for 1 second
                    Start = imread([pwd, '/', 'end_after_1_sec.png']);

                    Eyeopen_toScreen = Screen('MakeTexture', win, Start);
                    Screen('FillRect', win);
                    Screen('DrawTexture', win, Eyeopen_toScreen);
                    Screen('Flip', win);

                    if rest_time ~= 1
                        WaitSecs(1);
                    end

                    Priority(0);
                    frame_duration = Screen('GetFlipInterval', win);
                end

            end

        end

    catch
        Screen('CloseAll');
        Screen('Close');
        psychrethrow(psychlasterror);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% END SECTION MAIN TRY CATCH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Screen('CloseAll');
    Screen('Close');
