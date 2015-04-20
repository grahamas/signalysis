#!/usr/bin/env python

import numpy as np
import os
import readmat as rm
import series_utils as su

TEST_SIZE = 15

nevdir = '/home/grahams/Dropbox/Hatsopoulos/signalysis/stim_experiment/nev_sorted'
clmat = rm.nevdir_to_xcorrs(nevdir, test=True, slicelim=TEST_SIZE)
#timelist = rm.stupid_times(nevdir)
#print "Done with times."
#test_times = timelist[0][0:TEST_SIZE][0:TEST_SIZE]
#cl = rm.corr_memview_to_list(su.corr_mat_from_times(test_times))
#clmat = np.matrix([[sum(cl[ii][jj][1:-1]) for jj in range(0,TEST_SIZE)] for ii in range(0,TEST_SIZE)])
