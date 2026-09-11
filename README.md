# Transmission Line Analyzer

A MATLAB-based **Transmission Line Analyzer** developed for **EC3104 Engineering Electromagnetics – Module 1**.

The project combines analytical transmission-line calculations, waveform visualization, dataset generation, machine-learning regression, validation, and an interactive MATLAB GUI.

> **Scope:** Transmission Line Module 1 analysis. **Smith Chart analysis is excluded.**

---

## 📌 Project Overview

This project implements a complete computational workflow for transmission-line analysis.

Given the transmission-line parameters and load impedance, the analyzer calculates important parameters such as:

- Propagation constant `γ`
- Attenuation constant `α`
- Phase constant `β`
- Characteristic impedance `Z₀`
- Wavelength `λ`
- Load reflection coefficient `Γ`
- Reflection coefficient magnitude and phase
- VSWR
- Return loss
- Input impedance `Zin`
- Load voltage and current
- Input voltage and current
- Incident, reflected, and load power
- Power reflection and transmission coefficients
- Line attenuation
- Voltage and current waves
- Standing-wave patterns
- Time-domain voltage waveform

The project also integrates a neural-network regression model to predict fundamental transmission-line parameters and combines those predictions with analytical transmission-line equations.

---

## 🎯 Objectives

The main objectives are:

1. Implement the Module 1 transmission-line analytics in MATLAB.
2. Develop an algorithm capable of calculating desired transmission-line parameters for different input conditions.
3. Plot the required voltage, current, and standing-wave waveforms.
4. Generate a minimum 100-point dataset for machine-learning training.
5. Train a regression model and evaluate its performance.
6. Integrate the ML model with the analytical transmission-line calculations.
7. Provide an interactive final analysis window.
8. Verify the analytical calculations using consistency and matched-load tests.
9. Document the complete algorithm, results, code, and execution procedure.

---

## 🧮 Mathematical Model

### Angular Frequency

```text
ω = 2πf
