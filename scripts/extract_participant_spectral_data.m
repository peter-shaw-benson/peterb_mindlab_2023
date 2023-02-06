%% initialization
clear; clc; close all

% change this to the directory of MIRtoolbox
addpath(genpath('/home/benson.p/matlab/MIRtoolbox1.8.1'));
% change this to the directory of SignalProcessing
addpath(genpath('/home/benson.p/matlab/signal'));

% global variables
input_dir = '/scratch/benson.p/data/gamma_mbi_2023_youtube_files'
output_dir = '/scratch/benson.p/data/processed_mp3s';
playlists = {'relaxing', 'energizing'};

% read in file of participants
fileID = fopen('data/participants.txt','r');
[participants, count] = textscan(fileID, '%s');
participants = participants{1, 1};
fclose(fileID);

% iterate through each participant 
% parallelize this, change to a parfor
parfor sub=1:length(participants)
    cur_participant = participants{sub};
    % get participant

    % get playlist
    for p=1:length(playlists)
        current_playlist = playlists{p};

        song_path = fullfile(input_dir, cur_participant, current_playlist);
        % song path is input directory, participant, playlist.

        output_file_name = cur_participant + '_' + current_playlist + '_audioFeatures.csv';
        disp('extracting audio features from' + cur_participant + 'on playlist ' + current_playlist)
        % SONG EXTRACTOR
        extract_song_audio(song_path, output_dir, output_file_name);
    end
end