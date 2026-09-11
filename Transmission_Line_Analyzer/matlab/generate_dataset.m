clc;
clear;
close all;

%% =========================================================
% TRANSMISSION LINE DATASET GENERATION
% ==========================================================

fprintf('============================================\n');
fprintf('   TRANSMISSION LINE DATASET GENERATION\n');
fprintf('============================================\n\n');


%% =========================================================
% NUMBER OF SAMPLES
% ==========================================================

N = 5000;


%% =========================================================
% RANDOM SEED
% ==========================================================

rng(42);


%% =========================================================
% CONSTANT
% ==========================================================

c = 3e8;


%% =========================================================
% RANDOM TRANSMISSION-LINE INPUT PARAMETERS
% ==========================================================

% Frequency: 0.5 GHz to 3 GHz
Frequency_Hz = ...
    (0.5 + (3.0-0.5)*rand(N,1))*1e9;


% Resistance: 0.1 to 2 Ohm/m
R_Ohm_per_m = ...
    0.1 + (2.0-0.1)*rand(N,1);


% Inductance: 0.05 to 0.5 uH/m
L_H_per_m = ...
    (0.05 + (0.5-0.05)*rand(N,1))*1e-6;


% Conductance: 0 to 0.01 S/m
G_S_per_m = ...
    0.01*rand(N,1);


% Capacitance: 20 to 200 pF/m
C_F_per_m = ...
    (20 + (200-20)*rand(N,1))*1e-12;


% Line length: 1 to 100 m
LineLength_m = ...
    1 + (100-1)*rand(N,1);


% Load resistance: 25 to 200 Ohm
ZL_Real_Ohm = ...
    25 + (200-25)*rand(N,1);


% Load reactance: -100 to +100 Ohm
ZL_Imag_Ohm = ...
    -100 + 200*rand(N,1);


%% =========================================================
% PREALLOCATE OUTPUTS
% ==========================================================

Alpha_Np_per_m = zeros(N,1);

Beta_rad_per_m = zeros(N,1);

Z0_Real_Ohm = zeros(N,1);

Z0_Imag_Ohm = zeros(N,1);

Wavelength_m = zeros(N,1);

Gamma_Real = zeros(N,1);

Gamma_Imag = zeros(N,1);

Gamma_Magnitude = zeros(N,1);

VSWR = zeros(N,1);

ReturnLoss_dB = zeros(N,1);

Zin_Real_Ohm = zeros(N,1);

Zin_Imag_Ohm = zeros(N,1);

IncidentPower_W = zeros(N,1);

ReflectedPower_W = zeros(N,1);

LoadPower_W = zeros(N,1);

PowerReflectionCoefficient = zeros(N,1);

PowerTransmissionCoefficient = zeros(N,1);

Attenuation_dB = zeros(N,1);


%% =========================================================
% ANALYTICAL TRANSMISSION-LINE CALCULATIONS
% ==========================================================

fprintf('Calculating transmission-line parameters...\n\n');


for k = 1:N

    %% -----------------------------------------------------
    % INPUT PARAMETERS
    % -----------------------------------------------------

    f = Frequency_Hz(k);

    R = R_Ohm_per_m(k);

    L = L_H_per_m(k);

    G = G_S_per_m(k);

    C = C_F_per_m(k);

    line_length = LineLength_m(k);

    ZL = ...
        ZL_Real_Ohm(k) + ...
        1i*ZL_Imag_Ohm(k);


    %% -----------------------------------------------------
    % ANGULAR FREQUENCY
    % -----------------------------------------------------

    omega = 2*pi*f;


    %% -----------------------------------------------------
    % PROPAGATION CONSTANT
    % -----------------------------------------------------

    gamma = sqrt( ...
        (R + 1i*omega*L) * ...
        (G + 1i*omega*C));


    alpha = real(gamma);

    beta = imag(gamma);


    %% -----------------------------------------------------
    % CHARACTERISTIC IMPEDANCE
    % -----------------------------------------------------

    Z0 = sqrt( ...
        (R + 1i*omega*L) / ...
        (G + 1i*omega*C));


    %% -----------------------------------------------------
    % WAVELENGTH
    % -----------------------------------------------------

    if abs(beta) > eps

        wavelength = ...
            2*pi/abs(beta);

    else

        wavelength = Inf;

    end


    %% -----------------------------------------------------
    % REFLECTION COEFFICIENT
    % -----------------------------------------------------

    Gamma = ...
        (ZL-Z0)/(ZL+Z0);


    Gamma_mag = abs(Gamma);


    %% -----------------------------------------------------
    % VSWR
    % -----------------------------------------------------

    if Gamma_mag < 1

        vswr_value = ...
            (1+Gamma_mag)/(1-Gamma_mag);

    else

        vswr_value = Inf;

    end


    %% -----------------------------------------------------
    % RETURN LOSS
    % -----------------------------------------------------

    if Gamma_mag > 0

        return_loss = ...
            -20*log10(Gamma_mag);

    else

        return_loss = Inf;

    end


    %% -----------------------------------------------------
    % INPUT IMPEDANCE
    % -----------------------------------------------------

    tanh_term = ...
        tanh(gamma*line_length);


    Zin = Z0 * ...
        (ZL + Z0*tanh_term) / ...
        (Z0 + ZL*tanh_term);


    %% -----------------------------------------------------
    % INCIDENT WAVE
    % -----------------------------------------------------

    Vplus = 1;

    Vminus = Gamma*Vplus;


    %% -----------------------------------------------------
    % LOAD VOLTAGE
    % -----------------------------------------------------

    VL = Vplus + Vminus;


    %% -----------------------------------------------------
    % LOAD CURRENT
    % -----------------------------------------------------

    IL = ...
        (Vplus-Vminus)/Z0;


    %% -----------------------------------------------------
    % POWER
    % -----------------------------------------------------

    P_incident = ...
        0.5*real( ...
        Vplus*conj(Vplus/Z0));


    P_reflected = ...
        0.5*real( ...
        Vminus*conj(Vminus/Z0));


    P_reflected = abs(P_reflected);


    P_load = ...
        0.5*real(VL*conj(IL));


    %% -----------------------------------------------------
    % POWER COEFFICIENTS
    % -----------------------------------------------------

    power_reflection = ...
        Gamma_mag^2;


    power_transmission = ...
        1-Gamma_mag^2;


    %% -----------------------------------------------------
    % ATTENUATION
    % -----------------------------------------------------

    attenuation_dB = ...
        8.686*alpha*line_length;


    %% =====================================================
    % STORE RESULTS
    % =====================================================

    Alpha_Np_per_m(k) = alpha;

    Beta_rad_per_m(k) = beta;

    Z0_Real_Ohm(k) = real(Z0);

    Z0_Imag_Ohm(k) = imag(Z0);

    Wavelength_m(k) = wavelength;

    Gamma_Real(k) = real(Gamma);

    Gamma_Imag(k) = imag(Gamma);

    Gamma_Magnitude(k) = Gamma_mag;

    VSWR(k) = vswr_value;

    ReturnLoss_dB(k) = return_loss;

    Zin_Real_Ohm(k) = real(Zin);

    Zin_Imag_Ohm(k) = imag(Zin);

    IncidentPower_W(k) = P_incident;

    ReflectedPower_W(k) = P_reflected;

    LoadPower_W(k) = P_load;

    PowerReflectionCoefficient(k) = power_reflection;

    PowerTransmissionCoefficient(k) = power_transmission;

    Attenuation_dB(k) = attenuation_dB;

end


fprintf('All %d samples calculated successfully.\n\n',N);


%% =========================================================
% CREATE TABLE
% ==========================================================

Dataset = table( ...
    Frequency_Hz, ...
    R_Ohm_per_m, ...
    L_H_per_m, ...
    G_S_per_m, ...
    C_F_per_m, ...
    LineLength_m, ...
    ZL_Real_Ohm, ...
    ZL_Imag_Ohm, ...
    Alpha_Np_per_m, ...
    Beta_rad_per_m, ...
    Z0_Real_Ohm, ...
    Z0_Imag_Ohm, ...
    Wavelength_m, ...
    Gamma_Real, ...
    Gamma_Imag, ...
    Gamma_Magnitude, ...
    VSWR, ...
    ReturnLoss_dB, ...
    Zin_Real_Ohm, ...
    Zin_Imag_Ohm, ...
    IncidentPower_W, ...
    ReflectedPower_W, ...
    LoadPower_W, ...
    PowerReflectionCoefficient, ...
    PowerTransmissionCoefficient, ...
    Attenuation_dB);


%% =========================================================
% VARIABLE NAMES
% ==========================================================

Dataset.Properties.VariableNames = { ...
    'Frequency_Hz', ...
    'R_Ohm_per_m', ...
    'L_H_per_m', ...
    'G_S_per_m', ...
    'C_F_per_m', ...
    'LineLength_m', ...
    'ZL_Real_Ohm', ...
    'ZL_Imag_Ohm', ...
    'Alpha_Np_per_m', ...
    'Beta_rad_per_m', ...
    'Z0_Real_Ohm', ...
    'Z0_Imag_Ohm', ...
    'Wavelength_m', ...
    'Gamma_Real', ...
    'Gamma_Imag', ...
    'Gamma_Magnitude', ...
    'VSWR', ...
    'ReturnLoss_dB', ...
    'Zin_Real_Ohm', ...
    'Zin_Imag_Ohm', ...
    'IncidentPower_W', ...
    'ReflectedPower_W', ...
    'LoadPower_W', ...
    'PowerReflectionCoefficient', ...
    'PowerTransmissionCoefficient', ...
    'Attenuation_dB' };


%% =========================================================
% SAVE CSV
% ==========================================================

writetable( ...
    Dataset, ...
    'transmission_line_dataset.csv');


%% =========================================================
% SAVE MAT
% ==========================================================

save( ...
    'transmission_line_dataset.mat', ...
    'Dataset');


%% =========================================================
% DISPLAY INFORMATION
% ==========================================================

fprintf('============================================\n');
fprintf('        DATASET GENERATION COMPLETE\n');
fprintf('============================================\n\n');

fprintf('Number of samples = %d\n',height(Dataset));

fprintf('Number of columns = %d\n',width(Dataset));

fprintf('\nInput ranges:\n');

fprintf('Frequency : %.3f - %.3f GHz\n', ...
    min(Frequency_Hz)/1e9, ...
    max(Frequency_Hz)/1e9);

fprintf('R         : %.3f - %.3f Ohm/m\n', ...
    min(R_Ohm_per_m), ...
    max(R_Ohm_per_m));

fprintf('L         : %.3f - %.3f uH/m\n', ...
    min(L_H_per_m)*1e6, ...
    max(L_H_per_m)*1e6);

fprintf('G         : %.6f - %.6f S/m\n', ...
    min(G_S_per_m), ...
    max(G_S_per_m));

fprintf('C         : %.3f - %.3f pF/m\n', ...
    min(C_F_per_m)*1e12, ...
    max(C_F_per_m)*1e12);

fprintf('Length    : %.3f - %.3f m\n', ...
    min(LineLength_m), ...
    max(LineLength_m));

fprintf('Load R    : %.3f - %.3f Ohm\n', ...
    min(ZL_Real_Ohm), ...
    max(ZL_Real_Ohm));

fprintf('Load X    : %.3f - %.3f Ohm\n', ...
    min(ZL_Imag_Ohm), ...
    max(ZL_Imag_Ohm));


fprintf('\nFiles saved:\n');

fprintf('transmission_line_dataset.csv\n');

fprintf('transmission_line_dataset.mat\n');

fprintf('\n============================================\n');