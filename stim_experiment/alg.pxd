cimport calg

cdef class CTrie:
    cdef calg.Trie *_trie

    cdef calg.TrieValue lookup(self, char *key)
    cdef bint insert(self, char *key, calg.TrieValue value)
    cdef bint remove(self, char *key)
    cdef bint has_key(self, char *key)
    cdef int num_entries(self)

# UNIMPLEMENTED (switched to CGrowingList
cdef class CSList:
    cdef calg.SListEntry *_first

    cdef calg.SListEntry *prepend(self, calg.SListValue data)
    cdef calg.SListEntry *append(self, calg.SListValue data)
    cdef calg.SListValue *to_array(self)
    #cdef bint remove(self, SListEqualFunc callback, SListValue data)
    #cdef void sort(self, SListCompareFunc compare_func)
    # Several functions not implemented in interest of time and
    # not screwing them up

cdef class CGrowingList:
    # For growing an unknown size array.
    # INTENTIONALLY DOES NOT ALLOW REMOVAL
    cdef calg.SListEntry *_first, *_last

    cdef calg.SListEntry *prepend(self, calg.SListValue data)
    cdef calg.SListEntry *append(self, calg.SListValue data)
    cdef calg.SListValue *to_array(self)
