
# Cython wrapper for C-Algorithms

# Author: Graham Smith, 2015-04-21
# All real work done by author of libcalg, Simon Howard. 

# Copyright (c) 2005-2008, Simon Howard
# 
# Permission to use, copy, modify, and/or distribute this software 
# for any purpose with or without fee is hereby granted, provided 
# that the above copyright notice and this permission notice appear 
# in all copies. 
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL 
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED 
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE 
# AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR 
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM 
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, 
# NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN      
# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE. 
#
#


# TODO: Copy documentation from header file

# HASHTABLE SECTION
cdef extern from "libcalg.h":
    ctypedef struct HashTableStruct:
        pass

    ctypedef struct HashTableEntry:
        pass

    ctypedef void* HashTableKey
    ctypedef void* HashTableValue

    void* HASH_TABLE_NULL = (<void *> 0)

    ctypedef unsigned long (*HashTableHashFunc)(HashTableKey value)
    ctypedef int (*HashTableEqualFunc)(HashTableKey value1, HashTableKey value2)
    ctypedef void (*HashTableKeyFreeFunc)(HashTableKey value)
    ctypedef void (*HashTableValueFreeFunc)(HashTableValue value)



    ### Memory management
    HashTableStruct *hash_table_new(HashTableHashFunc hash_func,
            HashTableEqualFunc equal_func)
    void hash_table_free(HashTableStruct *hash_table)
    void hash_table_register_free_functions(HashTableStruct *hash_table,
            HashTableKeyFreeFunc key_free_func,
            HashTableValueFreeFunc value_free_func)
    ######



    ### Hash table operations
    bint hash_table_insert(HashTableStruct *hash_table,
            HashTableKey key,
            HashTableValue value)
    HashTableValue hash_table_lookup(HashTableStruct *hash_table,
            HashTableKey key)
    bint hash_table_remove(HashTableStruct *hash_table, HashTableKey key)

    int hash_table_num_entries(HashTableStruct *hash_table)
    ###### 


    # TODO: excluded hash_table_iterate


# TRIE SECTION
cdef extern from "libcalg.h":
    ctypedef struct Trie:
        pass
    ctypedef void *TrieValue

    void *TRIE_NULL = (<void *> 0)

    Trie *trie_new()
    void trie_free(Trie *trie)

    bint trie_insert(Trie *trie, char *key, TrieValue value)
    TrieValue trie_lookup(Trie *trie, char *key)
    bint trie_remove(Trie *trie, char* key)

    int trie_num_entries(Trie *trie)

# SLIST SECTION
cdef extern from "libcalg.h":
    ctypedef void *SListValue
    ctypedef struct SListEntry:
        pass
    ctypedef struct SListIterator:
        pass

    (void *) SLIST_NULL = (<void *> 0)
    void slist_free(SListEntry *list);
    SListEntry *slist_prepend(SListEntry **list, SListValue data);
    SListEntry *slist_append(SListEntry **list, SListValue data);
    SListValue *slist_to_array(SListEntry *list);
    int slist_length(SListEntry *list)

    SListEntry *slist_next(SListEntry *listentry)
    void slist_iterate(SListEntry **list, SListIterator *iterator)
    bint slist_iter_has_more(SListIterator *iterator)
    SListValue slist_iter_next(SListIterator *iterator)


