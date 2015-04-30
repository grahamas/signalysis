import sets
import numpy as np

cimport numpy as np
cimport cython
from cython.parallel cimport prange
from libc.stdlib cimport malloc, free

from alg import cTrie, cGrowingList

DTYPE = np.int # np.int == C long
ctypedef np.int_t DTYPE_t
#cdef invert_timeseries(char[:, ::1] events, int[:] times):
#    """This requires the events to be represented as strings.
#    In order to be represented as a memoryview, the strings will
#    have to be whitespace padded. This will entail stripping in
#    Python, which may only be reasonable for num_events << num_occs."""
#    cdef int num_occs = events.shape[0]
#    assert num_occs == times.shape[0]
#    cdef cTrie inverted = cTrie()
#
#    cdef char *this_event
#    cdef CGrowingList *this_event_times
#    cdef int ii
#
#    for ii in range(num_occs):
#        this_event = events[ii]
#        this_event_times = inverted.tentative_lookup(this_event)
#        if this_event_times is NULL:
#            this_event_times = cGrowingList()
#            inverted.insert(this_event_times)




    

    

@cython.boundscheck(False)
@cython.wraparound(False)
def ppmat_from_times(object times, int max_diff=1500):
    cdef int time1_len, time2_len, ii, jj, kk, ll
    cdef long num_times = len(times)
    cdef long [:] time1, time2
    cdef long count, diff
    cdef long [::1] times_lens = np.empty([num_times], dtype=np.int)
    cdef double[:,::1] pp_mat = np.empty([num_times, num_times])
    for ii in range(num_times):
        times_lens[ii] = times[ii].shape[0];
    
    for ii in range(0,num_times):
        time1 = times[ii][:]
        time1_len = times_lens[ii]
        for jj in range(0,num_times):
            time2 = times[jj][:]
            time2_len = times_lens[jj]
            count = 0
            for kk in prange(time1_len, nogil=True):
                for ll in range(time2_len):
                    diff = time2[ll] - time1[kk]
                    if diff > 0 and diff <= max_diff:
                        count += 1
                        break
                    elif diff > max_diff:
                        break
            pp_mat[ii][jj] = (count / <double> time1_len)
    
    return np.asarray(pp_mat)

