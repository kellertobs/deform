%*****  Run DEFORM – rock deformation model  ******************************

clear all; clc;  % clear workspace
    
% read in default parameter choices and runtime options
par_DEFORM

%**************************************************************************


%*****  EDIT MODEL PARAMETERS  ********************************************

% set run identifier tag (output figures saved to folder deform/out/'RunID')
CTX.IO.RunID      =  'demo480';  % change RunID for every parameter test

% set seed for random number generator
rng(5);  % change the random seed -> rng('number of your choice') to produce uniquely randomised results

% switch 'ON'/'OFF' to plot results live during simulation
CTX.IO.LivePlot   =  'ON';    % if set 'OFF' selected figures are still printed to output directory

% set interval of time steps when to plot and store figures
CTX.IO.nwrite     =  10;     % try 1 to plot/print figures every step for testing, 10 or 20 for full run

% choose number of elements in vertical dimension
N                 =  480;    % try values of 80, 120, 160, 240

% set time step and model stopping time in [yr]
CTX.TIME.step     =  1e3;    % try values of 500, 1000, 2000
CTX.TIME.end      =  5e5;    % try 20,000 for testing, up to 500,000 for full run

% set applied boundary stress relative to plastic yield strength at surface
T                 =  -4;     % try values of +/- 1/2, 1, 2, 4

%**************************************************************************


%*****  DO NOT EDIT BELOW  ************************************************

% get characteristic yield strength at reservoir depth
Y                 = (CTX.PROP.Coh(2)+CTX.PROP.Frict(2)*CTX.PHYS.grav*CTX.PROP.Rho(2)*CTX.INIT.SrcZLoc/2);

% set applied shear rate [1/s] according to tectonic stress number, T
CTX.BC.BGStrainr  =  T*Y/(CTX.PROP.Eta(2));

% set numerical mesh size
CTX.FE.nx         =  N;
CTX.FE.nz         =  N;

% convert time step and stopping time from years to seconds
CTX.TIME.step     =  1e3 * CTX.TIME.spyr;
CTX.TIME.end      =  5e5 * CTX.TIME.spyr;

% set smoothness of random noise depending on mesh size
CTX.INIT.PertSmooth  =  N^2/300;  

% adjust reference plastic damage to resolution
CTX.RHEO.Dmg0        =  0.05.*N/100;

% create output directory
if ~isfolder(['../out/',CTX.IO.RunID]); mkdir(['../out/',CTX.IO.RunID]); end

% run simulation code
run('../src/DEFORM.m')
    