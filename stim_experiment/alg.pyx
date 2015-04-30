
from libc.stdlib cimport malloc,free


#cdef newHashTable(calg.HashTableHashFunc hash_func,
#                  calg.HashTableEqualFunc equal_func):
#    new_hash_table = HashTable()
#    new_hash_table._hash_table = calg.hash_table_new(hash_func, equal_func)
#    if new_hash_table._hash_table is NULL:
#        raise MemoryError("Could not allocate HashTable.")
#    return new_hash_table
#
#cdef class HashTable:
#    cdef calg.HashTable *_hash_table
#
#    def __dealloc__(self):
#        if self._hash_table is not NULL:
#            calg.hash_table_free(self._hash_table)
#
#    cdef calg.HashTableValue lookup(self, calg.HashTableKey key):
#        cdef calg.HashTableValue value
#        value = calg.hash_table_lookup(hash_table=self._hash_table,
#                                       key=key)
#        if value is calg.HASH_TABLE_NULL:
#            raise KeyError("No such key in HashTable (during lookup).")
#        else:
#            return value
#
#    cdef bint insert(self, calg.HashTableKey key, calg.HashTableValue value):
#        return calg.hash_table_insert(hash_table=self._hash_table,
#                                         key=key,
#                                         value=value)
#
#    cdef bint has_key(self, calg.HashTableKey key):
#        cdef calg.HashTableValue value
#        value = calg.hash_table_lookup(hash_table=self._hash_table,
#                                       key=key)
#        if value is calg.HASH_TABLE_NULL:
#            return 0
#        else:
#            return 1
#
#    cdef void remove(self, calg.HashTableKey key):
#        cdef bint success
#        success = calg.hash_table_remove(hash_table=self._hash_table,
#                                         key=key)
#        if success is 0:
#            # According to documentation, hash_table_remove only returns
#            # 0 when the key was not in the hash table.
#            raise KeyError("No such key in HashTable (during remove).")
#
#    cdef int num_entries(self):
#        return calg.hash_table_num_entries(self._hash_table)

cdef class cTrie:

    def __cinit__(self):
        self._trie = calg.trie_new()
        if self._trie is NULL:
            raise MemoryError("Could not allocate Trie.")

    def __dealloc__(self):
        if self._trie is not NULL:
            calg.trie_free(self._trie)

    cdef calg.TrieValue lookup(self, char *key):
        cdef calg.TrieValue value
        value = calg.trie_lookup(trie=self._trie, key=key)
        if value is NULL:
            raise KeyError("No such key in Trie (during lookup).")
        else:
            return value

    cdef void insert(self, char *key, calg.TrieValue value):
        cdef bint success
        success = calg.trie_insert(trie=self._trie, key=key, value=value)
        if success is 0:
            raise MemoryError("Could not insert new TrieValue")

    cdef void remove(self, char *key):
        cdef bint success
        success = calg.trie_remove(trie=self._trie, key=key)
        if success is 0:
            raise KeyError("No such key in Trie (during remove).")

    cdef calg.TrieValue tentative_lookup(self, char *key):
        cdef calg.TrieValue ret = calg.trie_lookup(trie=self._trie, key=key)
        if ret is calg.TRIE_NULL:
            return <calg.TrieValue> NULL
        else:
            return ret

    cdef int num_entries(self):
        return calg.trie_num_entries(trie=self._trie)

    cdef bint has_key(self, char *key):
        cdef calg.TrieValue ret = calg.trie_lookup(trie=self._trie, key=key)
        if ret is calg.TRIE_NULL:
            return 0
        else:
            return 1

cdef class cGrowingList:
    
    #MUST BE CREATED WITH FACTORY
    def __cinit__(self):
        self._first = NULL
        self._last = NULL
        self._iter = NULL
    
    def __dealloc__(self):
        calg.slist_free(self._first)
        if self._iter is not NULL:
            free(self._iter)

    def __iter__(self):
        if self._iter is not NULL:
            raise Exception("DUPLICATE ITER")
        self._iter = <calg.SListIterator *> malloc(sizeof(calg.SListIterator))
        if self._iter is NULL:
            raise MemoryError("Could not allocate memory for iterator")
        calg.slist_iterate(&(self._first), self._iter)
        return self

    def __next__(self):
        if not calg.slist_iter_has_more(self._iter):
            free(self._iter)
            self._iter = NULL
            raise StopIteration
        return (<GLIST_T *> calg.slist_iter_next(self._iter))[0]

    cdef void first(self, GLIST_T first):
        self.prepend(first)
        self._last = self._first

    cdef calg.SListValue data_into_ptr(self, GLIST_T data):
        cdef (GLIST_T *) ret = <GLIST_T *> malloc(sizeof(GLIST_T))
        if ret is NULL:
            raise MemoryError("Could not allocate int")
        ret[0] = data
        return <calg.SListValue> ret

    cdef calg.SListEntry *prepend(self, GLIST_T data):
        cdef calg.SListEntry *new_entry
        new_entry = calg.slist_prepend(&(self._first), self.data_into_ptr(data))
        if new_entry is NULL:
            raise MemoryError("Could not allocate new SListEntry")
        return new_entry

    cdef calg.SListEntry *append(self, GLIST_T data):
        # TODO: Should rewrite to avoid likely loop in slist_append
        cdef calg.SListEntry *new_entry
        new_entry = calg.slist_append(&(self._last), self.data_into_ptr(data))
        if new_entry is NULL:
            raise MemoryError("Could not allocate new SListEntry")
        self._last = new_entry
        return new_entry

    def __len__(self):
        return calg.slist_length(self._first)

    def __array__(self):
        cdef int slength = len(self)
        cdef np.ndarray[np.double_t, ndim=1] nparray = np.empty(slength, dtype=np.dtype('d'))

        cdef int idx = 0

        for data in self.iterate():
            nparray[idx] = data
            idx += 1

        return nparray



### ONLY INTS ###
cdef class ArrayWrapper:
    # Credit Gael Varoquaux (gael-varoquaux.info)
    cdef set_data(self, int size, void *data_ptr):
        self.data_ptr = data_ptr
        self.size = size

    def __array__(self):
        cdef np.npy_intp shape[1]
        shape[0] = <np.npy_intp> self.size
        # Assumes incoming array of doubles.
        ndarray = np.PyArray_SimpleNewFromData(1, shape, np.NPY_FLOAT64, self.data_ptr)
        return ndarray

    def __dealloc__(self):
        free(<void *>self.data_ptr)



