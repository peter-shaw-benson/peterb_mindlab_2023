%% initialization
clear; clc; close all

% change this to the directory of MIRtoolbox
addpath(genpath('/home/kathios.n/MIRtoolbox1.8.1'));
% change this to the directory of SignalProcessing
addpath(genpath('/home/kathios.n/signal-processing-toolbox'));
% change this to the directory of stats and machinelearning
addpath(genpath('/home/kathios.n/signal-processing-toolbox'));

% global variables

output_dir = '/scratch/benson.p/data/processed_mp3s';
playlists = 

% read in file of participants
fileID = fopen('.txt','r');


% iterate through each participant 

% each playlist

% parallelize analyzing each song?