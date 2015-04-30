cimport calg
cimport numpy as np 

# If you change this, change __array__ in ArrayWrapper
ctypedef double GLIST_T

cdef class cTrie:
    cdef calg.Trie *_trie

    cdef calg.TrieValue lookup(self, char *key)
    cdef calg.TrieValue tentative_lookup(self, char *key)
    # void instead of bint as error checking is handled by function
    cdef void insert(self, char *key, calg.TrieValue value)
    cdef void remove(self, char *key)
    cdef int num_entries(self)

    cdef bint has_key(self, char *key)

#UNIMPLEMENTED (switched to CGrowingList
#cdef class CSList:
#    cdef calg.SListEntry *_first
#
#    cdef calg.SListEntry *prepend(self, calg.SListValue data)
#    cdef calg.SListEntry *append(self, calg.SListValue data)
#    cdef calg.SListValue *to_array(self)
#    #cdef bint remove(self, SListEqualFunc callback, SListValue data)
#    #cdef void sort(self, SListCompareFunc compare_func)
#    # Several functions not implemented in interest of time and
#    # not screwing them up

cdef class cGrowingList:
    # For growing an unknown size array.
    # INTENTIONALLY DOES NOT ALLOW REMOVAL
    cdef calg.SListEntry *_first
    cdef calg.SListEntry *_last
    cdef calg.SListIterator *_iter

    cdef void first(self, GLIST_T first)

    cdef calg.SListValue data_into_ptr(self, GLIST_T data)

    cdef calg.SListEntry *prepend(self, GLIST_T data)
    cdef calg.SListEntry *append(self, GLIST_T data)

cdef class ArrayWrapper:
    cdef void *data_ptr
    cdef int size

    cdef set_data(self, int size, void *data_ptr)
