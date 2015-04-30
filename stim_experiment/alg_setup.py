#distutils: libraries = calg
#distutils: include_dirs = ./venv/include/libcalg-1.0
#distutils: runtime_library_dirs = ./venv/lib


from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize

libpath = './venv/lib'
incpath = './venv/include'

alg_module = Extension(
    "alg",
    ["alg.pyx"],
    libraries = ['calg'],
    include_dirs = [incpath],
    runtime_library_dirs = [libpath],
    library_dirs = [libpath],
)

test_module = Extension(
    "test_alg",
    ["test_alg.pyx"],
    libraries = ['calg'],
    include_dirs = [incpath],
    runtime_library_dirs = [libpath],
    library_dirs = [libpath],
)

extensions = [alg_module, test_module]

setup(
    cmdclass = {'build_ext': build_ext},
    name = 'C-Algorithms in Cython',
  	ext_modules = cythonize(extensions, gdb_debug=True)
)
