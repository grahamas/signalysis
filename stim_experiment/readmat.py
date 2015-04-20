

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
#
#
#

# def times_corr(times1, times2, max_diff=30000):
# 	corr_off = np.empty([max_diff+1])
# 	print(times2)
# 	t2set = sets.Set(times2)
# 	for offset in xrange(0,max_diff):
# 		offtimes = times1 + offset
# 		corr_off[offset] = len(t2set.intersection(sets.Set(offtimes)))
# 	return corr_off

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

def timeseries_to_xcorr(timeseries, **kwargs):
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

def write_xcorr_to_json(xcorr, fullpath):
    (noext, ext) = os.path.splitext(fname)
    newpath = noext + '_xcorr.json'
    with open(newpath, 'w') as jsonfile:
        json.dump(xcorr, jsonfile)

def nevdir_to_xcorrs(matdir, **kwargs):
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
                print 'To parse'
                parsedmat = parse_nev_mat(fullpath)
                print 'Or not to parse'
                xcorr = timeseries_to_xcorr(parsedmat, **kwargs)
                print 'I HAVE RETURNED'
                if write:
                    newpath = write_xcorr_to_json(xcorr, fullpath)
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

def xcorr_from_times(times):
    xcorr_mat = [[_times_xcorr(time1, time2) for time2 in times] 
            for time1 in times]
    return xcorr_memview_to_list(xcorr_mat)

def write_corrs_to_json(nevdir):
    xcorr_dct = nevdir_to_xcorrs(nevdir, write=true)

    for fname,xcorr in xcorr_dct.iteritems():
        written_jsons.append(fname)
        print fname

    return written_jsons

#def stupid_times(nevdir):
#    """A test function to get a single timeseries (in dir "A").
# -  This timeseries is transformed into an array of inhomogeneous arrays
#    where the rows correspond to a dictionary-ordering of electrode-units (eus)
#    and the columns have no meaning. Each entry in the interior array
#    is the timestamp (in 30kHz units?) of a putative spike from that row-eu."""
#
#    # nevdir_to_xcorrs is 60% of function time
#    parsed_dct = nevdir_to_xcorrs(os.path.join(nevdir, "A"))
#    # parsed_dct is a dictionary with filename keys and timeseries values
#
#    times_list = []
#
#    # this loop is 40% of function time
#    for key,value in parsed_dct.iteritems():
#        # value has a timeseries generated from a mat file
#        # the data in the timeseries are eu_tuples
#        unique_eu_tuples = list(set(value))
#        eu_indexed_dict = {k: [] for k in unique_eu_tuples}
#
#        # This loop is ~80% of loop time, or 35% of function time
#        for n,v in value.iteritems():
#            eu_indexed_dict[v].append(*n)
#
#        ordered_eu_indexed_dict = collections.OrderedDict(sorted(eu_indexed_dict.items(), 
#            key=lambda t: t[0]))
#
#        times_list.append(map(lambda x: np.array(x, np.int64), ordered_eu_indexed_dict.values()))
#    return times_list


if __name__ == "__main__":

    rootdir = '/home/grahams/Dropbox/Hatsopoulos/signalysis/stim_experiment'
    nevdir = os.path.join(rootdir, 'nev_sorted')

    written = write_corrs_to_json(nevdir)


# with open('xcorr_m5th25.json','w') as jsonfile:
# 	json.dump(xcorr_memview_to_list(xcorr_mat), jsonfile)


## Pure python times_xcorr
#def _times_xcorr(time1, time2, max_diff=3000):
#    xcorr = np.zeros([max_diff+1])
#    for ii in range(len(time1)):
#        for jj in range(len(time2)):
#            diff = time1[ii] - time2[jj]
#            if diff >= 0 and diff <= max_diff:
#                xcorr[diff] += 1
#    return xcorr

#def get_correlated_eus(arr, eus):
#    ret_list = []
#    left_max = len(arr)
#    right_max = len(arr[0])
#    for ii in range(left_max):
#        for jj in range(right_max):
#            if len(arr[ii][jj]) > 0:
#                ret_list.append([eus[ii], eus[jj]])
#    return ret_list

