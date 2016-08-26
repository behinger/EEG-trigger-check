# -*- coding: utf-8 -*-
"""
Created on Fri Aug 26 15:06:26 2016

@author: experiment
"""


import time
import random
import parallel
import matplotlib.pyplot as plt
PYGAZE = 0


if PYGAZE:
    import pygaze
    import pygaze.libscreen
    import pygaze.eyetracker
    disp = pygaze.libscreen.Display(screennr=1)    
    tracker = pygaze.eyetracker.EyeTracker(disp) #pygaze always needs a pygame/psychopy screen

else:
    import pylink
    pylink.EyeLink()    
    
p = parallel.Parallel()
p.PPDATADIR(0) # listen at the local parallelport what the eyetracking port has to say!

tlist1 = []
tlist2 = []
tlist3 = []
for k in range(20000):
    randint = random.randint(1, 255)
    print('trial %i, sendingtrigger:%i'%(k,randint))
    
    if PYGAZE:
        t1 = time.time()
        tracker.send_command("!*write_ioport 0x378 %i"%(randint))
    else:
        t1 = time.time()
        pylink.getEYELINK().sendCommand("!*write_ioport 0x378 %i"%(randint))
    t2 = time.time()
    while not p.PPRDATA() == randint: # we read out the local parallelport, interestingly we don't need a special cross-link cable
        pass
    t3 = time.time()
    tlist1.append(t1)
    tlist2.append(t2)
    tlist3.append(t3)
    
    # we have to reset the parallelport to 0, thus all pins low
    time.sleep(0.001)
    if PYGAZE:
        tracker.send_command("!*write_ioport 0x378 0")

    else:
        pylink.getEYELINK().sendCommand("!*write_ioport 0x378 0")
    time.sleep(0.05)
    
plt.figure(),plt.hist([1000*(x-y) for x,y in zip(tlist3,tlist1)],100)