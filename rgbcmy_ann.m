% Clear workspace and command pront
clear;
clc;

format long

% --- 1. Select one or more CSV files ---
[fileNames, pathName] = uigetfile('*.csv', 'Select CSV files to merge', 'MultiSelect', 'on');

if isequal(fileNames, 0)
    disp('No file selected.');
    return;
end

if ischar(fileNames)
    fileNames = {fileNames};  % Handle single file case
end

% --- 2. Merge all files into one table ---
combined_data = table();

for i = 1:length(fileNames)
    filePath = fullfile(pathName, fileNames{i});
    temp_data = readtable(filePath);
    combined_data = [combined_data; temp_data];
end

% --- 3. Shuffle rows randomly ---
numRows = height(combined_data);
shuffled_data = combined_data(randperm(numRows), :);

% --- 4. Separate inputs and targets ---
X = table2array(shuffled_data(:, {'R', 'G', 'B'}));  % Inputs
Y = table2array(shuffled_data(:, {'C', 'M', 'Y'}));  % Targets
numSamples = size(X, 1);
numFeatures = size(X, 2);

shuffled_RGB_data = X;
shuffled_CMY_data = Y;

%% 5. Split into training/testing
cv = cvpartition(numSamples, 'HoldOut', 0.2);
XTrain = X(training(cv), :);
YTrain = Y(training(cv), :);
XTest = X(test(cv), :);
YTest = Y(test(cv), :);

%% 6. Neural network architecture
layers = [
    featureInputLayer(numFeatures, 'Name', 'input')

    fullyConnectedLayer(128, 'Name', 'fc1')
    reluLayer('Name', 'relu1')
    dropoutLayer(0.2, 'Name', 'drop1')

    fullyConnectedLayer(256, 'Name', 'fc2')
    reluLayer('Name', 'relu2')
    dropoutLayer(0.3, 'Name', 'drop2')

    fullyConnectedLayer(128, 'Name', 'fc3')
    reluLayer('Name', 'relu3')

    fullyConnectedLayer(3, 'Name', 'fc_out')   % 3 outputs: [C M Y]
    regressionLayer('Name', 'regression_output')
];

%% 7. Training options
options = trainingOptions('adam', ...
    'MaxEpochs', 25, ...
    'MiniBatchSize', 512, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', {XTest, YTest}, ...
    'ValidationPatience', 5, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

%% 8. Train the model
net = trainNetwork(XTrain, YTrain, layers, options);

% --- 9. Save the trained model ---
save('myTrainedNetwork.mat', 'net');

% --- 10. Interactive test on a selected row ---

numRows = height(shuffled_data);

% Ask user to pick a row index
prompt = ['Choose a row index to test (between 1 and ', num2str(numRows), ') : '];
lineIndex = input(prompt);

if lineIndex < 1 || lineIndex > numRows
    disp('Invalid row index.');
    return;
end

% Extract RGB values from selected row
inputRGB = shuffled_RGB_data(lineIndex, :);

% Predict using the trained network
predictedCMY = predict(net, inputRGB);

% Ground truth CMY
trueCMY = shuffled_CMY_data(lineIndex, :);

% Display results
disp('-------------------------');
disp('Selected row data:');
fprintf('Input (R, G, B): %.15f, %.15f, %.15f\n', inputRGB(1), inputRGB(2), inputRGB(3));
fprintf('Target (C, M, Y): %.15f, %.15f, %.15f\n', trueCMY(1), trueCMY(2), trueCMY(3));
fprintf('Prediction (C, M, Y): %.15f, %.15f, %.15f\n', predictedCMY(1), predictedCMY(2), predictedCMY(3));

error = trueCMY - predictedCMY;
fprintf('Prediction Error: %.15f, %.15f, %.15f\n', error(1), error(2), error(3));
disp('-------------------------');

%% 11. 3D RGB Visualization

YPred = predict(net, XTest);

figure;
subplot(1,2,1);
scatter3(YTest(:,1), YTest(:,2), YTest(:,3), 5, YTest, 'filled');
title('Ground Truth CMY'); axis equal; grid on;

subplot(1,2,2);
scatter3(YPred(:,1), YPred(:,2), YPred(:,3), 5, YPred, 'filled');
title('Predicted CMY'); axis equal; grid on;

%% 12. Component-wise CMY comparison

figure;
plot(YTest(1:500,1), 'c'); hold on;
plot(YPred(1:500,1), 'c--');
plot(YTest(1:500,2), 'm');
plot(YPred(1:500,2), 'm--');
plot(YTest(1:500,3), 'y');
plot(YPred(1:500,3), 'y--');
legend('C actual','C predicted','M actual','M predicted','Y actual','Y predicted');
title('Component-wise CMY Comparison');

%% 13. t-SNE Visualization of Hidden Features

hiddenLayerName = 'relu3';
features = activations(net, XTest, hiddenLayerName, 'OutputAs', 'rows');
mapped = tsne(features);

figure;
scatter(mapped(:,1), mapped(:,2), 5, YTest, 'filled');
title('t-SNE: Latent Feature Mapping'); grid on;

%% 14. Evaluation metrics
mse_val = mean((YTest - YPred).^2, 'all');         % Mean Squared Error
mae_val = mean(abs(YTest - YPred), 'all');         % Mean Absolute Error

SS_res = sum((YTest - YPred).^2, 'all');
SS_tot = sum((YTest - mean(YTest)).^2, 'all');
r2_val = 1 - (SS_res / SS_tot);                    % R² score

fprintf('MSE: %.4f\n', mse_val);
fprintf('MAE: %.4f\n', mae_val);
fprintf('R²: %.4f\n', r2_val);

%% 15. Confusion Matrices

quantizeCMY = @(CMY) discretize(CMY, [0, 0.33, 0.66, 1], 'categorical', {'Low', 'Medium', 'High'});

YTest_quant = quantizeCMY(YTest);
YPred_quant = quantizeCMY(YPred);

figure('Name', 'CMY Confusion Matrices');

subplot(1,3,1);
confusionchart(YTest_quant(:,1), YPred_quant(:,1));
title('Cyan');

subplot(1,3,2);
confusionchart(YTest_quant(:,2), YPred_quant(:,2));
title('Magenta');

subplot(1,3,3);
confusionchart(YTest_quant(:,3), YPred_quant(:,3));
title('Yellow');
