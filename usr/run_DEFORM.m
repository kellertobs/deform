%[text] # Run DEFORM – Rock Deformation Model
%%
clear all; close all; clc;  % clear workspace

par_DEFORM  % read in default parameters and runtime options
%%
%[text] ## 
%[text] ## Edit Model Parameters
%[text] 
%[text] Set run identifier tag. Output figures will be saved to folder `deform/out/runID`. Set new identifier for every model run (don't include spaces in your identifier tag!)
%%
runID  =  'demo';  % change run identifier for every parameter test to save separate results %[control:editfield:51ef]{"position":[11,17]}
%%
%[text] 
%[text] Set seed for random number generator. Adjust the slider to your favourite number to produce uniquely randomised results.
%%
rng(10);  % change the random seed %[control:slider:8641]{"position":[5,7]}
%%
%[text] 
%[text] Set interval of time steps between plotting and saving figures. Select lower interval for testing, higher for full model run.
%%
nwrite  =  10;  % select lower interval for testing, higher interval for full run %[control:dropdown:140e]{"position":[12,14]}
%%
%[text] 
%[text] Set the grid size by choosing the number of elements in the vertical dimension. Select smaller grid size (lower resolution) for testing, higher for full model run.
%%
N  =  120;  % select lower resolution for testing, higher resolution for full run %[control:dropdown:29b7]{"position":[7,10]}
%%
%[text] 
%[text] Set model aspect ratio, i.e. width to depth of model domain. Select lower aspect ratio for faulting, higher for folding.
%%
aspect = 2;  % select lower aspect ratio for faulting, higher for folding %[control:dropdown:3ecc]{"position":[10,11]}

% set model domain width
CTX.FE.W             =  aspect/2*CTX.FE.D;
%%
%[text] 
%[text] Choose finite element type (Q1P0: linear V, piece-wise constant P; Q1Q1: linear V, linear P; Q2Q1: quadratic V, linear P).
%%
eltype = 'Q1P0'; %[control:dropdown:4d95]{"position":[10,16]}
%%
%[text] 
%[text] Set model stopping time in years. Select shorter stopping time for testing, higher for full run. Note that model will stop automatically if grid distortion around faults exceeds a threshold.
%%
tend  =  1e6;  % select shorter stopping time for testing, higher for full run %[control:dropdown:5650]{"position":[10,13]}
%%
%[text] 
%[text] Set layer viscosities (resistance to creep) for base detachment layer (1) and upper layer stack (2,3). Select lower viscosity for detachment layer, higher for upper layers.
%%
Eta  =  [1e20;1e22;1e23];  % set lower viscosity for detachment layer, higher for upper layers %[control:dropdown:0774]{"position":[10,14]} %[control:dropdown:7a61]{"position":[15,19]} %[control:dropdown:6be4]{"position":[20,24]}
%%
%[text] 
%[text] Set tectonic stress magnitude applied on boundaries relative to plastic yield strength at the surface. Select higher magnitude for more pronounced failure. Examine results to detect what sign (+/–) of the tectonic stress factor produces extensional and compressional tectonics!
%%
T  =  -4;  % select higher magnitude for more pronounced failure %[control:dropdown:6323]{"position":[7,9]}
%%
%[text] ### 
%[text] Set Gaussian peak as initial topography, with peak height set relative to domain depth, and peak width relative to domain width.
%%
TopoHeight  =  0* CTX.FE.D;                % set height for initial topography %[control:slider:67d7]{"position":[16,17]}
TopoWidth   =  0.5* CTX.FE.W;              % set width for initial topography %[control:slider:9c54]{"position":[16,19]}
%%
% set output options
CTX.IO.RunID         =  runID;
CTX.IO.nwrite        =  nwrite;

% set rock layer viscosities
CTX.PROP.Eta         =  Eta;

% get characteristic yield strength at surface
Y                    = (CTX.PROP.Coh(3)+CTX.PROP.Frict(3)*CTX.BC.SurfPres);

% set applied shear rate [1/s] according to tectonic stress number, T
CTX.BC.BGStrainr     =  T*Y/max(CTX.PROP.Eta);

% set width and x-location for slight initial topography
CTX.INIT.TopoHeight  =  TopoHeight;
CTX.INIT.TopoWidth   =  TopoWidth;
CTX.INIT.TopoXLoc    =  CTX.FE.W;

% set numerical mesh size
CTX.FE.nx            =  aspect/2*N;
CTX.FE.nz            =  N;
CTX.FE.ElType        =  eltype;

% convert time step and stopping time from years to seconds
CTX.TIME.step        =  4e3/abs(T) * CTX.TIME.spyr;
CTX.TIME.end         =  tend       * CTX.TIME.spyr;

% set smoothness of random noise depending on mesh size
CTX.INIT.PertSmooth  =  N^2/300;  

% adjust reference plastic damage to resolution
CTX.RHEO.Dmg0        =  0.1.*N/120;

% create output directory
if ~isfolder(['../out/',CTX.IO.RunID]); mkdir(['../out/',CTX.IO.RunID]); end

% run simulation code
run('../src/DEFORM.m')

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"hidecode","rightPanelPercent":40}
%---
%[control:editfield:51ef]
%   data: {"defaultValue":"'demo'","label":"Run ID","run":"Section","valueType":"Char"}
%---
%[control:slider:8641]
%   data: {"defaultValue":10,"label":"Random Seed","max":20,"min":0,"run":"Nothing","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:140e]
%   data: {"defaultValue":"10","itemLabels":["1","2","5","10","20","50"],"items":["1","2","5","10","20","50"],"label":"Plot Interval","run":"Nothing"}
%---
%[control:dropdown:29b7]
%   data: {"defaultValue":"120","itemLabels":["80","120","160","240","320"],"items":["80","120","160","240","320"],"label":"Grid Size","run":"Nothing"}
%---
%[control:dropdown:3ecc]
%   data: {"defaultValue":"2","itemLabels":["2","4","8"],"items":["2","4","8"],"label":"Aspect Ratio","run":"Nothing"}
%---
%[control:dropdown:4d95]
%   data: {"defaultValue":"'Q1P0'","itemLabels":["Q1P0","Q1Q1","Q2Q1"],"items":["'Q1P0'","'Q1Q1'","'Q2Q1'"],"label":"Element Type","run":"Nothing"}
%---
%[control:dropdown:5650]
%   data: {"defaultValue":"1e6","itemLabels":["1e5","2e5","5e5","1e6","2e6","5e6"],"items":["1e5","2e5","5e5","1e6","2e6","5e6"],"label":"Stopping Time","run":"Nothing"}
%---
%[control:dropdown:0774]
%   data: {"defaultValue":"1e21","itemLabels":["1e18","1e19","1e20","1e21","1e22"],"items":["1e18","1e19","1e20","1e21","1e22"],"label":"Layer 1","run":"Nothing"}
%---
%[control:dropdown:7a61]
%   data: {"defaultValue":"1e23","itemLabels":["1e20","1e21","1e22","1e23","1e24"],"items":["1e20","1e21","1e22","1e23","1e24"],"label":"Layer 2","run":"Nothing"}
%---
%[control:dropdown:6be4]
%   data: {"defaultValue":"1e23","itemLabels":["1e20","1e21","1e22","1e23","1e24"],"items":["1e20","1e21","1e22","1e23","1e24"],"label":"Layer 3","run":"Nothing"}
%---
%[control:dropdown:6323]
%   data: {"defaultValue":"-4","itemLabels":["-4","-2","-1","1","2","4"],"items":["-4","-2","-1","1","2","4"],"label":"Tectonic Stress Factor","run":"Nothing"}
%---
%[control:slider:67d7]
%   data: {"defaultValue":0.01,"label":"Peak Height","max":0.5,"min":0,"run":"Nothing","runOn":"ValueChanging","step":0.01}
%---
%[control:slider:9c54]
%   data: {"defaultValue":0.5,"label":"Peak Width","max":0.5,"min":0.1,"run":"Nothing","runOn":"ValueChanging","step":0.01}
%---
