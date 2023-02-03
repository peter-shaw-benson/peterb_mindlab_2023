#!/bin/bash

# This lets the script know to use matlab commands
module load anaconda3/2021.05
source activate gstreamer
export LD_LIBRARY_PATH=/shared/centos7/anaconda3/2021.05/envs/gstreamer/lib:$LD_LIBRARY_PATH
module load matlab/R2021a

# Your execution command with options 
matlab --nodisplay -batch /scratch/kathios.n/audioextractionexamples
 
# Sub something like this in for the path in the command above 

# IMPORTANT
# [file] in command above should be without .m 
# if called (matlab_sub1.m), put in ../../../matlab_sub1
