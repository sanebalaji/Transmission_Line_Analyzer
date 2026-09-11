clc;
clear;
close all;

%% =========================================================
% TRANSMISSION LINE ML MODEL
% NEURAL NETWORK REGRESSION
% ==========================================================

fprintf('============================================\n');
fprintf('     TRANSMISSION LINE ML MODEL TRAINING\n');
fprintf('============================================\n\n');


%% =========================================================
% LOAD DATASET
% ==========================================================

Dataset = readtable('transmission_line_dataset.csv');

fprintf('Total samples = %d\n',height(Dataset));


%% =========================================================
% INPUT FEATURES
% ==========================================================

X = [ ...
    Dataset.Frequency_Hz, ...
    Dataset.R_Ohm_per_m, ...
    Dataset.L_H_per_m, ...
    Dataset.G_S_per_m, ...
    Dataset.C_F_per_m, ...
    Dataset.LineLength_m, ...
    Dataset.ZL_Real_Ohm, ...
    Dataset.ZL_Imag_Ohm ];


%% =========================================================
% TARGET OUTPUTS
% ==========================================================

Y = [ ...
    Dataset.Alpha_Np_per_m, ...
    Dataset.Beta_rad_per_m, ...
    Dataset.Z0_Real_Ohm, ...
    Dataset.Z0_Imag_Ohm, ...
    Dataset.Gamma_Real, ...
    Dataset.Gamma_Imag, ...
    Dataset.Gamma_Magnitude, ...
    Dataset.VSWR, ...
    Dataset.ReturnLoss_dB, ...
    Dataset.Zin_Real_Ohm, ...
    Dataset.Zin_Imag_Ohm, ...
    Dataset.Attenuation_dB ];


target_names = { ...
    'Alpha', ...
    'Beta', ...
    'Z0 Real', ...
    'Z0 Imag', ...
    'Gamma Real', ...
    'Gamma Imag', ...
    'Gamma Magnitude', ...
    'VSWR', ...
    'Return Loss', ...
    'Zin Real', ...
    'Zin Imag', ...
    'Attenuation' };


%% =========================================================
% TRAIN / TEST SPLIT
% ==========================================================

rng(42);

N = size(X,1);

idx = randperm(N);

N_train = round(0.80*N);

train_idx = idx(1:N_train);
test_idx  = idx(N_train+1:end);


X_train = X(train_idx,:);
Y_train = Y(train_idx,:);

X_test = X(test_idx,:);
Y_test = Y(test_idx,:);


fprintf('Training samples = %d\n',size(X_train,1));
fprintf('Testing samples  = %d\n\n',size(X_test,1));


%% =========================================================
% NORMALIZE INPUTS
% ==========================================================

X_mean = mean(X_train,1);
X_std  = std(X_train,0,1);

X_std(X_std == 0) = 1;

X_train_norm = ...
    (X_train-X_mean)./X_std;

X_test_norm = ...
    (X_test-X_mean)./X_std;


%% =========================================================
% NORMALIZE OUTPUTS
% ==========================================================

Y_mean = mean(Y_train,1);
Y_std  = std(Y_train,0,1);

Y_std(Y_std == 0) = 1;

Y_train_norm = ...
    (Y_train-Y_mean)./Y_std;


%% =========================================================
% TRAIN NEURAL NETWORK REGRESSION MODELS
% ==========================================================

fprintf('Training neural-network regression models...\n\n');

models = cell(1,size(Y,2));


for j = 1:size(Y,2)

    fprintf('Training model for %s...\n', ...
        target_names{j});


    models{j} = fitrnet( ...
        X_train_norm, ...
        Y_train_norm(:,j), ...
        'LayerSizes',[30 20], ...
        'Activations','relu', ...
        'Standardize',false);

end


fprintf('\nAll neural-network models trained successfully.\n');


%% =========================================================
% PREDICTION
% ==========================================================

Y_pred_norm = zeros(size(Y_test));


for j = 1:size(Y,2)

    Y_pred_norm(:,j) = predict( ...
        models{j}, ...
        X_test_norm);

end


%% =========================================================
% DENORMALIZE PREDICTIONS
% ==========================================================

Y_pred = ...
    Y_pred_norm .* Y_std + Y_mean;


%% =========================================================
% PERFORMANCE
% ==========================================================

R2   = zeros(1,size(Y,2));
RMSE = zeros(1,size(Y,2));
MAE  = zeros(1,size(Y,2));
Accuracy = zeros(1,size(Y,2));


fprintf('\n============================================\n');
fprintf('           MODEL PERFORMANCE\n');
fprintf('============================================\n');


for j = 1:size(Y,2)

    actual = Y_test(:,j);

    predicted = Y_pred(:,j);


    %% R2

    SS_res = sum((actual-predicted).^2);

    SS_tot = sum((actual-mean(actual)).^2);

    R2(j) = 1-SS_res/SS_tot;


    %% RMSE

    RMSE(j) = sqrt(mean( ...
        (actual-predicted).^2));


    %% MAE

    MAE(j) = mean(abs( ...
        actual-predicted));


    %% Normalized accuracy

    data_range = max(actual)-min(actual);

    if data_range > 0

        Accuracy(j) = ...
            (1-RMSE(j)/data_range)*100;

    else

        Accuracy(j) = 100;

    end


    fprintf('\n%s\n',target_names{j});

    fprintf('R2       = %.6f\n',R2(j));

    fprintf('RMSE     = %.6e\n',RMSE(j));

    fprintf('MAE      = %.6e\n',MAE(j));

    fprintf('Accuracy = %.4f %%\n',Accuracy(j));

end


%% =========================================================
% OVERALL RESULT
% ==========================================================

fprintf('\n============================================\n');
fprintf('             OVERALL RESULT\n');
fprintf('============================================\n');

fprintf('Minimum R2       = %.6f\n',min(R2));

fprintf('Mean R2          = %.6f\n',mean(R2));

fprintf('Minimum Accuracy = %.4f %%\n',min(Accuracy));

fprintf('Mean Accuracy    = %.4f %%\n',mean(Accuracy));


if min(Accuracy) >= 97

    fprintf('\n*** 97%% ACCURACY REQUIREMENT ACHIEVED ***\n');

else

    fprintf('\n*** 97%% ACCURACY REQUIREMENT NOT YET ACHIEVED ***\n');

end


%% =========================================================
% RESULTS TABLE
% ==========================================================

Results = table( ...
    target_names', ...
    R2', ...
    RMSE', ...
    MAE', ...
    Accuracy', ...
    'VariableNames', ...
    {'Parameter','R2','RMSE','MAE','Accuracy_percent'});


disp(Results);


%% =========================================================
% SAVE MODEL
% ==========================================================

save('transmission_line_ML_model.mat', ...
    'models', ...
    'X_mean', ...
    'X_std', ...
    'Y_mean', ...
    'Y_std', ...
    'Results', ...
    'target_names');


fprintf('\nModel saved as:\n');
fprintf('transmission_line_ML_model.mat\n');


%% =========================================================
% ACTUAL VS PREDICTED
% ==========================================================

figure('Name','Actual vs Predicted');

for j = 1:size(Y,2)

    subplot(3,4,j);

    scatter( ...
        Y_test(:,j), ...
        Y_pred(:,j), ...
        10, ...
        'filled');

    hold on;

    min_val = min(Y_test(:,j));

    max_val = max(Y_test(:,j));

    plot( ...
        [min_val max_val], ...
        [min_val max_val], ...
        'k--', ...
        'LineWidth',1.2);

    xlabel('Actual');

    ylabel('Predicted');

    title(sprintf('%s (R^2 = %.3f)', ...
        target_names{j},R2(j)));

    grid on;

end

sgtitle('Neural Network: Actual vs Predicted');


%% =========================================================
% R2 PLOT
% ==========================================================

figure('Name','R2 Performance');

bar(R2);

hold on;

yline(0.97, ...
    'r--', ...
    '97% Requirement', ...
    'LineWidth',1.5);

grid on;

xticks(1:length(target_names));

xticklabels(target_names);

xtickangle(45);

ylabel('R^2');

title('Neural Network Regression Performance');

hold off;


%% =========================================================
% RMSE PLOT
% ==========================================================

figure('Name','RMSE Performance');

bar(RMSE);

grid on;

xticks(1:length(target_names));

xticklabels(target_names);

xtickangle(45);

ylabel('RMSE');

title('Root Mean Square Error');


%% =========================================================
% PREDICTION ERROR
% ==========================================================

PredictionError = Y_test-Y_pred;


figure('Name','Prediction Error');

for j = 1:size(Y,2)

    subplot(3,4,j);

    histogram(PredictionError(:,j),30);

    xlabel('Prediction Error');

    ylabel('Frequency');

    title(target_names{j});

    grid on;

end

sgtitle('Neural Network Prediction Error');


fprintf('\n============================================\n');
fprintf('             TRAINING COMPLETE\n');
fprintf('============================================\n');