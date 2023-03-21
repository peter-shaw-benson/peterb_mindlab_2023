from pytube import YouTube
import os
 from bs4 import BeautifulSoup as bs
import requests
import re
import json
import pandas as pd
from moviepy.editor import *
import sys

def mp4_to_mp3(mp4_file, mp3_file):
    file_to_convert = AudioFileClip(mp4_file)
    file_to_convert.write_audiofile(mp3_file, logger=None)
    file_to_convert.close()

def get_full_playlist_info(playlist_link, info=False):
    # get the HTML from the link
    r = requests.get(playlist_link)
    soup = bs(r.text,'html.parser')

    # construct the playlist dictionary
    if info: print('extracting playlist dict')
    full_playlist_dict = get_playlist_dict(soup)
    
    # get the participant info
    if info: print('extracting participant info')
    participant_info = get_participant_info(full_playlist_dict)
    
    # get the video info
    if info: print('extracting vide list')
    video_list = get_video_list(full_playlist_dict)
    
    extracted_videos = []
    
    current_video = 0
    for video in video_list:
        if current_video > 99:
            break
            
        if info: print('adding video', current_video, 'of ', len(video_list), 'videos.')
        extracted_videos.append(get_video_info(video))
        
        current_video += 1
    
    if info: print('building dictionary.')

    output_dict = {'participant': participant_info['participant'], 
                    'playlist_type': participant_info['playlist_type'],
                    'videos': extracted_videos}
    
    return output_dict
    
# downloads an mp3 of the given youtube video
def download_video(video_url, path, video_name):
    video_audio = YouTube(video_url).streams.filter(only_audio=True).first()
    
    # download the file
    out_file = video_audio.download(output_path=path, filename=video_name)

    # save the file as mp3
    base, ext = os.path.splitext(out_file)
    new_file = base + '.mp3'
    mp4_to_mp3(out_file, new_file)



def main(args=None):
    # Isolate args from global arguments
    if args is None:
        # Handle no arguments
        try:
            # Divide options from args
            opts = [opt for opt in sys.argv[1:] if opt.startswith("-")]
            args = [arg for arg in sys.argv[1:] if not arg.startswith("-")]
        except IndexError:
            raise SystemExit(f"Usage: {sys.argv[0]} [options: -v] [playlist url] [output path] [output prefix]")

        if len(args) < 3:
            raise SystemExit(f"Usage: {sys.argv[0]} [options: -v] [playlist url] [output path] [output prefix]")

        # load in text file of videos to download
        if "-v" in opts:
            verbose = True
        
        # Run the program, first extracting links from the playlist
        playlist_dict = get_full_playlist_info(args[0], verbose)
        output_path = args[1]
        prefix = args[2]

        # Iterate through each video and download
        for i in range(playlist_dict["videos"]):
            download_video(playlist_dict['videos'][i], output_path, prefix + str(i))


if __name__ == '__main__':
    main()