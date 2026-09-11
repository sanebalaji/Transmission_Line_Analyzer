Transmission Line Analyzer

A MATLAB-based Transmission Line Analyzer developed for EC3104 Engineering Electromagnetics – Module 1.

The project combines analytical transmission-line calculations, waveform visualization, dataset generation, machine-learning regression, validation, and an interactive MATLAB GUI.

Scope: Transmission Line Module 1 analysis. Smith Chart analysis is excluded.

📌 Project Overview

This project implements a complete computational workflow for transmission-line analysis.

Given the transmission-line parameters and load impedance, the analyzer calculates:

Propagation constant γ
Attenuation constant α
Phase constant β
Characteristic impedance Z₀
Wavelength λ
Load reflection coefficient Γ
Reflection coefficient magnitude and phase
VSWR
Return loss
Input impedance Zin
Load voltage and current
Input voltage and current
Incident, reflected, and load power
Power reflection and transmission coefficients
Line attenuation
Voltage and current waves
Standing-wave patterns
Time-domain voltage waveform

The project also integrates a neural-network regression model to predict fundamental transmission-line parameters and combines those predictions with analytical transmission-line equations.

🎯 Objectives

The main objectives are:

Implement the Module 1 transmission-line analytics in MATLAB.
Develop an algorithm capable of calculating desired transmission-line parameters for different input conditions.
Plot the required voltage, current, and standing-wave waveforms.
Generate a minimum 100-point dataset for machine-learning training.
Train a regression model and evaluate its performance.
Integrate the ML model with the analytical transmission-line calculations.
Provide an interactive final analysis window.
Verify the analytical calculations using consistency and matched-load tests.
Document the complete algorithm, results, code, and execution procedure.
🧮 Mathematical Model
Angular Frequency
ω = 2πf
Propagation Constant
γ = √[(R + jωL)(G + jωC)]

where:

γ = α + jβ
α = attenuation constant in Np/m
β = phase constant in rad/m
Characteristic Impedance
Z₀ = √[(R + jωL)/(G + jωC)]
Wavelength
λ = 2π/β
Reflection Coefficient
ΓL = (ZL − Z₀)/(ZL + Z₀)
VSWR
VSWR = (1 + |ΓL|)/(1 − |ΓL|)
Return Loss
Return Loss = −20 log₁₀(|ΓL|)
General Input Impedance
Zin = Z₀ [ZL + Z₀ tanh(γl)] /
          [Z₀ + ZL tanh(γl)]
Transmission-Line Waves
V(z) = V⁺(z) + V⁻(z)

I(z) = V⁺(z)/Z₀ − V⁻(z)/Z₀
📂 Repository Structure
Transmission_Line_Analyzer/
│
└── matlab/
    │
    ├── transmission_line_analysis.m
    ├── generate_dataset.m
    ├── validate_dataset.m
    ├── train_model.m
    ├── final_analysis_window.m
    │
    ├── transmission_line_dataset.csv
    ├── transmission_line_dataset.mat
    └── transmission_line_ML_model.mat
MATLAB Files
File	Description
transmission_line_analysis.m	Main analytical transmission-line calculations and waveform generation
generate_dataset.m	Generates the transmission-line dataset used for ML
validate_dataset.m	Validates dataset dimensions, numerical values, and physical consistency
train_model.m	Trains and evaluates neural-network regression models
final_analysis_window.m	Interactive MATLAB GUI for final transmission-line analysis
Generated Data / Model Files
File	Description
transmission_line_dataset.csv	Dataset in CSV format
transmission_line_dataset.mat	Dataset stored in MATLAB format
transmission_line_ML_model.mat	Trained neural-network models
🔄 Overall Workflow
                    INPUT PARAMETERS
                           │
                           ▼
                 Angular Frequency
                           │
                           ▼
                Propagation Constant γ
                           │
                    ┌──────┴──────┐
                    ▼             ▼
                    α             β
                    │             │
                    └──────┬──────┘
                           ▼
              Characteristic Impedance Z₀
                           │
                           ▼
                     Wavelength λ
                           │
                           ▼
                Reflection Coefficient Γ
                           │
                    ┌──────┴──────┐
                    ▼             ▼
                  VSWR        Return Loss
                           │
                           ▼
                  Input Impedance Zin
                           │
             ┌─────────────┴─────────────┐
             ▼                           ▼
       Voltage Waves               Current Waves
             │                           │
             └─────────────┬─────────────┘
                           ▼
                    Power Analysis
                           │
                           ▼
                  Attenuation Analysis
                           │
                           ▼
                  Waveform Visualization
                           │
                           ▼
                       Verification
🤖 Machine Learning Workflow

The ML part uses the following eight input features:

Frequency
R
L
G
C
Line Length
Load Resistance
Load Reactance

The neural-network regression models predict the fundamental transmission-line parameters:

α
β
Real(Z₀)
Imag(Z₀)

The predicted fundamental parameters are then used together with the analytical transmission-line equations to obtain derived quantities such as:

Reflection coefficient
VSWR
Return loss
Input impedance
Power
Attenuation
Waveforms

This design avoids independently predicting every derived quantity and keeps the final analysis physically consistent with the transmission-line equations.

🧠 ML Model

The implemented MATLAB regression approach uses fitrnet.

Network Configuration
Model type        : Neural-network regression
Hidden layers     : [30 20]
Activation        : ReLU
Input processing  : Normalized
Output processing : Normalized
Train/Test split  : 80/20

Separate regression models are trained for:

1. Alpha
2. Beta
3. Real(Z0)
4. Imag(Z0)

The final test-set evaluation achieved an R² above the required 0.97 threshold for the four fundamental predicted parameters.

📊 Dataset

The final ML workflow uses a generated dataset containing:

5000 samples
26 columns
8 input features
Analytical transmission-line output parameters

The dataset is split into:

80% → Training
20% → Testing

The dataset validation checks:

Number of rows
Number of columns
Missing values
NaN values
Infinite values
Reflection-coefficient range
VSWR range
Power consistency
Reflection/transmission coefficient consistency
Physical parameter ranges
🧪 Verification

The analytical implementation includes numerical consistency checks.

Input Impedance Check
Zin ≈ Vin / Iin
Load Impedance Check
ZL ≈ VL / IL
Matched Load Test

For:

ZL = Z₀

the expected result is:

Γ = 0
VSWR = 1

These checks are used to verify the correctness of the implemented analytical equations.

🖥️ Final MATLAB GUI

The final analysis window allows the user to enter:

Frequency (GHz)
R (Ω/m)
L (μH/m)
G (S/m)
C (pF/m)
Line Length (m)
Load Resistance (Ω)
Load Reactance (Ω)

The GUI displays analytical and ML results and provides waveform tabs for:

Voltage Waves
Standing Wave
Current
Time Domain

The GUI follows the architecture:

User Inputs
     │
     ├──────────────► Analytical Model
     │                     │
     │                     ▼
     │              Fundamental Results
     │
     └──────────────► ML Model
                           │
                           ▼
                  Fundamental Predictions
                           │
                           ▼
                Analytical Derived Parameters
                           │
                           ▼
                    Final Results + Plots
🔬 Example Analysis Case

One verified analysis case uses:

Parameter	Value
Frequency	1 GHz
R	0.5 Ω/m
L	0.2 μH/m
G	0 S/m
C	100 pF/m
Line Length	100 m
Load	100 + j0 Ω

The analytical calculation gives approximately:

γ       = 0.005590 + j28.099259 /m
α       = 0.005590 Np/m
β       = 28.099259 rad/m
λ       = 0.223607 m
Z₀      = 44.721360 − j0.008897 Ω
|Γ|     = 0.381966
VSWR    = 2.236068
Return Loss = 8.359506 dB
Zin     = 35.512574 − j3.987437 Ω

The same analysis window also calculates the load/input voltage and current, power quantities, attenuation, and waveform data.

▶️ How to Run

Open MATLAB and set the working directory to:

Transmission_Line_Analyzer/matlab
1. Run Analytical Analysis
transmission_line_analysis

This performs the analytical calculations and generates the required waveforms.

2. Generate Dataset
generate_dataset

This creates the dataset used by the ML workflow.

3. Validate Dataset
validate_dataset

This checks the generated dataset for numerical and physical consistency.

4. Train ML Model
train_model

This trains the neural-network regression models and evaluates their test-set performance.

5. Open Final Analyzer
final_analysis_window

This opens the interactive MATLAB transmission-line analysis window.

📈 Outputs

The project produces:

Analytical numerical results
Voltage-wave plots
Current-wave plots
Voltage magnitude plots
Current magnitude plots
Standing-wave patterns
Time-domain voltage plots
ML prediction results
Model performance metrics
Final GUI analysis
🛠️ Requirements
MATLAB
MATLAB Statistics and Machine Learning Toolbox
A MATLAB version supporting fitrnet
Basic familiarity with transmission-line theory
📚 Module 1 Topics Covered

The implementation covers the major computational aspects of Transmission Line Module 1:

Distributed transmission-line model
Per-unit-length parameters R, L, G, C
Telegrapher-equation-based propagation
Propagation constant
Attenuation constant
Phase constant
Lossless-line concepts
Forward and reflected waves
Characteristic impedance
Load impedance
Reflection coefficient
Matched load
VSWR
Return loss
Input impedance
Voltage/current waves
Power flow
Attenuation
MATLAB visualization

Smith Chart analysis is intentionally excluded.

👤 Author

sanebalaji

GitHub Repository:

Transmission_Line_Analyzer

📄 Project Documentation

The complete project report contains:

Objective and scope
Mathematical model
Program structure
Analytical implementation
Dataset generation
Dataset validation
ML methodology
ML performance
Final analysis case
GUI and analytical/ML integration
Waveform results
Verification
Reproducibility and execution commands
Complete source-code appendices
⭐ Project Summary

Transmission Line Analyzer provides an end-to-end computational framework for Module 1 transmission-line analysis.

The system combines:

Transmission-Line Theory
        +
MATLAB Analytical Computation
        +
Waveform Visualization
        +
Dataset Generation
        +
Neural-Network Regression
        +
Model Validation
        +
Interactive GUI

The final system accepts a set of transmission-line parameters, calculates the analytical response, uses the trained ML model to predict fundamental parameters, derives the remaining physical quantities, and visualizes the resulting transmission-line behavior.
