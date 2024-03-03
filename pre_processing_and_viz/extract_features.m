% Define input directories
inputDirs = {'./training/mci', './training/control', './training/dementia'};
%inputDirs = {'./test'};


% Define the frequency bands of interest (Hz)
bands = {
    'Delta-1:4', 1, 4;
    'Theta-4:8', 4, 8;
    'Alpha-8:13', 8, 13;
    'Beta-13:30', 13, 30;
    'Gamma-30:40', 30, 40
    };

% Initialize the features table
all_features = {};

% Loop through each input directory
for dirIdx = 1:length(inputDirs)
    currentDir = inputDirs{dirIdx};
    fprintf('Processing directory: %s\n', currentDir);
    
    % Find all MAT files in the current directory
    matFiles = dir(fullfile(currentDir, '*.mat'));
    
    % Loop through each MAT file in the directory
    for fileIdx = 1:length(matFiles)
        fileName = fullfile(currentDir, matFiles(fileIdx).name);
        fprintf('Processing file: %s\n', fileName);
        
        % Load the MEG data using SPM's function
        D = spm_eeg_load(fileName);
        
        % Extract the MEG data into a variable
        meg_data = D(:,:,:);
        
        fs = D.fsample; % sample freq
        
        % Filter settings
        lowCut = 1;
        highCut = 50;
        order = 4;
        
        % Create filter
        [b, a] = butter(order, [lowCut highCut]/(fs/2), 'bandpass');
        
        % Appliquer le filtre
        for channel = 1:size(meg_data, 3)
            for trial = 1:size(meg_data, 2)
                meg_data(:, trial, channel) = filtfilt(b, a, squeeze(meg_data(:, trial, channel)));
            end
        end
        
        
        % Initialize the row for this file, starting with the file name
        file_features = {matFiles(fileIdx).name};
        
        % Calculate spectral power for each band
        for i = 1:size(bands, 1)
            band = bands(i, :);
            freq_min = band{2};
            freq_max = band{3};
            
            % Initialize power sum for this band
            power_band_sum = 0;
            
            % Loop over channels
            for channel = 1:size(meg_data, 3)
                % Extract channel data
                channel_data = squeeze(meg_data(:, :, channel));
                
                % Calculate power spectral density using Welch's method
                [p,f] = pwelch(channel_data, [], [], [], D.fsample);
                
                % Find indices of frequencies within the desired band
                freq_indices = f >= freq_min & f <= freq_max;
                
                % Integrate power over the frequency band
                power = sum(p(freq_indices));
                
                % Add to the power sum for this band
                power_band_sum = power_band_sum + power;
            end
            
            % Calculate average power for this band and store in features
            power_band_avg = power_band_sum / size(meg_data, 3);
            file_features{end+1} = num2str(power_band_avg); % Convert to string for CSV compatibility
        end
        
        % Add this file's features to the all_features table
        all_features = [all_features; file_features];
    end
    fprintf('Finished processing directory: %s\n', currentDir);
end

% Convert the cell array to a table (optional, for easier handling in MATLAB)
features_table = cell2table(all_features, 'VariableNames', ['FileName', bands(:,1)']);

% Save the features table to a CSV file
writetable(features_table, 'test_features.csv', 'WriteVariableNames', true);
fprintf('All features extracted and saved.\n');
