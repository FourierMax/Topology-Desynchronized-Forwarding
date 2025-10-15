# Network Routing Performance Analysis Results

This folder contains experimental results and visualization code for network routing algorithm performance analysis.

## File Structure

### Data Files (.mat)
All  the .mat files are the running results in this paper by the authors so the readers can run the .m files to analyze the data and generate the figures directly.

### Main Code Files
- `Result_show_link_loss.m` - Packet loss rate performance comparison analysis
- `Result_show_link_RF.m` - RF forwarding performance analysis
- `Result_show_link_topo16.m` - Detailed performance analysis for 16x16 topology

## Algorithm Description

- **MPC0 (NF)**: Normal forwarding forwarding algorithm (baseline)
- **MPC1_side (RF-LF)**: Lateral-facing first forwarding algorithm
- **MPC1_oppo (RF-CF)**: Counter-facing first forwarding algorithm  
- **LFA**: Loop-Free Alternate routing algorithm

## Getting Started

### Prerequisites
- MATLAB R2018b or higher
- Curve Fitting Toolbox (for data fitting)

### Running
```matlab
% show the loss rate of link failure condition
run('Result_show_link_loss.m')