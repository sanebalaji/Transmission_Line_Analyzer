function final_analysis_window
% ================================================================
% TRANSMISSION LINE ANALYZER
% ================================================================
% Final integrated MATLAB application for Transmission Line analysis
%
% FEATURES:
%   1. Analytical transmission-line calculations
%   2. Neural-network ML prediction
%   3. ML vs analytical comparison
%   4. Voltage waveforms
%   5. Standing-wave pattern
%   6. Current waveform
%   7. Time-domain voltage
%
% ML MODEL:
%   transmission_line_ML_model.mat
%
% ================================================================

clc;

%% ================================================================
% LOAD TRAINED ML MODEL
% ================================================================

model_file = 'transmission_line_ML_model.mat';

if ~isfile(model_file)

    uialert( ...
        uifigure, ...
        ['The file transmission_line_ML_model.mat was not found.' newline ...
         'Make sure it is in the same folder as this file.'], ...
        'ML Model Not Found');

    return;

end


load(model_file, ...
    'models', ...
    'X_mean', ...
    'X_std', ...
    'Y_mean', ...
    'Y_std', ...
    'Results', ...
    'target_names');


%% ================================================================
% CREATE MAIN APPLICATION WINDOW
% ================================================================

fig = uifigure( ...
    'Name','Transmission Line Analyzer - ML Integrated', ...
    'Position',[50 50 1450 850], ...
    'Color',[0.94 0.94 0.94]);


%% ================================================================
% MAIN GRID
% ================================================================

mainGrid = uigridlayout(fig,[1 2]);

mainGrid.ColumnWidth = {330,'1x'};

mainGrid.RowHeight = {'1x'};


%% ================================================================
% LEFT INPUT PANEL
% ================================================================

inputPanel = uipanel( ...
    mainGrid, ...
    'Title','Transmission Line Input Parameters', ...
    'FontWeight','bold');


inputGrid = uigridlayout(inputPanel,[11 2]);

inputGrid.RowHeight = { ...
    35, ...
    35, ...
    35, ...
    35, ...
    35, ...
    35, ...
    35, ...
    35, ...
    55, ...
    35, ...
    '1x'};

inputGrid.ColumnWidth = {150,'1x'};


%% ================================================================
% FREQUENCY
% ================================================================

label = uilabel(inputGrid);

label.Text = 'Frequency (GHz)';
label.FontWeight = 'bold';

label.Layout.Row = 1;
label.Layout.Column = 1;


freqField = uieditfield(inputGrid,'numeric');

freqField.Value = 1.0;
freqField.Limits = [0 Inf];

freqField.Layout.Row = 1;
freqField.Layout.Column = 2;


%% ================================================================
% R
% ================================================================

label = uilabel(inputGrid);

label.Text = 'R (Ohm/m)';
label.FontWeight = 'bold';

label.Layout.Row = 2;
label.Layout.Column = 1;


RField = uieditfield(inputGrid,'numeric');

RField.Value = 0.5;
RField.Limits = [0 Inf];

RField.Layout.Row = 2;
RField.Layout.Column = 2;


%% ================================================================
% L
% ================================================================

label = uilabel(inputGrid);

label.Text = 'L (uH/m)';
label.FontWeight = 'bold';

label.Layout.Row = 3;
label.Layout.Column = 1;


LField = uieditfield(inputGrid,'numeric');

LField.Value = 0.2;
LField.Limits = [0 Inf];

LField.Layout.Row = 3;
LField.Layout.Column = 2;


%% ================================================================
% G
% ================================================================

label = uilabel(inputGrid);

label.Text = 'G (S/m)';
label.FontWeight = 'bold';

label.Layout.Row = 4;
label.Layout.Column = 1;


GField = uieditfield(inputGrid,'numeric');

GField.Value = 0;
GField.Limits = [0 Inf];

GField.Layout.Row = 4;
GField.Layout.Column = 2;


%% ================================================================
% C
% ================================================================

label = uilabel(inputGrid);

label.Text = 'C (pF/m)';
label.FontWeight = 'bold';

label.Layout.Row = 5;
label.Layout.Column = 1;


CField = uieditfield(inputGrid,'numeric');

CField.Value = 100;
CField.Limits = [0 Inf];

CField.Layout.Row = 5;
CField.Layout.Column = 2;


%% ================================================================
% LINE LENGTH
% ================================================================

label = uilabel(inputGrid);

label.Text = 'Length (m)';
label.FontWeight = 'bold';

label.Layout.Row = 6;
label.Layout.Column = 1;


lengthField = uieditfield(inputGrid,'numeric');

lengthField.Value = 100;
lengthField.Limits = [0 Inf];

lengthField.Layout.Row = 6;
lengthField.Layout.Column = 2;


%% ================================================================
% LOAD RESISTANCE
% ================================================================

label = uilabel(inputGrid);

label.Text = 'Load R (Ohm)';
label.FontWeight = 'bold';

label.Layout.Row = 7;
label.Layout.Column = 1;


ZLRField = uieditfield(inputGrid,'numeric');

ZLRField.Value = 100;

ZLRField.Layout.Row = 7;
ZLRField.Layout.Column = 2;


%% ================================================================
% LOAD REACTANCE
% ================================================================

label = uilabel(inputGrid);

label.Text = 'Load X (Ohm)';
label.FontWeight = 'bold';

label.Layout.Row = 8;
label.Layout.Column = 1;


ZLXField = uieditfield(inputGrid,'numeric');

ZLXField.Value = 0;

ZLXField.Layout.Row = 8;
ZLXField.Layout.Column = 2;


%% ================================================================
% ANALYZE BUTTON
% ================================================================

analyzeButton = uibutton( ...
    inputGrid, ...
    'push');

analyzeButton.Text = 'ANALYZE TRANSMISSION LINE';

analyzeButton.FontWeight = 'bold';
analyzeButton.FontSize = 13;

analyzeButton.Layout.Row = 9;
analyzeButton.Layout.Column = [1 2];


%% ================================================================
% RESET BUTTON
% ================================================================

resetButton = uibutton( ...
    inputGrid, ...
    'push');

resetButton.Text = 'RESET TO DEFAULT VALUES';

resetButton.Layout.Row = 10;
resetButton.Layout.Column = [1 2];


%% ================================================================
% RIGHT PANEL
% ================================================================

rightPanel = uipanel( ...
    mainGrid, ...
    'Title','Transmission Line Analysis', ...
    'FontWeight','bold');


rightGrid = uigridlayout(rightPanel,[2 1]);

rightGrid.RowHeight = {280,'1x'};


%% ================================================================
% RESULTS AREA
% ================================================================

resultsArea = uitextarea( ...
    rightGrid);

resultsArea.Editable = 'off';

resultsArea.FontName = 'Consolas';

resultsArea.FontSize = 12;

resultsArea.Value = { ...
    '================================================'; ...
    '       TRANSMISSION LINE ANALYZER'; ...
    '================================================'; ...
    ' '; ...
    'Enter the transmission-line parameters'; ...
    'and click ANALYZE TRANSMISSION LINE.'; ...
    ' '; ...
    'Default example: 1 GHz, 100 Ohm load'; ...
    ' '};


%% ================================================================
% WAVEFORM TAB GROUP
% ================================================================

tabs = uitabgroup(rightGrid);


%% ================================================================
% VOLTAGE WAVE TAB
% ================================================================

voltageTab = uitab( ...
    tabs, ...
    'Title','Voltage Waves');


axVoltage = uiaxes(voltageTab);

title(axVoltage,'Incident, Reflected and Total Voltage');

xlabel(axVoltage,'Distance from Load (m)');

ylabel(axVoltage,'Voltage Magnitude (V)');

grid(axVoltage,'on');


%% ================================================================
% STANDING WAVE TAB
% ================================================================

standingTab = uitab( ...
    tabs, ...
    'Title','Standing Wave');


axStanding = uiaxes(standingTab);

title(axStanding,'Standing-Wave Voltage Pattern');

xlabel(axStanding,'Distance from Load (m)');

ylabel(axStanding,'|V(z)| (V)');

grid(axStanding,'on');


%% ================================================================
% CURRENT TAB
% ================================================================

currentTab = uitab( ...
    tabs, ...
    'Title','Current');


axCurrent = uiaxes(currentTab);

title(axCurrent,'Transmission-Line Current');

xlabel(axCurrent,'Distance from Load (m)');

ylabel(axCurrent,'|I(z)| (A)');

grid(axCurrent,'on');


%% ================================================================
% TIME DOMAIN TAB
% ================================================================

timeTab = uitab( ...
    tabs, ...
    'Title','Time Domain');


axTime = uiaxes(timeTab);

title(axTime,'Time-Domain Voltage at Load');

xlabel(axTime,'Time (ns)');

ylabel(axTime,'Voltage (V)');

grid(axTime,'on');


%% ================================================================
% CALLBACK CONNECTION
% ================================================================

analyzeButton.ButtonPushedFcn = @analyzeTransmissionLine;

resetButton.ButtonPushedFcn = @resetValues;


%% ================================================================
% ANALYZE TRANSMISSION LINE
% ================================================================

function analyzeTransmissionLine(~,~)

    %% ============================================================
    % READ USER INPUT
    % ============================================================

    f = freqField.Value * 1e9;

    R = RField.Value;

    L = LField.Value * 1e-6;

    G = GField.Value;

    C = CField.Value * 1e-12;

    line_length = lengthField.Value;

    ZL = ...
        ZLRField.Value + ...
        1i*ZLXField.Value;


    %% ============================================================
    % INPUT VALIDATION
    % ============================================================

    if ~isfinite(f) || f <= 0

        uialert( ...
            fig, ...
            'Frequency must be greater than zero.', ...
            'Invalid Frequency');

        return;

    end


    if ~isfinite(R) || R < 0

        uialert( ...
            fig, ...
            'R must be zero or greater.', ...
            'Invalid R');

        return;

    end


    if ~isfinite(L) || L <= 0

        uialert( ...
            fig, ...
            'L must be greater than zero.', ...
            'Invalid L');

        return;

    end


    if ~isfinite(G) || G < 0

        uialert( ...
            fig, ...
            'G must be zero or greater.', ...
            'Invalid G');

        return;

    end


    if ~isfinite(C) || C <= 0

        uialert( ...
            fig, ...
            'C must be greater than zero.', ...
            'Invalid C');

        return;

    end


    if ~isfinite(line_length) || line_length <= 0

        uialert( ...
            fig, ...
            'Line length must be greater than zero.', ...
            'Invalid Length');

        return;

    end


    if ~isfinite(real(ZL)) || ~isfinite(imag(ZL))

        uialert( ...
            fig, ...
            'Load impedance must contain finite values.', ...
            'Invalid Load');

        return;

    end


    if abs(ZL) == 0

        uialert( ...
            fig, ...
            'Load impedance cannot be exactly zero for this analysis.', ...
            'Invalid Load');

        return;

    end


    %% ============================================================
    % ANGULAR FREQUENCY
    % ============================================================

    omega = 2*pi*f;


    %% ============================================================
    % PROPAGATION CONSTANT
    % ============================================================

    gamma = sqrt( ...
        (R + 1i*omega*L) * ...
        (G + 1i*omega*C));


    alpha = real(gamma);

    beta = imag(gamma);


    %% ============================================================
    % WAVELENGTH
    % ============================================================

    if abs(beta) > eps

        wavelength = ...
            2*pi/abs(beta);

    else

        wavelength = Inf;

    end


    %% ============================================================
    % CHARACTERISTIC IMPEDANCE
    % ============================================================

    Z0 = sqrt( ...
        (R + 1i*omega*L) / ...
        (G + 1i*omega*C));


    %% ============================================================
    % REFLECTION COEFFICIENT
    % ============================================================

    Gamma = ...
        (ZL - Z0) / ...
        (ZL + Z0);


    Gamma_mag = abs(Gamma);

    Gamma_phase = ...
        angle(Gamma) * 180/pi;


    %% ============================================================
    % VSWR
    % ============================================================

    if Gamma_mag < 1

        VSWR = ...
            (1 + Gamma_mag) / ...
            (1 - Gamma_mag);

    else

        VSWR = Inf;

    end


    %% ============================================================
    % RETURN LOSS
    % ============================================================

    if Gamma_mag > 0

        ReturnLoss = ...
            -20*log10(Gamma_mag);

    else

        ReturnLoss = Inf;

    end


    %% ============================================================
    % INPUT IMPEDANCE
    % ============================================================

    tanh_term = ...
        tanh(gamma * line_length);


    Zin = Z0 * ...
        (ZL + Z0*tanh_term) / ...
        (Z0 + ZL*tanh_term);


    %% ============================================================
    % INCIDENT AND REFLECTED WAVES
    % ============================================================

    Vplus = 1;

    Vminus = Gamma * Vplus;


    %% ============================================================
    % LOAD VOLTAGE
    % ============================================================

    VL = ...
        Vplus + Vminus;


    %% ============================================================
    % LOAD CURRENT
    % ============================================================

    IL = ...
        (Vplus - Vminus) / Z0;


    %% ============================================================
    % INPUT VOLTAGE
    % ============================================================

    Vin = ...
        Vplus*exp(gamma*line_length) + ...
        Vminus*exp(-gamma*line_length);


    %% ============================================================
    % INPUT CURRENT
    % ============================================================

    Iin = ...
        Vplus*exp(gamma*line_length)/Z0 - ...
        Vminus*exp(-gamma*line_length)/Z0;


    %% ============================================================
    % POWER CALCULATIONS
    % ============================================================

    P_incident = ...
        0.5 * real( ...
        Vplus * conj(Vplus/Z0));


    P_reflected_signed = ...
        0.5 * real( ...
        Vminus * conj(Vminus/Z0));


    P_reflected = ...
        abs(P_reflected_signed);


    P_load = ...
        0.5 * real( ...
        VL * conj(IL));


    %% ============================================================
    % POWER COEFFICIENTS
    % ============================================================

    PowerReflectionCoefficient = ...
        Gamma_mag^2;


    PowerTransmissionCoefficient = ...
        1 - Gamma_mag^2;


    %% ============================================================
    % ATTENUATION
    % ============================================================

    attenuation_Np = ...
        alpha * line_length;


    attenuation_dB = ...
        8.686 * attenuation_Np;


    attenuation_factor = ...
        exp(-alpha*line_length);


    power_attenuation_factor = ...
        exp(-2*alpha*line_length);


    %% ============================================================
    % ANALYTICAL VERIFICATION
    % ============================================================

    impedance_error_input = ...
        abs(Vin/Iin - Zin);


    impedance_error_load = ...
        abs(VL/IL - ZL);


    %% ============================================================
    % ML INPUT VECTOR
    % ============================================================

    X_user = [ ...
        f, ...
        R, ...
        L, ...
        G, ...
        C, ...
        line_length, ...
        real(ZL), ...
        imag(ZL) ];


    %% ============================================================
    % NORMALIZE ML INPUT
    % ============================================================

    X_user_norm = ...
        (X_user - X_mean) ./ X_std;


    %% ============================================================
    % ML PREDICTIONS
    % ============================================================

    ML_Alpha_norm = ...
        predict(models{1},X_user_norm);


    ML_Beta_norm = ...
        predict(models{2},X_user_norm);


    ML_Z0Real_norm = ...
        predict(models{3},X_user_norm);


    ML_Z0Imag_norm = ...
        predict(models{4},X_user_norm);


    %% ============================================================
    % DENORMALIZE ML OUTPUTS
    % ============================================================

    ML_Alpha = ...
        ML_Alpha_norm * Y_std(1) + Y_mean(1);


    ML_Beta = ...
        ML_Beta_norm * Y_std(2) + Y_mean(2);


    ML_Z0Real = ...
        ML_Z0Real_norm * Y_std(3) + Y_mean(3);


    ML_Z0Imag = ...
        ML_Z0Imag_norm * Y_std(4) + Y_mean(4);


    ML_Z0 = ...
        ML_Z0Real + 1i*ML_Z0Imag;


    %% ============================================================
    % ML ABSOLUTE ERRORS
    % ============================================================

    ML_Alpha_Error = ...
        abs(ML_Alpha - alpha);


    ML_Beta_Error = ...
        abs(ML_Beta - beta);


    ML_Z0Real_Error = ...
        abs(ML_Z0Real - real(Z0));


    ML_Z0Imag_Error = ...
        abs(ML_Z0Imag - imag(Z0));


    %% ============================================================
    % ML RELATIVE ERRORS
    % ============================================================

    ML_Alpha_RelError = ...
        100 * ML_Alpha_Error / ...
        max(abs(alpha),1e-12);


    ML_Beta_RelError = ...
        100 * ML_Beta_Error / ...
        max(abs(beta),1e-12);


    ML_Z0Real_RelError = ...
        100 * ML_Z0Real_Error / ...
        max(abs(real(Z0)),1e-12);


    ML_Z0Imag_RelError = ...
        100 * ML_Z0Imag_Error / ...
        max(abs(imag(Z0)),1e-12);


    %% ============================================================
    % DISPLAY RESULTS
    % ============================================================

    resultsArea.Value = { ...

        '============================================================'; ...
        '          TRANSMISSION LINE ANALYZER RESULTS'; ...
        '============================================================'; ...
        ' '; ...

        '--- INPUT PARAMETERS ---'; ...
        sprintf('Frequency              = %.6g GHz',f/1e9); ...
        sprintf('R                      = %.6g Ohm/m',R); ...
        sprintf('L                      = %.6g uH/m',L*1e6); ...
        sprintf('G                      = %.6g S/m',G); ...
        sprintf('C                      = %.6g pF/m',C*1e12); ...
        sprintf('Line Length             = %.6g m',line_length); ...
        sprintf('Load Impedance         = %.6f %+.6fj Ohm', ...
            real(ZL),imag(ZL)); ...
        ' '; ...

        '--- ANALYTICAL TRANSMISSION-LINE RESULTS ---'; ...
        sprintf('Angular Frequency      = %.6e rad/s',omega); ...
        sprintf('Propagation Constant γ = %.6f %+.6fj /m', ...
            real(gamma),imag(gamma)); ...
        sprintf('Attenuation α          = %.6f Np/m',alpha); ...
        sprintf('Phase Constant β       = %.6f rad/m',beta); ...
        sprintf('Wavelength λ           = %.6f m',wavelength); ...
        sprintf('Characteristic Z0      = %.6f %+.6fj Ohm', ...
            real(Z0),imag(Z0)); ...
        sprintf('Reflection Γ           = %.6f %+.6fj', ...
            real(Gamma),imag(Gamma)); ...
        sprintf('|Γ|                    = %.6f',Gamma_mag); ...
        sprintf('Phase(Γ)               = %.6f deg',Gamma_phase); ...
        sprintf('VSWR                   = %.6f',VSWR); ...
        sprintf('Return Loss            = %.6f dB',ReturnLoss); ...
        sprintf('Input Impedance Zin    = %.6f %+.6fj Ohm', ...
            real(Zin),imag(Zin)); ...
        ' '; ...

        '--- VOLTAGE / CURRENT ---'; ...
        sprintf('Load Voltage VL        = %.6f %+.6fj V', ...
            real(VL),imag(VL)); ...
        sprintf('Load Current IL        = %.6e %+.6ej A', ...
            real(IL),imag(IL)); ...
        sprintf('Input Voltage Vin      = %.6f %+.6fj V', ...
            real(Vin),imag(Vin)); ...
        sprintf('Input Current Iin      = %.6e %+.6ej A', ...
            real(Iin),imag(Iin)); ...
        ' '; ...

        '--- POWER RESULTS ---'; ...
        sprintf('Incident Power         = %.6e W',P_incident); ...
        sprintf('Reflected Power       = %.6e W',P_reflected); ...
        sprintf('Load Power             = %.6e W',P_load); ...
        sprintf('Power Reflection Coef = %.6f', ...
            PowerReflectionCoefficient); ...
        sprintf('Power Transmission Coef= %.6f', ...
            PowerTransmissionCoefficient); ...
        ' '; ...

        '--- ATTENUATION ---'; ...
        sprintf('Attenuation            = %.6f Np',attenuation_Np); ...
        sprintf('Attenuation            = %.6f dB',attenuation_dB); ...
        sprintf('Voltage Attenuation    = %.6f',attenuation_factor); ...
        sprintf('Power Attenuation      = %.6f', ...
            power_attenuation_factor); ...
        ' '; ...

        '--- ANALYTICAL VERIFICATION ---'; ...
        sprintf('Input impedance error  = %.6e Ohm', ...
            impedance_error_input); ...
        sprintf('Load impedance error   = %.6e Ohm', ...
            impedance_error_load); ...
        ' '; ...

        '--- NEURAL NETWORK PREDICTION ---'; ...
        sprintf('ML Alpha               = %.8f Np/m',ML_Alpha); ...
        sprintf('ML Beta                = %.8f rad/m',ML_Beta); ...
        sprintf('ML Z0 Real             = %.8f Ohm',ML_Z0Real); ...
        sprintf('ML Z0 Imag             = %.8f Ohm',ML_Z0Imag); ...
        ' '; ...

        '--- ML ABSOLUTE ERROR ---'; ...
        sprintf('Alpha Error            = %.6e',ML_Alpha_Error); ...
        sprintf('Beta Error             = %.6e',ML_Beta_Error); ...
        sprintf('Z0 Real Error          = %.6e Ohm', ...
            ML_Z0Real_Error); ...
        sprintf('Z0 Imag Error          = %.6e Ohm', ...
            ML_Z0Imag_Error); ...
        ' '; ...

        '--- ML RELATIVE ERROR ---'; ...
        sprintf('Alpha Relative Error   = %.4f %%', ...
            ML_Alpha_RelError); ...
        sprintf('Beta Relative Error    = %.4f %%', ...
            ML_Beta_RelError); ...
        sprintf('Z0 Real Relative Error = %.4f %%', ...
            ML_Z0Real_RelError); ...
        sprintf('Z0 Imag Relative Error = %.4f %%', ...
            ML_Z0Imag_RelError); ...
        ' '; ...

        '--- TEST-SET ML PERFORMANCE ---'; ...
        sprintf('Alpha Test R2          = %.6f',Results.R2(1)); ...
        sprintf('Beta Test R2           = %.6f',Results.R2(2)); ...
        sprintf('Z0 Real Test R2        = %.6f',Results.R2(3)); ...
        sprintf('Z0 Imag Test R2        = %.6f',Results.R2(4)); ...
        ' '; ...

        'The ML model predicts the fundamental'; ...
        'transmission-line parameters.'; ...
        'Derived parameters are calculated using'; ...
        'the analytical transmission-line equations.'; ...

        '============================================================'};


    %% ============================================================
    % DETERMINE WAVEFORM PLOT RANGE
    % ============================================================

    if isfinite(wavelength) && wavelength > 0

        % Show maximum five wavelengths for clear visualization

        plot_length = ...
            min(line_length,5*wavelength);

    else

        plot_length = line_length;

    end


    if plot_length <= 0

        plot_length = line_length;

    end


    z = linspace(0,plot_length,1200);


    %% ============================================================
    % VOLTAGE WAVES
    % ============================================================

    V_incident = ...
        Vplus .* exp(gamma*z);


    V_reflected = ...
        Vminus .* exp(-gamma*z);


    V_total = ...
        V_incident + V_reflected;


    %% ============================================================
    % CURRENT WAVES
    % ============================================================

    I_incident = ...
        V_incident ./ Z0;


    I_reflected = ...
        -V_reflected ./ Z0;


    I_total = ...
        I_incident + I_reflected;


    %% ============================================================
    % VOLTAGE WAVE PLOT
    % ============================================================

    cla(axVoltage);

    plot( ...
        axVoltage, ...
        z, ...
        abs(V_incident), ...
        'LineWidth',1.5);

    hold(axVoltage,'on');


    plot( ...
        axVoltage, ...
        z, ...
        abs(V_reflected), ...
        'LineWidth',1.5);


    plot( ...
        axVoltage, ...
        z, ...
        abs(V_total), ...
        'LineWidth',2);


    hold(axVoltage,'off');


    title( ...
        axVoltage, ...
        'Incident, Reflected and Total Voltage');


    xlabel( ...
        axVoltage, ...
        'Distance from Load (m)');


    ylabel( ...
        axVoltage, ...
        '|V(z)| (V)');


    legend( ...
        axVoltage, ...
        'Incident Wave', ...
        'Reflected Wave', ...
        'Total Wave', ...
        'Location','best');


    grid(axVoltage,'on');


    %% ============================================================
    % STANDING WAVE
    % ============================================================

    cla(axStanding);


    plot( ...
        axStanding, ...
        z, ...
        abs(V_total), ...
        'LineWidth',2);


    hold(axStanding,'on');


    yline( ...
        axStanding, ...
        max(abs(V_total)), ...
        '--', ...
        'Vmax');


    yline( ...
        axStanding, ...
        min(abs(V_total)), ...
        '--', ...
        'Vmin');


    hold(axStanding,'off');


    title( ...
        axStanding, ...
        sprintf('Standing Wave (VSWR = %.4f)',VSWR));


    xlabel( ...
        axStanding, ...
        'Distance from Load (m)');


    ylabel( ...
        axStanding, ...
        '|V(z)| (V)');


    grid(axStanding,'on');


    %% ============================================================
    % CURRENT WAVE
    % ============================================================

    cla(axCurrent);


    plot( ...
        axCurrent, ...
        z, ...
        abs(I_incident), ...
        'LineWidth',1.3);


    hold(axCurrent,'on');


    plot( ...
        axCurrent, ...
        z, ...
        abs(I_reflected), ...
        'LineWidth',1.3);


    plot( ...
        axCurrent, ...
        z, ...
        abs(I_total), ...
        'LineWidth',2);


    hold(axCurrent,'off');


    title( ...
        axCurrent, ...
        'Incident, Reflected and Total Current');


    xlabel( ...
        axCurrent, ...
        'Distance from Load (m)');


    ylabel( ...
        axCurrent, ...
        '|I(z)| (A)');


    legend( ...
        axCurrent, ...
        'Incident Current', ...
        'Reflected Current', ...
        'Total Current', ...
        'Location','best');


    grid(axCurrent,'on');


    %% ============================================================
    % TIME DOMAIN VOLTAGE
    % ============================================================

    T = 1/f;


    t = linspace(0,2*T,1200);


    V_time_complex = ...
        VL .* exp(1i*omega*t);


    V_time = ...
        real(V_time_complex);


    cla(axTime);


    plot( ...
        axTime, ...
        t*1e9, ...
        V_time, ...
        'LineWidth',2);


    title( ...
        axTime, ...
        'Time-Domain Voltage at Load');


    xlabel( ...
        axTime, ...
        'Time (ns)');


    ylabel( ...
        axTime, ...
        'Voltage (V)');


    grid(axTime,'on');


    %% ============================================================
    % UPDATE FIGURES
    % ============================================================

    drawnow;

end


%% ================================================================
% RESET FUNCTION
% ================================================================

function resetValues(~,~)

    freqField.Value = 1.0;

    RField.Value = 0.5;

    LField.Value = 0.2;

    GField.Value = 0;

    CField.Value = 100;

    lengthField.Value = 100;

    ZLRField.Value = 100;

    ZLXField.Value = 0;


    resultsArea.Value = { ...
        '================================================'; ...
        '       TRANSMISSION LINE ANALYZER'; ...
        '================================================'; ...
        ' '; ...
        'Values have been reset to the default example.'; ...
        ' '; ...
        'Click ANALYZE TRANSMISSION LINE.'};


    cla(axVoltage);

    cla(axStanding);

    cla(axCurrent);

    cla(axTime);


    title(axVoltage, ...
        'Incident, Reflected and Total Voltage');


    title(axStanding, ...
        'Standing-Wave Voltage Pattern');


    title(axCurrent, ...
        'Transmission-Line Current');


    title(axTime, ...
        'Time-Domain Voltage at Load');

end

end