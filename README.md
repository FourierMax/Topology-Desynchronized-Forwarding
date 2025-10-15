# Topology-Desynchronized Forwarding via Symmetry in Toroidal Networks

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2020b%2B-blue.svg)](https://www.mathworks.com/products/matlab.html)

This repository contains the official implementation of the paper **"Topology-desynchronized Forwarding via Symmetry in Toroidal Networks"** published in *Nature Communications*. The code provides simulation frameworks for evaluating reverse-flow forwarding mechanisms in torus topologies.

## 🌟 Overview

This work introduces a novel forwarding mechanism that leverages the inherent symmetries of toroidal networks to achieve reliable packet forwarding without topological synchronization. The proposed approach reduces packet loss by up to 17.5% in 16×16 torus networks with 1% link failure rate.

### Key Features
- **Symmetry-driven Forwarding**: Exploits rotational and reflection symmetries of 2D torus topologies
- **Reverse Flow Mechanisms**: Implements RF-CF (Counter-facing) and RF-LF (Lateral-facing) strategies
- **Protocol Independence**: Requires no modifications to packet headers or control plane
- **Comprehensive Simulation**: Supports both bond percolation (link failures) and site percolation (node failures)

This repository contains MATLAB implementations and experimental results for various forwarding algorithms:

- **NF (Normal Forwarding)**: Traditional shortest-path routing
- **RF (Random Forwarding)**: Topology-desynchronized approaches
  - RF-CF (Counter-facing)
  - RF-LF (Lateral-facing)
- **LFA (Loop-Free Alternates)**: Standard protection mechanism

## Project Structure
   Topology-Desynchronized-Forwarding/
   ├── src/ # Source code implementations
   ├── results/ # Experimental results and analysis
   │ ├── bond_percolation/ # Link failure experiments
   │ └── site_percolation/ # Node failure experiments
   └── examples/ # Usage examples and configurations

## 📋 Prerequisites

### Software Requirements
- MATLAB R2018b or later
- Curve Fitting Toolbox
- Statistics and Machine Learning Toolbox

### System Requirements
- Minimum 4GB RAM
- 2GB free disk space for simulation results


## Quick Start

1. **Run Simulations**:
   ```matlab
   % Navigate to src/ directory
   cd src/
   % Test different algorithms
   Test_NF_link.m    % Normal forwarding
   Test_RF_link.m    % Random forwarding  
   Test_LFA_link.m   % Loop-free alternates

2. **Analyze Results**:
   % Navigate to results directory
   cd ../results/bond_percolation/
   Result_show_link_loss.m    % Packet loss analysis
   Result_show_link_RF.m      % RF performance analysis


