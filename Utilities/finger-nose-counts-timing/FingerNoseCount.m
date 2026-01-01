function keyPressCounter
    % Initialize counters
    LeftTouches = 0;
    RightTouches = 0;
    userInput = '';

    % Initialize array to store touch events
    touchEvents = {};
    previousTimestamp = [];

    % Create a figure window
    fig = figure('Name', 'Key Press Counter', 'NumberTitle', 'off', ...
                 'KeyPressFcn', @keyPressHandler, ...
                 'CloseRequestFcn', @closeFigure, ...
                 'Position', [500, 500, 300, 300]);

    % Prompt for user input (combined string)
    userText = uicontrol('Style', 'text', 'String', 'Enter Input String:', ...
                         'Position', [50, 250, 200, 20], ...
                         'FontSize', 12);
    userEdit = uicontrol('Style', 'edit', 'Position', [50, 220, 200, 20], ...
                         'FontSize', 12, 'Callback', @updateInput);

    % Create text objects for displaying counts
    leftText = uicontrol('Style', 'text', 'String', 'LeftTouches: 0', ...
                         'Position', [50, 50, 200, 20], ...
                         'FontSize', 12, 'Visible', 'off');
    rightText = uicontrol('Style', 'text', 'String', 'RightTouches: 0', ...
                          'Position', [50, 20, 200, 20], ...
                          'FontSize', 12, 'Visible', 'off');

    % Nested function to update input
    function updateInput(~, ~)
        userInput = get(userEdit, 'String');
        if ~isempty(userInput)
            set(userText, 'Visible', 'off');
            set(userEdit, 'Visible', 'off');
            set(leftText, 'Visible', 'on');
            set(rightText, 'Visible', 'on');
            uicontrol(leftText); % Set focus to the figure for key press detection
        end
    end

    % Nested function to handle key press events
    function keyPressHandler(~, event)
        if isempty(userInput)
            return;
        end
        timestamp = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS');
        timeInterval = '';

        if ~isempty(previousTimestamp)
            timeInterval = milliseconds(timestamp - previousTimestamp);
        end

        previousTimestamp = timestamp;

        switch event.Key
            case 'space'
                LeftTouches = LeftTouches + 1;
                set(leftText, 'String', ['LeftTouches: ', num2str(LeftTouches)]);
                touchEvents = [touchEvents; {userInput, 1, 0, char(timestamp), timeInterval}];
            case 'return'
                RightTouches = RightTouches + 1;
                set(rightText, 'String', ['RightTouches: ', num2str(RightTouches)]);
                touchEvents = [touchEvents; {userInput, 0, 1, char(timestamp), timeInterval}];
            case 'escape'
                % Save the results and close the figure
                disp(['User Input: ', userInput]);
                disp(['LeftTouches: ', num2str(LeftTouches)]);
                disp(['RightTouches: ', num2str(RightTouches)]);
                saveToExcel(touchEvents);
                closeFigure();
        end
    end

    % Nested function to save results to an Excel file
    function saveToExcel(touchEvents)
        filename = 'KeyPressResults.xlsx';
        header = {'InputString', 'LeftTouch', 'RightTouch', 'Timestamp', 'TimeGap(ms)'};
        if exist(filename, 'file')
            % Append to the existing file
            writecell(touchEvents, filename, 'WriteMode', 'append');
        else
            % Create a new file with headers
            writecell([header; touchEvents], filename);
        end
    end

    % Nested function to handle figure close request
    function closeFigure(~, ~)
        % Display final counts when the figure is closed
        disp('Final Counts:');
        disp(['LeftTouches: ', num2str(LeftTouches)]);
        disp(['RightTouches: ', num2str(RightTouches)]);
        delete(fig);
    end
end
