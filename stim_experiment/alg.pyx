
cimport calg

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

cdef class CTrie:

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


cdef class CGrowingList:
    cdef calg.SListEntry *_first, *_last

    def __cinit__(self):
        self._first = NULL
        self._last = NULL
    def __dealloc__(self):
        calg.slist_free(self._first)

    cdef calg.SListEntry *prepend(self, calg.SListValue data):
        cdef calg.SListEntry *new_entry
        new_entry = calg.slist_prepend(&(self._first), data)
        if new_entry is NULL:
            raise MemoryError("Could not allocate new SListEntry")
        return new_entry

    cdef calg.SListEntry *append(self, calg.SListValue data):
        # TODO: Should rewrite to avoid likely loop in slist_append
        cdef calg.SListEntry *new_entry
        new_entry = calg.slist_append(&(self._last), data)
        if new_entry is NULL:
            raise MemoryError("Could not allocate new SListEntry")
        self._last = new_entry
        return new_entry

    cdef calg.SListValue *to_array(self):
        cdef calg.SListValue *new_array
        new_array = calg.slist_to_array(self._first)
        if new_array is NULL:
            raise MemoryError("Could not allocate new SListValue array")
        return new_array

