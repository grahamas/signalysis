import sets
import numpy as np

cimport numpy as np
cimport cython
from cython.parallel cimport prange
from libc.stdlib cimport malloc, free

DTYPE = np.int # np.int == C long
ctypedef np.int_t DTYPE_t

#@cython.boundscheck(False)
#@cython.wraparound(False)
#def times_xcorr(long[:] times1 not None, 
#		long[:] times2 not None, 
#		int max_diff=3000,
#		int min_sigs=0,
#		int sig_thresh=0):
#
#	cdef int len1 = times1.shape[0]
#	cdef int len2 = times2.shape[0]
#
#	cdef unsigned int offset = 0
#
#	cdef long[:] xcorr = np.zeros([max_diff+1], dtype=DTYPE) # np.int == C long
#
#	cdef int diff
#	cdef unsigned int ii, jj, accum, start_jj
#	cdef long curr_comp
#	for ii in range(0,len1):
#		curr_comp = times1[ii]
#		for jj in range(0,len2):
#			diff = times2[jj] - curr_comp
#			if diff >= 0 and diff <= max_diff:
#				xcorr[<unsigned int>diff] += 1
#			elif diff > max_diff:
#				break
#	for ii in prange(max_diff+1,nogil=True):
#		xcorr[ii] = xcorr[ii] / len1
#
#	print len1
#
#	return xcorr
    # We were running through all memory (inc. swap)
    # This test to see if the xcorr is interesting. 
    # If not, drop it by returning [].
    # cdef int sigs = 0
    # for ii in range(3,max_diff):
    # 	if xcorr[ii] > sig_thresh:
    # 		sigs += 1
    # if sigs >= min_sigs:
    # 	return xcorr
    # else:
    # 	return []

#@cython.boundscheck(False)
#@cython.wraparound(False)
#cdef double[::1] _times_xcorr(long[:] times1, 
#        int len1,
#        long[:] times2,
#        int len2,
#        int max_diff,
#        int min_sigs=0,
#        int sig_thresh=0):
#    #### THIS IS A TEST ####
#    # Supposed to be a helper function for corr_mat_from_times,
#    # entirely WITHIN parallel call, to minimize thread switching.
#
#    cdef unsigned int offset = 0
#
#    #cdef long[::1] xcorr = np.zeros([max_diff+1],dtype=DTYPE)
#
#    #NOTE: assumes times non-negative
#    cdef long diff
#    cdef unsigned int ii, jj, accum
#    cdef long curr_comp
#    cdef double[::1] xcorr = np.zeros([max_diff])
#    for ii in prange(0,len1,nogil=True):
#        curr_comp = times1[ii]
#        for jj in range(0,len2):
#            diff = times2[jj] - curr_comp
#            if diff > 0 and diff <= max_diff:
#                xcorr[diff-1] += 1
#            elif diff > max_diff:
#                break
#    for ii in range(max_diff):
#        xcorr[ii] = xcorr[ii] / <double>len1
#    return xcorr.copy()

cdef invert_timeseries(char*[:] events, int[:] times):
    """This requires the events to be represented as strings."""
    num_events = events.shape[0]

    for ii in range(num_events):


cdef double prob_precedes(long[:] times1, int len1,
        long[:] times2,
        int len2,
        int max_diff):
    cdef int ii, jj
    cdef long curr_comp, diff, count
    for ii in prange(len1, nogil=True):
        curr_comp = times1[ii]
        for jj in range(len2):
            diff = times2[jj] - curr_comp
            if diff > 0 and diff <= max_diff:
                count += 1
            elif diff > max_diff:
                break
    return (count / <double> len1)

#@cython.boundscheck(False)
#@cython.wraparound(False)
def corr_mat_from_times(object times,
        int max_diff=1500,
        int min_sigs=0,
        int sig_thresh=0):

    cdef int this_len, ii, jj
    cdef long num_times = len(times)
    cdef long [:] curr_time
    cdef long curr_len
    cdef long [::1] times_lens = np.empty([num_times], dtype=np.int)
    cdef double[:,::1] probprec_mat = np.empty([num_times, num_times])
    print num_times
    for ii in range(num_times):
        times_lens[ii] = times[ii].shape[0];
    
    for ii in range(0,num_times):
        curr_time = times[ii][:]
        curr_len = times_lens[ii]
        for jj in range(0,num_times):
            probprec_mat[ii,jj] = prob_precedes(curr_time, curr_len, 
                    times[jj][:], times_lens[jj], 
                    max_diff)
    return np.asarray(probprec_mat)


# THIS IS A POINTER ONLY VERSION OF ABOVE FUNCTION (NON FUNCTIONAL)
# ABANDONED MID PROGRESS
# def corr_mat_from_times(object times,
# 		int max_diff=3000,
# 		int min_sigs=0,
# 		int sig_thresh=0):
# 	cdef int len1, len2, ii, jj
# 	cdef long num_times = len(times)
# 	cdef long [:] this_time
# 	cdef DTYPE_t*** xcorr
# 	cdef DTYPE_t** times_ptr
# 	cdef DTYPE_t [:,:,::1] np_xcorr = np.empty([num_times, num_times, max_diff+1],
# 														dtype=DTYPE)

# 	xcorr = <DTYPE_t ***>malloc(max_diff * num_times 
# 								* num_times * sizeof(DTYPE_t))
# 	if not xcorr:
# 		raise MemoryError()

# 	try:
# 		times_ptr = <DTYPE_t **>malloc(num_times * sizeof(DTYPE_t *))
# 		if not times_ptr:
# 			raise MemoryError() 
# 		for ii in range(num_times):
# 			this_time = times[ii]
# 			len1 = this_time.shape[0]
# 			times_ptr[ii] = <DTYPE_t *>malloc(len1 * sizeof(DTYPE_t))
# 			if not times_ptr[ii]:
# 				raise MemoryError()
# 			for jj in range(len1):
# 				times_ptr[ii][jj] = this_time[jj]
# 		try:
# 			for ii in prange(0,num_times, nogil=True):
# 				for jj in range(0,num_times):
# 					_times_xcorr(times_ptr[ii], times_ptr[jj], xcorr[ii][jj], max_diff)
# 		finally:
# 			for ii in range(num_times):
# 				free(times_ptr[ii])
# 			free(times_ptr)
# 		for ii in range(num_times):
# 			for jj in range(num_times):
# 				for kk in range(max_diff+1):
# 					np_xcorr[ii,jj,kk] = xcorr[ii][jj][kk]
# 	finally:
# 		free(xcorr)
#	return np_xcorr


# def times_xcorr_normed(long[:],
# 		int max_diff = 3000,
# 		int min_sigs = 5,
# 		int sig_thresh = 25):
    # pass
    # Naive: [[su.times_xcorr(time1, time2) for time2 in times] 
    #			for time1 in times]





# def worst_times_corr(times1, times2, max_diff=30000):
# 	corr_off = np.empty([max_diff+1])
# 	print(times2[0])
# 	t2set = sets.Set(times2)
# 	for offset in xrange(0,max_diff):
# 		offtimes = times1 + offset
# 		corr_off[offset] = len(t2set.intersection(sets.Set(offtimes)))
# 	return corr_off

# # Note that this function can certainly be optimized, given that
# # times1 and times2 are both ordered.
# def worse_times_xcorr(np.ndarray[DTYPE_t, ndim=1] times1, 
# 		np.ndarray[DTYPE_t, ndim=1] times2, int max_diff=30000):
# 	assert times1.dtype == DTYPE and times2.dtype == DTYPE

# 	cdef int len1 = times1.shape[0]
# 	cdef int len2 = times2.shape[0]

# 	cdef unsigned int offset = 0

# 	print(times2[0])

# 	cdef np.ndarray[DTYPE_t, ndim=1] xcorr = np.zeros([max_diff+1], dtype=DTYPE)

# 	#NOTE: assumes times non-negative
# 	cdef unsigned int ii, jj, curr_comp, accum, start_jj
# 	while offset <= max_diff:
# 		start_jj = 0
# 		for ii in range(0,len1):
# 			curr_comp = times1[ii] + offset
# 			for jj in range(start_jj,len2):
# 				if times2[jj] == curr_comp:
# 					xcorr[offset] += 1
# 					break 			# There cannot be more than one match per ii
# 				if times2[jj] > curr_comp:
# 					start_jj = jj
# 					break
# 		offset += 1

# @cython.boundscheck(False)
# @cython.wraparound(False)
# def bad_times_xcorr(np.ndarray[DTYPE_t, ndim=1] times1, 
# 		np.ndarray[DTYPE_t, ndim=1] times2, int max_diff=30000):
# 	assert times1.dtype == DTYPE and times2.dtype == DTYPE

# 	cdef int len1 = times1.shape[0]
# 	cdef int len2 = times2.shape[0]

# 	cdef unsigned int offset = 0

# 	print(times2[0])

# 	cdef np.ndarray[DTYPE_t, ndim=1] xcorr = np.zeros([max_diff+1], dtype=DTYPE)

# 	#NOTE: assumes times non-negative
# 	cdef int diff;
# 	cdef unsigned int ii, jj, curr_comp, accum, start_jj
# 	for ii in prange(0,len1,nogil=True):
# 		curr_comp = times1[ii]
# 		for jj in range(0,len2):
# 			diff = times2[jj] - curr_comp
# 			if diff >= 0 and diff <= max_diff:
# 				xcorr[<unsigned int>diff] += 1
# 			elif diff > max_diff:
# 				break
# 	return xcorr


