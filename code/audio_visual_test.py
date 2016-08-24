# -*- coding: utf-8 -*-
"""
Created on Tue Aug 23 16:37:05 2016

@author: ddiallo
"""

"""
@author: bwahn

"""

import pygame
from pygame.locals import *
import time
import parallel

pygame.mixer.pre_init(44100, -16, 2, 2048)
pygame.init()

FULLSCREEN = 1
WHITE = (255,255,255)
BLACK = (0,0,0)
GRAY = (128,128,128)

FIXCROSSSIZE = 16
FONTSIZE = 34
BGCOLOR = BLACK

fpsClock = pygame.time.Clock()
FPS = 100

(WIDTH,HEIGHT) = (1280,800)

def fixcross():
    pygame.draw.circle(SCREEN, GRAY, (CX, CY), FIXCROSSSIZE, 0)

def displayTextcenter(textlist,shiftup):    
    basicfont = pygame.font.SysFont(None, FONTSIZE)
    SCREEN.fill(BGCOLOR)
    for i,text in enumerate(textlist):

        line = basicfont.render(text, True, WHITE, BLACK)            
        textrect = line.get_rect()
        textrect.centerx = SCREEN.get_rect().centerx 
        textrect.centery = SCREEN.get_rect().centery + (i+1)*FONTSIZE - shiftup         
        SCREEN.blit(line, textrect)
    fixcross()
    pygame.mouse.set_visible(0)
    pygame.display.flip()
    pressnext = 0    
    
    while pressnext == 0:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
              pygame.quit()
              sys.exit()
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    pygame.quit()
                    sys.exit()
                if event.key == pygame.K_SPACE:
                    pressnext = 1
                    another = 1
                    return another
                    break
                if event.key == pygame.K_n:
                    another = 0
                    return another
                    break


if FULLSCREEN:
    SCREEN = pygame.display.set_mode((0,0),pygame.FULLSCREEN)
    WIDTH,HEIGHT = SCREEN.get_size()    
else:
    SCREEN = pygame.display.set_mode((WIDTH,HEIGHT))    

SCREEN.fill(BGCOLOR)
(CX,CY) = (WIDTH/2, HEIGHT/2)

sound = pygame.mixer.Sound('impulsesound_test.wav')


p = parallel.Parallel()



#    time.sleep(0.001)
#    p.setData(0)
#    time.sleep(0.001)
#    print "Trigger %i of 200" %(k)
#    time.sleep(0.5)
#    
while True:

    #introtext = ['Please press space to start stimulus presentation or ESC to exit.']
    #displayTextcenter(introtext,200)
    SCREEN.fill(BGCOLOR)
    pygame.display.flip()
    framecount = 0
    
    pygame.draw.circle(SCREEN, WHITE, (CX, CY), FIXCROSSSIZE, 0)
    sound.play()
    p.setData(128)
    pygame.display.flip()
    p.setData(130)
    while framecount < 5:
        fpsClock.tick(FPS)
        framecount += 1
