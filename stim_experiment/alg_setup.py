from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

libcalgpath_inc = './venv/include/libcalg-1.0/'
libcalgpath_lib = './venv/lib'

alg_module = Extension(
    "alg",
    ["alg.pyx"],
    include_dirs=[libcalgpath_inc],
    libraries=['calg'],
    library_dirs=[libcalgpath_lib],
    runtime_library_dirs=[libcalgpath_lib]
)

test_module = Extension(
        "test_alg",
        ["test_alg.pyx"],
        include_dirs=[libcalgpath_inc],
        library_dirs=[libcalgpath_lib],
        runtime_library_dirs=[libcalgpath_lib]
)

setup(
    cmdclass = {'build_ext': build_ext},
    name = 'C-Algorithms in Cython',
  	ext_modules = [alg_module, test_module],
)
