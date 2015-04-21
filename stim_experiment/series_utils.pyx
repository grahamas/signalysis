import sets
import numpy as np

cimport numpy as np
cimport cython
from cython.parallel cimport prange
from libc.stdlib cimport malloc, free

DTYPE = np.int # np.int == C long
ctypedef np.int_t DTYPE_t
cdef invert_timeseries(char[:, ::1] events, int[:] times):
    """This requires the events to be represented as strings."""
    num_events = events.shape[0]

    

#@cython.boundscheck(False)
#@cython.wraparound(False)
def ppmat_from_times(object times, int max_diff=1500):
    cdef int time1_len, time2_len, ii, jj, kk, ll
    cdef long num_times = len(times)
    cdef long [:] time1, time2
    cdef long count, diff
    cdef long [::1] times_lens = np.empty([num_times], dtype=np.int)
    cdef double[:,::1] pp_mat = np.empty([num_times, num_times])
    print num_times
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

