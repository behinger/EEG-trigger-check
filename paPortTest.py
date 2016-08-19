# -*- coding: utf-8 -*-
"""
Created on Mon Feb  8 11:36:05 2016

@author: experiment
"""
import parallel
import time
import numpy as np
import matplotlib.pyplot as plt
timelist = []
p = parallel.Parallel()
for k in range(200):
    now = time.time()
    p.setData(128)
    while not p.getInAcknowledge():
        pass
    later = time.time()
    timelist.append(later-now)
            
    p.setData(0)
    print 'running: %i / 200'%(k)
    time.sleep(0.05)
    
       
plt.hist(np.asarray(timelist)*1000)
print 'mean:%.3f ms - max:%.3f ms'%(np.mean(np.asarray(timelist)*1000),np.max(np.asarray(timelist)*1000))