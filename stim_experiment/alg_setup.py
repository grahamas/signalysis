from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_module = Extension(
    "alg",
    ["alg.pyx"],
    include_dirs=['libcalg']
)

setup(
    cmdclass = {'build_ext': build_ext},
    name = 'C-Algorithms in Cython',
  	ext_modules = [ext_module],
)
