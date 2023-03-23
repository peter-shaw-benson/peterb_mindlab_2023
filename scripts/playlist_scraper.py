import pandas as pd
from pytube import YouTube
import os

# downloads an mp3 of the given youtube video
def download_video(video_url, path, video_name):
    video_audio = YouTube(video_url).streams.filter(only_audio=True).first()
    
    # download the file
    out_file = video_audio.download(output_path=path, filename=video_name)

    # convert file to mp3

    # save the file as mp3
    base, ext = os.path.splitext(out_file)
    new_file = base + '.mp3'
    os.rename(out_file, new_file)

# make dictionary of participant: playlist: list of youtube links
def construct_participant_dict(participant_df):
    participant_dict = {}
    
    # construct dictionary structure
    for participant in participant_df['participant'].unique():
        participant_dict[participant] = {'energizing':[], 'relaxing': []}
    
    # go through each row
    for index, row in participant_df.iterrows():
        # get the necessary link
        #print(row)
        participant = row['participant']
        playlist = row['playlist_type']
        youtube_link = row['url']
        
        participant_dict[participant][playlist].append(youtube_link)
    
    return participant_dict

participant_df_location = '/Users/peterbenson/Documents/MIND Lab Peter Benson 2023/data/participant_playlists.csv'

participant_df = pd.read_csv(participant_df_location)
participant_df.rename(columns={'Unnamed: 0': 'video_id'}, inplace=True)

full_participant_dict = construct_participant_dict(participant_df)

source_directory = '/Users/peterbenson/Documents/MIND Lab Peter Benson 2023/scripts'
playlist_location = 'gamma_mbi_2023_youtube_files'
home_directory = os.path.join(source_directory, playlist_location)
os.mkdir(home_directory)

# for each participant, create a folder for them.
for participant in full_participant_dict.keys():
    #print(home_directory + '/' + participant)
    os.mkdir(os.path.join(home_directory, participant))
      
    # for each playlist belonging to a participant, make a folder for them.
    for playlist in full_participant_dict[participant].keys():
        #print(home_directory + '/' + participant + '/' + playlist)
        os.mkdir(playlist)

        print('Downloading songs for participant: ', participant, ' from ', playlist)

        song_list = full_participant_dict[participant][playlist]

        for s in range(len(song_list)):
            # download the song as an mp3
            song_file_name = participant + '_' + playlist + '_' + s
            download_video(song, os.path.join(home_directory, participant, playlist), song_file_name)

            if s % 10 == 0:
                print('Finished downloading song # ', s, ' of ', len(song_list))

print('Done!')
# for each playlist they have, create a folder for it
# download files into the playlist folders