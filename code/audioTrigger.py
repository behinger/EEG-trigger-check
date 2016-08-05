# -*- coding: utf-8 -*-
"""
Created on Mon Feb  8 11:36:05 2016

@author: experiment
"""
#from pytrack import *  
#track = Tracker(surf,rand_filename+'.EDF') # Surf = Surface ~= PTB-Window
#TRIGGERINTEGER= 1
#track.sendCommand('!*write_ioport 0x378 %d' %TRIGGERINTEGER)

from psychopy import parallel
#import sys
#import pygame
import time
#pygame.mixer.init()
#pygame.mixer.music.load("beep.wav")

p = parallel.ParallelPort()
while True: #True:
    #pygame.mixer.music.play()
    p.setData(10)

    time.sleep(0.1) 
    p.setData(0)
    time.sleep(0.4)
       
