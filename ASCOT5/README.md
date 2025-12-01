ASCOT5
===========

[ASCOT5](https://ascot4fusion.github.io/ascot5/index.html) (Accelerated Simulation Code for Tokamaks, version 5) is a high-performance test-particle orbit-following code for computing particle orbits in 3D geometry for fusion plasma physics and engineering. It solves minority species' distribution functions, transport, and losses in tokamaks and stellarators. It supports advanced physics models, multiple integration schemes, and parallel execution using MPI.

# Installation
ASCOT5 requires a functioning C compiler and libraries like MPI for parallel processin

# System Requirements
ASCOT5 requires a functioning C compiler and libraries like MPI for parallel processin. Below is a table of recommended **minimum** software versions that should be filled out:

| Program  | Version | Description                                |
| ---      |     --- | ---                                        |
| GCC or Intel Complier or AMD Complier | GCC ≥ 8.0 / Intel OneAPI ≥ 2022 / AOCC ≥ 4.1     | C compiler with OpenMP support                                       |
|  OpenMPI |   4.1.4 |    MPI implementation for distributed computing                                        |
|  HDF5    |     1.12.2    |    Data storage library (with parallel support)                                        |
|  Python    |    3.9     |    For pre- and post-processing with a5py                                        |
|  CMake   |    3.20     |      Build system (for HDF5)                                      |
| NumPy  |    1.21     |      Python numerical library                                      |
|  h5py   |     3.7    |    Python HDF5 interface                                        |
| Matplotlib   |  3.5   |  Python plotting library

# Downloading the Source Code
A copy of the source code can be obtained from GitHub:
```bash
git clone https://github.com/ascot4fusion/ascot5.git
cd ascot5
```
To verify downlaod:
```bash
ls -la
```

Ensure that these files exist:
```text
ascot5/
├── a5py/           # Python interface
├── src/            # C source code
├── doc/            # Documentation and tutorials
├── build/          # Build directory (created during compilation)
├── Makefile        # Main build file
└── README.md
```


## Building and Deploying
Compile the library (libascot.so)
```bash
# Compile library with MPI and OpenMP support
make libascot -j <num_procs> MPI=1 

# Verify library was created
ls -lh build/libascot.so

#Expected output:
-rwxr-xr-x 1 <user> group 2.5M <date> <time> build/libascot.so
```

Compile the main executable (ascot5_main)
```bash
# Compile main program
make ascot5_main -j <num_procs> MPI=1

# Verify executable was created
ls -lh build/ascot5_main

#Expected output:
-rwxr-xr-x 1 user group 2.5M <date> <time> build/ascot5_main
```

Install Python Interface (a5py), these can be done in two ways:
```bash
# Install in user environment or virtual environment
pip install --user -e .

OR

# Create a virtual environment
python3 -m venv /shared/apps/ascot5-env
source /shared/apps/ascot5-env/bin/activate
pip install -e .

#Verify installation 
python3 -c "from a5py import Ascot; print('a5py installed successfully')"
```
Install additional Python dependencies
```bash
pip install --user numpy scipy matplotlib h5py ipython pandas
```

# Benchmark 1 & 2: Alpha Particle Slowing-Down 
In ASCOT5, the distribution function is saved as an N-dimensional histogram. This histogram divides the chosen phase-space into a grid of bins. Every time a marker moves during the simulation, ASCOT5 figures out which bin it belongs to and increases that bin’s value by the marker’s weight multiplied by the time-step. The marker weights are treated as particles per second, meaning the markers represent a constant particle source, such as alpha-particle birth. The final distribution is therefore a steady-state distribution with units of particles.

For the benchmarks we will run, these distributions and also be use them to test how ASCOT5 scales with different numbers of markers. In Benchmark 1, we will run the simulation using 8,000 markers. In Benchmark 2, we will increase this to 200 000 markers. By comparing the results and performance from these two runs, we can see how well ASCOT5 handles an increased distributiona and how it scales with an increased workload

## Benchmark 1

Run the provided script called `setup_benchmark1.py` to generate the input file 
```bash
python3 setup_benchmark1.py
```
verify that the file was created:
```bash
ls -lh benchmark1.h5
h5ls benchmark1.h5
```

To run your simulation, you need to call your executable and specify the input file:
```bash
<command you use to launch programs>
  <path to your built executable>/ascot5/build/ascot5_main
  --in=<your input file>  #It will have the .h5 extension
  --d="<your description>" # Can be anything 
  ```
Run the provided verification script called `verify_benchmark1.py`, store the results in a text file.
```bash
python3 verify_benchmark1.py | tee benchmark1_verification.txt
```

## Benchmark 2:
Run the provided script called `setup_benchmark2.py` to generate the input file 
```bash
python3 setup_benchmark2.py
```
verify that the file was created:
```bash
ls -lh benchmark2.h5
h5ls benchmark2.h5
```

To run your simulation, you need to call your executable and specify the input file:
```bash
<command you use to launch programs>
  <path to your built executable>/ascot5/build/ascot5_main
  --in=<your input file>  #It will have the .h5 extension
  --d="<your description>" # Can be anything 
  ```
Edit the provided verification script called `verify_benchmark1.py` to verify the results from benchmark 2, store the results in a text file.

# Submission

Submit for both benchmarks:
    
    - Your output file
    - Benchmark verification text file
    - Details of the configuration of how the benchmark was ran