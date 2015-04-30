CC="gcc"
#LDFLAGS="-L./venv/lib"
python alg_setup.py build_ext --inplace
python setup.py build_ext --inplace
