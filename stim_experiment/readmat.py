

import os
import collections
import json

import scipy as sy
import h5py
import scipy.io

import numpy as np

import statsmodels as sm

import pandas as pd

import series_utils as su

from time import time

#
#	NOTE: Waveforms currently not recorded.
#
#   In the remainder of the file "pp" will stand for "probability to precede"
#   which indicates the probability that a given unit X will precede another Y.
#   This is calculated with respect to a fixed window (generally 1500 = 50ms
#

def parse_nev_mat(f):
    """Parses a .mat version of an NEV file and returns a time-series
    of spike, where the indices are times (in units since start of rec)
    and the data are (electrode,unit) tuples.

    Note that we will likely need to return the sampling frequency.
    Currently I assume 30kHz."""

    (root, ext) = os.path.splitext(f)
    if ext == '.mat':
        mat_f = h5py.File(f,'r')
        mat_spikes = mat_f['NEV']
        time_res = mat_spikes['MetaTags']['TimeRes'][0][0]
        mat_spikes = mat_spikes['Data']['Spikes']

        unwrap = lambda x: np.array([y for z in x for y in z])

        # eu stands for 'Electrode/Unit'
        eu_mat = map(unwrap, [mat_spikes['Electrode'][:],
            mat_spikes['Unit'][:]])
        duped_eu_tuples = zip(*eu_mat)

        time_indexed = pd.Series(duped_eu_tuples,
                index=mat_spikes['TimeStamp'][:])
        mat_f.close()
        return time_indexed
    return pd.Series() # Gets hissy if you return None

def timeseries_to_pp(timeseries, **kwargs):
    if ('test' in kwargs):
        test = kwargs['test']
        slicelim = kwargs['slicelim']
    else:
        test = False
    unique_events = list(set(timeseries))
    event_indexed_dict = {k: [] for k in unique_events}

    # This is VERY inefficient. Should write cython to 
    # invert a dict.
    for time, event in timeseries.iteritems():
        event_indexed_dict[event] = time

    #TODO: THIS IS NOT GENERAL
    #Give events a general ordering. Or just keep it specific...
    ordered_event_indexed_dict = collections.OrderedDict(sorted(event_indexed_dict.items(),
        key=lambda t: t[0]))

    times = map(lambda x: np.array(x, np.int64), ordered_event_indexed_dict.values())

    if test:
        corr_mat = su.corr_mat_from_times(times[0:slicelim][0:slicelim])
    else:
        corr_mat = su.corr_mat_from_times(times)

    return corr_mat

def nevdir_to_ppmtxs(matdir, **kwargs):
    """Assumes all .mat files in the provided directory are parsed NEV files.
    Ignores non-.mat files."""
    # Experiment with one file
    retdct = {}
    if 'write' in kwargs:
        write = kwargs['write']
    else:
        write = False

    for root, dirs, files in os.walk(matdir):
        for f in files:
            (bname, ext) = os.path.splitext(f)
            if ext == '.mat':
                fullpath = os.path.join(root,f)
                parsedmat = parse_nev_mat(fullpath)
                xcorr = timeseries_to_xcorr(parsedmat, **kwargs)
                if write:
                    # TODO: Write dataframe
                    newpath = WRITE_DATAFRAME
                    retdct[fullpath] = newpath
                else:
                    retdct[fullpath] = xcorr
    if write:
        return parsed_mats
    else:
        return retdct

## THIS FUNCTION LOOPS INFINITELY AND CAUSES A MEMORY LEAK
#def corr_memview_to_list(memview):
#    maplambda = lambda x: map(lambda y: np.asarray(y).tolist(), x) # assumes [] not None
#    return map(maplambda, memview)

if __name__ == "__main__":

    rootdir = '/home/grahams/Dropbox/Hatsopoulos/signalysis/stim_experiment'
    nevdir = os.path.join(rootdir, 'nev_sorted')

    written = write_corrs_to_json(nevdir)

