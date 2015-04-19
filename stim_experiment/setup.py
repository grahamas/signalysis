from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy as np

ext_module = Extension(
    "series_utils",
    ["series_utils.pyx"],
    extra_compile_args=['-fopenmp'],
    extra_link_args=['-fopenmp'],
    include_dirs=[np.get_include()]
)

setup(
    cmdclass = {'build_ext': build_ext},
    name = 'Time Series Utilities',
  	ext_modules = [ext_module],
)