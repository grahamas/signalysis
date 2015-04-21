
#Remember, libcalg is located below libcalg-1.0... MAY CAUSE PROBLEMS

cdef extern from "libcalg/hash_table.h":
    ctypedef struct HashTable:
        pass

    ctypedef struct HashTableEntry:
        pass

    ctypedef void* HashTableKey
    ctypedef void* HashTableValue

    void hash_table_free(HashTable *hash_table)
    void hash_table_insert(HashTable *hash_table,
            HashTableKey key,
            HashTableValue value)
    HashTableValue hash_table_lookup(HashTable *hash_table,
            HashTableKey key)
