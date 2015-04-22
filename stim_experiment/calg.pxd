
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

cdef extern from "libcalg/hash-table.h":
    ctypedef struct HashTableStruct:
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

cdef extern from "libcalg/list.h":

    """
     * Represents an entry in a singly-linked list.  The empty list is
     * represented by a NULL pointer. To initialise a new singly linked 
     * list, simply create a variable of this type 
     * containing a pointer to NULL.
    """

    ctypedef struct _SListEntry SListEntry;

    """
     * Structure used to iterate over a list.
    """

    ctypedef struct _SListIterator SListIterator;

    """
     * Value stored in a list.
    """

    ctypedef void *SListValue;

    """
     * Definition of a @ref SListIterator.
    """

    struct _SListIterator {
        SListEntry **prev_next;
        SListEntry *current;
    };

    """
     * A null @ref SListValue.
    """

    (void *) SLIST_NULL = ((void *) 0)

    """
     * Callback function used to compare values in a list when sorting.
     *
     * @return   A negative value if value1 should be sorted before value2, 
     *           a positive value if value1 should be sorted after value2, 
     *           zero if value1 and value2 are equal.
    """

    ctypedef int (*SListCompareFunc)(SListValue value1, SListValue value2);

    """
     * Callback function used to determine of two values in a list are
     * equal.
     *
     * @return   A non-zero value if value1 and value2 are equal, zero if they
     *           are not equal.
    """

    ctypedef bint (*SListEqualFunc)(SListValue value1, SListValue value2);

    """
     * Free an entire list.
     *
     * @param list           The list to free.
    """

    void slist_free(SListEntry *list);

    """
     * Prepend a value to the start of a list.
     *
     * @param list      Pointer to the list to prepend to.
     * @param data      The value to prepend.
     * @return          The new entry in the list, or NULL if it was not possible
     *                  to allocate a new entry.
    """

    SListEntry *slist_prepend(SListEntry **list, SListValue data);

    """
     * Append a value to the end of a list.
     *
     * @param list      Pointer to the list to append to.
     * @param data      The value to append.
     * @return          The new entry in the list, or NULL if it was not possible
     *                  to allocate a new entry.
    """

    SListEntry *slist_append(SListEntry **list, SListValue data);

    """ 
     * Retrieve the next entry in a list.
     *
     * @param listentry    Pointer to the list entry.
     * @return             The next entry in the list.
    """

    SListEntry *slist_next(SListEntry *listentry);

    """
     * Retrieve the value stored at a list entry.
     *
     * @param listentry    Pointer to the list entry.
     * @return             The value at the list entry.
    """

    SListValue slist_data(SListEntry *listentry);

    """ 
     * Retrieve the entry at a specified index in a list.
     *
     * @param list       The list.
     * @param n          The index into the list .
     * @return           The entry at the specified index, or NULL if out of range.
    """

    SListEntry *slist_nth_entry(SListEntry *list, int n);

    """ 
     * Retrieve the value stored at a specified index in the list.
     *
     * @param list       The list.
     * @param n          The index into the list.
     * @return           The value stored at the specified index, or
     *                   @ref SLIST_NULL if unsuccessful.
    """

    SListValue slist_nth_data(SListEntry *list, int n);

    """ 
     * Find the length of a list.
     *
     * @param list       The list.
     * @return           The number of entries in the list.
    """

    int slist_length(SListEntry *list);

    """
     * Create a C array containing the contents of a list.
     *
     * @param list       The list.
     * @return           A newly-allocated C array containing all values in the
     *                   list, or NULL if it was not possible to allocate the 
     *                   memory for the array.  The length of the array is 
     *                   equal to the length of the list (see @ref slist_length).
    """

    SListValue *slist_to_array(SListEntry *list);

    """
     * Remove an entry from a list.
     *
     * @param list       Pointer to the list.
     * @param entry      The list entry to remove.
     * @return           If the entry is not found in the list, returns zero,
     *                   else returns non-zero.
    """

    bint slist_remove_entry(SListEntry **list, SListEntry *entry);

    """
     * Remove all occurrences of a particular value from a list.
     *
     * @param list       Pointer to the list.
     * @param callback   Callback function to invoke to compare values in the 
     *                   list with the value to remove.
     * @param data       The value to remove from the list.
     * @return           The number of entries removed from the list.
    """

    int slist_remove_data(SListEntry **list,
                          SListEqualFunc callback,
                          SListValue data);

    """
     * Sort a list.
     *
     * @param list          Pointer to the list to sort.
     * @param compare_func  Function used to compare values in the list.
    """

    void slist_sort(SListEntry **list, SListCompareFunc compare_func);

    """
     * Find the entry for a particular value in a list.
     *
     * @param list           The list to search.
     * @param callback       Callback function to be invoked to determine if
     *                       values in the list are equal to the value to be
     *                       searched for.
     * @param data           The value to search for.
     * @return               The list entry of the value being searched for, or
     *                       NULL if not found.
    """

    SListEntry *slist_find_data(SListEntry *list, 
                                SListEqualFunc callback,
                                SListValue data);

    """ 
     * Initialise a @ref SListIterator structure to iterate over a list.
     *
     * @param list           Pointer to the list to iterate over.
     * @param iter           Pointer to a @ref SListIterator structure to
     *                       initialise.
    """

    void slist_iterate(SListEntry **list, SListIterator *iter);

    """
     * Determine if there are more values in the list to iterate over.
     *
     * @param iterator       The list iterator.
     * @return               Zero if there are no more values in the list to
     *                       iterate over, non-zero if there are more values to
     *                       read.
    """

    bint slist_iter_has_more(SListIterator *iterator);

    """
     * Using a list iterator, retrieve the next value from the list. 
     *
     * @param iterator       The list iterator.
     * @return               The next value from the list, or SLIST_NULL if 
     *                       there are no more values in the list.
    """
        
    SListValue slist_iter_next(SListIterator *iterator);

    """ 
     * Delete the current entry in the list (the value last returned from
     * @ref slist_iter_next)
     *
     * @param iterator       The list iterator.
    """

    void slist_iter_remove(SListIterator *iterator);

