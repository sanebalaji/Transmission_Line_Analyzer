clc;
clear;
close all;

%% =========================================================
% TRANSMISSION LINE DATASET VALIDATION
% ==========================================================

fprintf('============================================\n');
fprintf('   TRANSMISSION LINE DATASET VALIDATION\n');
fprintf('============================================\n\n');

%% Load dataset

Dataset = readtable('transmission_line_dataset.csv');

fprintf('Number of rows    = %d\n', height(Dataset));
fprintf('Number of columns = %d\n\n', width(Dataset));


%% =========================================================
% CHECK FOR MISSING VALUES
% ==========================================================

missing_values = sum(ismissing(Dataset), 'all');

fprintf('Missing values = %d\n', missing_values);


%% =========================================================
% CHECK FOR NaN / INFINITE VALUES
% ==========================================================

numeric_data = table2array(Dataset);

nan_count = sum(isnan(numeric_data), 'all');
inf_count = sum(isinf(numeric_data), 'all');

fprintf('NaN values      = %d\n', nan_count);
fprintf('Infinite values = %d\n\n', inf_count);


%% =========================================================
% GAMMA CHECK
% ==========================================================

Gamma_max = max(Dataset.Gamma_Magnitude);
Gamma_min = min(Dataset.Gamma_Magnitude);

fprintf('Reflection coefficient magnitude:\n');
fprintf('Minimum |Gamma| = %.6f\n', Gamma_min);
fprintf('Maximum |Gamma| = %.6f\n\n', Gamma_max);


%% =========================================================
% VSWR CHECK
% ==========================================================

fprintf('VSWR range:\n');
fprintf('Minimum VSWR = %.6f\n', min(Dataset.VSWR));
fprintf('Maximum VSWR = %.6f\n\n', max(Dataset.VSWR));


%% =========================================================
% POWER CHECK
% ==========================================================

power_error = abs( ...
    Dataset.IncidentPower_W ...
    - Dataset.ReflectedPower_W ...
    - Dataset.LoadPower_W);

fprintf('Power conservation:\n');
fprintf('Maximum power error = %.6e W\n\n', ...
    max(power_error));


%% =========================================================
% POWER COEFFICIENT CHECK
% ==========================================================

coefficient_error = abs( ...
    Dataset.PowerReflectionCoefficient ...
    + Dataset.PowerTransmissionCoefficient ...
    - 1);

fprintf('Power coefficient check:\n');
fprintf('Maximum coefficient error = %.6e\n\n', ...
    max(coefficient_error));


%% =========================================================
% ATTENUATION CHECK
% ==========================================================

fprintf('Attenuation range:\n');
fprintf('Minimum attenuation = %.6f dB\n', ...
    min(Dataset.Attenuation_dB));

fprintf('Maximum attenuation = %.6f dB\n\n', ...
    max(Dataset.Attenuation_dB));


%% =========================================================
% INPUT IMPEDANCE RANGE
% ==========================================================

fprintf('Input impedance range:\n');

fprintf('Real(Zin): %.4f to %.4f Ohm\n', ...
    min(Dataset.Zin_Real_Ohm), ...
    max(Dataset.Zin_Real_Ohm));

fprintf('Imag(Zin): %.4f to %.4f Ohm\n\n', ...
    min(Dataset.Zin_Imag_Ohm), ...
    max(Dataset.Zin_Imag_Ohm));


%% =========================================================
% BASIC PASS / FAIL
% ==========================================================

fprintf('============================================\n');
fprintf('             VALIDATION RESULT\n');
fprintf('============================================\n');

if missing_values == 0 && ...
   nan_count == 0 && ...
   inf_count == 0 && ...
   max(power_error) < 1e-10 && ...
   max(coefficient_error) < 1e-10

    fprintf('DATASET VALIDATION: PASS\n');

else

    fprintf('DATASET VALIDATION: CHECK REQUIRED\n');

end

fprintf('============================================\n');