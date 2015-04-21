
cimport calg

#TODO: test __getitem__

cdef class HashTable:
    cdef calg.HashTable *_hash_table

    # Very upset with typing arguments
    def __cinit__(self, calg.HashTableHashFunc hash_func,
            calg.HashTableEqualFunc equal_func):
        self._hash_table = calg.hash_table_new(hash_func, equal_func)
        if self._hash_table is NULL:
            raise MemoryError("Could not allocate HashTable.")

    def __dealloc__(self):
        if self._hash_table is not NULL:
            calg.hash_table_free(self._hash_table)

    cdef calg.HashTableValue lookup(self, calg.HashTableKey key):
        cdef calg.HashTableValue value
        value = calg.hash_table_lookup(hash_table=self._hash_table,
                                       key=key)
        if value is calg.HASH_TABLE_NULL:
            raise KeyError("No such key in HashTable (during lookup).")
        else:
            return value

    cdef bint insert(self, calg.HashTableKey key, calg.HashTableValue value):
        return calg.hash_table_insert(hash_table=self._hash_table,
                                         key=key,
                                         value=value)

    cdef bint has_key(self, calg.HashTableKey key):
        cdef calg.HashTableValue value
        value = calg.hash_table_lookup(hash_table=self._hash_table,
                                       key=key)
        if value is calg.HASH_TABLE_NULL:
            return 0
        else:
            return 1

    cdef void remove(self, calg.HashTableKey key):
        cdef bint success
        success = calg.hash_table_remove(hash_table=self._hash_table,
                                         key=key)
        if success is 0:
            # According to documentation, hash_table_remove only returns
            # 0 when the key was not in the hash table.
            raise KeyError("No such key in HashTable (during remove).")

    cdef int num_entries(self):
        return calg.hash_table_num_entries(self._hash_table)


cdef class Trie:
    cdef calg.Trie *_trie

    def __cinit__(self):
        self._trie = calg.trie_new()
        if self._trie is NULL:
            raise MemoryError("Could not allocate Trie.")

    def __dealloc__(self):
        calg.trie_free(self._trie)

    cdef calg.TrieValue lookup(self, char *key):
        cdef calg.TrieValue value
        value = calg.trie_lookup(trie=self._trie, key=key)
        if value is NULL:
            raise KeyError("No such key in Trie (during lookup).")
        else:
            return value

    cdef bint insert(self, char *key, calg.TrieValue value):
        return calg.trie_insert(trie=self._trie, key=key, value=value)

    cdef bint remove(self, char *key):
        cdef bint success
        success = calg.trie_remove(trie=self._trie, key=key)
        if success is 0:
            raise KeyError("No such key in Trie (during remove).")

    cdef bint has_key(self, char *key):
        cdef calg.TrieValue value
        value = calg.trie_lookup(trie=self._trie, key=key)
        if value is NULL:
            return 0
        else:
            return 1

    cdef int num_entries(self):
        return calg.trie_num_entries(trie=self._trie)
