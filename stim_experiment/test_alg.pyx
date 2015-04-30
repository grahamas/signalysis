
import numpy as np
from alg cimport cTrie, cGrowingList
cimport calg

def test_trie():
    cdef cTrie trie = cTrie()
    
    print <int>trie.has_key("Hello")
    cdef char *newval = "There"
    
    trie.insert(key="Hello", value=newval)
    print <char *>trie.lookup(key="Hello")

def test_growinglist():
    cdef double first_dbl = 10
    cdef double second_dbl = 15
    cdef cGrowingList glist = cGrowingList()
    glist.first(first_dbl)
    glist.append(second_dbl)
    print np.asarray(glist)

    cdef double third_dbl = 42
    glist.append(third_dbl)
    print np.asarray(glist)

