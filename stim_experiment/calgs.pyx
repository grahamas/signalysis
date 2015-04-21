
cimport calg

#TODO: test __getitem__

cdef class HashTable:
    cdef calg.HashTable *_hash_table

    def __cinit__(self, HashTableHashFunc hash_func,
            HashTableEqualFunc equal_func):
        self._hash_table = calg.hash_table_new(hash_func, equal_func)
        if self._hash_table is NULL:
            raise MemoryError("Could not allocate HashTable.")

    def __dealloc__(self):
        if self._hash_table is not NULL:
            calg.hash_table_free(self._hash_table)

    cdef calg.HashTableValue __getitem__(self, HashTableKey key):
        """Implements traditional dictionary lookup.
        Returns value if successful, NULL otherwise."""
        cdef calg.HashTableValue value
        value = calg.hash_table_lookup(hash_table=self._hash_table,
                                       key=key)
        if value == calg.HASH_TABLE_NULL:
            raise KeyError("No such key in HashTable (during access).")
        else:
            return value

    cdef bint __setitem__(self, HashTableKey key, HashTableValue value):
        """Implements traditional dictionary setting.
        Returns success of hash_table_insert."""
        return calg.hash_table_insert(hash_table=self._hash_table,
                                         key=key,
                                         value=value)

    cdef bint __contains__(self, HashTableKey key):
        """Checks if key in HashTable.
        Reimplementation of __getitem__ without raising KeyError."""
        cdef calg.HashTableValue value
        value = calg.hash_table_lookup(hash_table=self._hash_table,
                                       key=key)
        if value == calg.HASH_TABLE_NULL:
            return 0
        else:
            return 1

    cdef void __delitem__(self, HashTableKey key):
        cdef bint success
        success = calg.hash_table_remove(hash_table=self._hash_table,
                                         key=key)
        if success == NULL:
            # According to documentation, hash_table_remove only returns
            # NULL when the key was not in the hash table.
            raise KeyError("No such key in HashTable (during remove).")


