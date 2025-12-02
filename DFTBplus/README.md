DFTB+
=======

DFTB+ implements approximate density functional theory (DFT) approaches for solving and simulating atomistic quantum mechanical systems. The fast quantum mechanical atomistic calculation based on the Density Functional Tight Binding method, most recent features can be found [DFTB+ paper](https://doi.org/10.1063/1.5143190) and [DFTB+ website](https://dftbplus.org/).

# Installation Instructions

The preferred way of installing the DFTB+ package is through the [conda-forge](https://anaconda.org/conda-forge) channel the [Anaconda](https://anaconda.org/) package management framework. However, you **will** be building DFTB+ from source.

> [!TIP]
> If you are genuinely struggling to build the package and it's dependencies, then you may download and install one of the binaries from [conda-forge](http://www.dftbplus.org/download/dftb-stable/). Note however, that this will not give you an optimal, nor performant binary.

Before proceeding to build and install DFTB+ from source, ensure that you have an OpenMP compatible C/C++ & Fortran Compiler, CMake, an MPI implementation, Math Library (i.e. LAPACK / BLAS / ScaLAPACK), [ELSI](https://wordpress.elsi-interchange.org/) (recommended for MPI parallel builds) and Python.

1. Download and unpack the source code:
   ```
   wget https://github.com/dftbplus/dftbplus/releases/download/24.1/dftbplus-24.1.tar.xz
   tar -xvf dftbplus-24.1.tar.xz
   ```
1. Ensure that your environment is correctly configured and build the package from inside the directory you've just unpacked:
   ```
   # For a parallel threaded build, additionally add -DWITH_OMP=YES, -DWITH_MPI=YES and -DWITH_ELSI=YES
   FC=gfortran CC=gcc cmake -DCMAKE_INSTALL_PREFIX=$HOME/opt/dftb+ -B _build .

   cmake --build _build -j
   ```

   Typically this will install the binaries to `~/opt/dftb+`.
1. Verify that your application binary has been successfully built:
   ```
   ls ~/opt/dftb+/bin
   ```

1. Once you've successfully built the application, download the benchmark files:
   ```
   cd ~/opt/dftb+/

   wget https://dftbplus-recipes.readthedocs.io/en/latest/_downloads/5919f4094cd60c5c70c13b47928442f5/recipes.tar.bz2

   tar -xvf recipes.tar.bz2

   cd recipes

   # Download all the Slater-Koster files required to run the benchmarks
   ./scripts/get_slakos
   ```

1. Hybrid Parallelism

   You will run and optimize the run for a hybrid, i.e. both OpenMP and MPI parallelism combined. Configure your OpenMP threads to correspond to the number of cores you have in each of your CPUs and your number of MPI Ranks to corresponded to the number of CPUs you have in your cluster.
   ```
   # Remember to set the number of OpenMP
   export OMP_NUM_THREADS=<>
   ```

1. Ensure that the `dftb+` binary is in your `PATH` or loaded into your environment using LMOD.

1. Run the benchmark and generate simulation output.

   You will be running a molecular dynamics benchmark where the (classical) dynamics of the atoms are simulated in different thermodynamical ensembles and with different methods of integrating the equations of motion.

   ```
   cd recipes/moleculardynamics/thermalise

   dftb+ | tee output
   ```

1. Rerun this configuration, for at least 4 different permutations and combinations of OpenMP threads to MPI Ranks.

   Tabulate the results in table with the following columns:
   * OpenMP Threads
   * MPI Ranks
   * Total CPU Time [s]
   * Total Wall Clock [s]

1. Rerun the benchmark over longer simulation time.

   Edit the input file `dftb_in.hsd` and make the following changes:
   ```
   # Time step for MD
   TimeStep [fs] = 0.5

   ...

   # total of 100 ps
   Steps = 200000

   ...

   MaxSCCIterations = 10000
   ```

   Use the optimal combination of OpenMP threads to MPI Ranks that you'd determined from the table.

# Required submission

You are required to submit a REAMD.md file explaining your submission (compilers, MPI, build process and parameters), your build and compilation scripts, your compiled binary, your table comparing performance with varying OpenMP threads to MPI Ranks, your output files `md.out` and `output` files for verification.

This benchmark will be scored and evaluated according to:
1. 10000 steps [2%]
1. Table [4%]
1. 200000 steps [4%]
