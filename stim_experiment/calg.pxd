
#Remember, libcalg is located below libcalg-1.0... MAY CAUSE PROBLEMS

# Author: Graham Smith, 2015-04-21
# All real work done by author of libcalg, Simon Howard. 

# TODO: Copy documentation from header file

cdef extern from "libcalg/hash_table.h":
    ctypedef struct HashTable:
        pass

    ctypedef struct HashTableEntry:
        pass

    ctypedef void* HashTableKey
    ctypedef void* HashTableValue

    void* HASH_TABLE_NULL

    ctypedef unsigned long (*HashTableHashFunc)(HashTableKey value)
    ctypedef int (*HashTableEqualFunc)(HashTableKey value1, HashTableKey value2)
    ctypedef void (*HashTableKeyFreeFunc)(HashTableKey value)
    ctypedef void (*HashTableValueFreeFunc)(HashTableValue value)



    ### Memory management
    HashTable *hash_table_new(HashTableHashFunc hash_func,
                              HashTableEqualFunc equal_func)
    void hash_table_free(HashTable *hash_table)
    void hash_table_register_free_functions(HashTable *hash_table,
                                            HashTableKeyFreeFunc key_free_func,
                                            HashTableValueFreeFunc value_free_func)
    ######



    ### Hash table operations
    bint hash_table_insert(HashTable *hash_table,
                          HashTableKey key,
                          HashTableValue value)
    HashTableValue hash_table_lookup(HashTable *hash_table,
                                     HashTableKey key)
    bint hash_table_remove(HashTable *hash_table, HashTableKey key)

    int hash_table_num_entries(HashTable *hash_table)
    ###### 


    # TODO: excluded hash_table_iterate



cdef extern from "libcalg/trie.h":
    ctypedef struct Trie:
        pass
    ctypedef void *TrieValue

    Trie *trie_new()
    void trie_free(Trie *trie)

    bint trie_insert(Trie *trie, char *key, TrieValue value)
    TrieValue trie_lookup(Trie *trie, char *key)
    bint trie_remove(Trie *trie, char* key)

    int trie_num_entries(Trie *trie)
