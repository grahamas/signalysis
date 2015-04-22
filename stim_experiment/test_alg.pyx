
from alg cimport cTrie

def test_trie():
    cdef cTrie trie = cTrie()
    
    print <int>trie.has_key("Hello")
    cdef char *newval = "There"
    
    print <int>trie.insert(key="Hello", value=newval)
    print <char *>trie.lookup(key="Hello")
