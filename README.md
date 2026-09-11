# Transmission Line Analyzer

A MATLAB-based **Transmission Line Analyzer** developed for **EC3104 Engineering Electromagnetics – Module 1**.

This project combines analytical transmission-line calculations, waveform visualization, dataset generation, machine-learning regression, validation, and an interactive MATLAB GUI.

> **Scope:** Transmission Line Module 1 analysis. **Smith Chart analysis is excluded.**

---

## 📌 Project Overview

The Transmission Line Analyzer is a computational framework for analyzing transmission-line behavior for different line and load parameters.

The analyzer accepts transmission-line parameters such as frequency, distributed resistance, inductance, conductance, capacitance, line length, and load impedance.

It calculates important transmission-line parameters including:

- Propagation constant `γ`
- Attenuation constant `α`
- Phase constant `β`
- Characteristic impedance `Z₀`
- Wavelength `λ`
- Reflection coefficient `Γ`
- Reflection coefficient magnitude and phase
- VSWR
- Return loss
- Input impedance `Zin`
- Load voltage and current
- Input voltage and current
- Incident power
- Reflected power
- Load power
- Power reflection coefficient
- Power transmission coefficient
- Line attenuation
- Voltage waves
- Current waves
- Standing-wave patterns
- Time-domain voltage waveform

The project also integrates a neural-network regression model for predicting fundamental transmission-line parameters.

---

## 🎯 Objectives

The main objectives of this project are:

1. Implement the major Transmission Line Module 1 analytical calculations in MATLAB.
2. Develop an algorithm capable of calculating desired transmission-line parameters.
3. Generate and visualize voltage and current waveforms.
4. Generate a dataset for machine-learning training.
5. Validate the generated dataset for numerical and physical consistency.
6. Train neural-network regression models.
7. Evaluate the ML model using test-set performance metrics.
8. Integrate ML predictions with the analytical transmission-line equations.
9. Develop an interactive MATLAB analysis window.
10. Verify the analytical implementation using numerical consistency checks and a matched-load test.
11. Document the complete analysis, algorithms, results, and source code.

---

## 🧮 Mathematical Model

### Angular Frequency

The angular frequency is calculated as:

```text
ω = 2πf
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
| File                           | Description                                                                |
| ------------------------------ | -------------------------------------------------------------------------- |
| `transmission_line_analysis.m` | Performs analytical transmission-line calculations and waveform generation |
| `generate_dataset.m`           | Generates the dataset used for machine-learning training                   |
| `validate_dataset.m`           | Validates the generated dataset and checks physical consistency            |
| `train_model.m`                | Trains and evaluates the neural-network regression models                  |
| `final_analysis_window.m`      | Interactive MATLAB GUI for final transmission-line analysis                |

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
             Attenuation     Phase
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
               VSWR       Return Loss
                        │
                        ▼
                Input Impedance Zin
                        │
             ┌──────────┴──────────┐
             ▼                     ▼
       Voltage Waves          Current Waves
             │                     │
             └──────────┬──────────┘
                        ▼
                  Power Analysis
                        │
                        ▼
                Attenuation Analysis
                        │
                        ▼
                Waveform Generation
                        │
                        ▼
                    Verification
The Transmission Line Analyzer provides an end-to-end computational framework for Transmission Line Module 1 analysis.

The complete system combines:
Transmission-Line Theory
        +
MATLAB Analytical Computation
        +
Waveform Visualization
        +
Dataset Generation
        +
Machine Learning
        +
Model Validation
        +
Analytical + ML Integration
        +
Interactive GUI
The final system accepts transmission-line and load parameters, performs analytical calculations, uses trained neural-network models to predict fundamental parameters, derives the remaining physical quantities using transmission-line equations, and visualizes the resulting voltage, current, standing-wave, and time-domain behavior.
