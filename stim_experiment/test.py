#!/usr/bin/env python

import numpy as np
import os
import readmat as rm
import series_utils as su

def test_nevdir_to_ppmtxs(test_size):
    nevdir = '/home/grahams/Dropbox/Hatsopoulos/signalysis/stim_experiment/nev_sorted'
    ppmat = rm.nevdir_to_ppmtxs(nevdir, test=True, slicelim=test_size)
    return ppmat

def test_get_series():
    mat_name = '/home/grahams/Dropbox/Hatsopoulos/signalysis/stim_experiment/nev_sorted/A/Z20140902_M1Contra_StimExperimentAPost-08.mat'
    test_series = parse_nev_mat(mat_name)
    return test_series

def test_invert_series():
    unique_events = list(set(timeseries))
    event_indexed_dict = {k: [] for k in unique_events}

    for time,event in timeseries.iteritems():
        event_indexed_dict[event] = time

    ordered_event_indexed_dict = collections.OrderedDict(sorted(event_indexed_dict.items(),
        key=lambda t: t[0]))

    times = map(lambda x: np.array(x, np.int64), ordered_event_indexed_dict.values())

    return times
