# -*- coding: utf-8 -*-
"""
Spyder Editor

This temporary script file is located here:
/home/student/d/ddiallo/.spyder2/.temp.py
"""
import time
import parallel
import numpy as np

import pygame
from pygame.locals import *

pygame.mixer.pre_init(44100, -16, 2, 2048)
pygame.init()

sound = pygame.mixer.Sound('impulsesound_test.wav')



time.sleep(10)


p = parallel.Parallel()
for k in range(1000):
    sound.play()
    p.setData(128)
    time.sleep(0.001)
    p.setData(0)
    time.sleep(0.001)
    print "Trigger %i of 200" %(k)
    time.sleep(0.5)
    
    

   
    
       

n