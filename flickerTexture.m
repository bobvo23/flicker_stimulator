function [flickerTexture] = flickerTexture(winWidth, winHeight, targetWidth, targetHeight)

    %% Generate matrix for 4 target (Top, Right, Down, Left)
    for i = 1:5
        targetMatrix{i} = zeros(winHeight, winWidth, 'uint8');
    end

    %conver maxtrix from zero to target
    %     00100 Top
    %     10001 Left/Right
    %     00100 Down
    for i = 1:winHeight

        for j = 1:winWidth
            %Target1 : Top
            if (j >= (winWidth / 2 - targetWidth / 2)) && (j <= winWidth / 2 + targetWidth / 2) && (i <= targetHeight)
                targetMatrix{1}(i, j) = 1; %match target coordinate
                %disp('got it');
            end

            %Target3 : Down
            if (j >= (winWidth / 2 - targetWidth / 2)) && (j <= winWidth / 2 + targetWidth / 2) && (i >= (winHeight - targetHeight))
                targetMatrix{3}(i, j) = 1; %match target coordinate
                %disp('got it');
            end

            %Target2 : Right
            if (j >= (winWidth - targetWidth)) && (i >= (winHeight / 2 - targetHeight / 2)) && (i <= (winHeight / 2 + targetHeight / 2))
                targetMatrix{2}(i, j) = 1; %match target coordinate
            end

            %Target4 : Left
            if (j <= (targetWidth)) && (i >= (winHeight / 2 - targetHeight / 2)) && (i <= (winHeight / 2 + targetHeight / 2))
                targetMatrix{4}(i, j) = 1; %match target coordinate
                %disp('got it');
            end

        end

    end

    %%Draw texture to screen: Draw 16 states depens on the value of

    for targetState1 = 1:2

        for targetState2 = 1:2

            for targetState3 = 1:2

                for targetState4 = 1:2
                    textureNumber = (targetState4 - 1) * 8 + (targetState3 - 1) * 4 + (targetState2 - 1) * 2 + (targetState1 - 1) * 1 +1;
                    screenMatrix{textureNumber} = targetMatrix{5} | targetMatrix{1} * uint8(targetState1 - 1) | ...
                        targetMatrix{2} * uint8(targetState2 - 1) | targetMatrix{3} * uint8(targetState3 - 1) | ...
                        targetMatrix{4} * uint8(targetState4 - 1);
                end

            end

        end

    end

    flickerTexture = screenMatrix;
end
