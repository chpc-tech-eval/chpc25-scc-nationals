HemePure
=========

HemePure is a piece of software that initially started development at the University College London and was initially based on the [lattice Boltzmann method](https://github.com/hemelb-codes/hemelb) to simulate macroscopic blood fluid flow in complex 3D vascular geometries of blood vessel networks. **Optionally** refer to the following publications for more information on the origins and performance analysis of the software:
* M.D. Mazzeo & P.V. Coveney, "HemeLB: A high performance parallel lattice-Boltzmann code for large scale fluid flow in complex geometries", Comput. Phys. Commun. (2008) https://doi.org/10.1016/j.cpc.2008.02.013.
* D. Groen, J. Hetherington, H.B. Carver, R.W. Nash, M.O. Bernabeu, "Analysing and modelling the performance of the HemeLB lattice-Boltzmann simulation environment", J. Comput. Sci. (2013) https://doi.org/10.1016/j.jocs.2013.03.002.

More recent publications, and how the original source code evolved from HemeLB can be found here, [HemePure](https://github.com/hemelb-codes/HemePure).

# Installation Instructions

The main lattice-Boltzman solver is written in C++ and its parallelisation is implemented via MPI. Additionally the application relies on several external libraries for tasks as XML processing, domain decomposition, unit testing, and real time visualization.

## Obtaining the source code

A copy of the source code can be obtained from GitHub:
```
git clone https://github.com/UCL-CCS/HemePure.git
```

## Dependencies

Install or build your choice of `C/C++` and `MPI` compiler implementations, `Boost`, `CMake`, `CPPUnit`, `CTemplate`, `TinyXML` and `ZLib`. Additionally, building **HemePure** also requires the following dependencies which are provided with and can be built together with source:
* [GKlib](https://github.com/KarypisLab/GKlib),
* [METIS](https://github.com/KarypisLab/METIS) and
* [ParMETIS](https://github.com/KarypisLab/ParMETIS).

> [!TIP]
> You may make use of GKlib, METIS and ParMETIS libraries that you build and compile yourself from [https://github.com/KarypisLab/]'s' GitHub repo or any other reputable source of the ParMETIS source code.

## Building HemePure

Descend into the `HemePure` folder from the GitHub repository you'd cloned earlier:
```
cd <PATH-TO-BUILD>/HemePure
```

Examine the `FullBuild.sh` file, which can refer back to for guidance on building the dependencies *(optionally)* and source for `HemePure`. Follow the instructions for a typical `SRCBuild()`, i.e.:
```
cd src
FOLDER=<sensible_name>

# Uncomment to clean build options
# rm -rf $FOLDER

mkdir $FOLDER
cd $FOLDER
cmake -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} -DHEMELB_USE_GMYPLUS=OFF -DHEMELB_USE_MPI_WIN=OFF -DHEMELB_USE_SSE3=ON -DHEMELB_USE_AVX2=ON ..

make -j$(nprocs)
```

> [!TIP]
> Should your CPU architecture support it, consider additionally turning on AXV512 vectorization.

Should your application successfully compile, link and build, you will have `hemepure` binary executable in your build directory.

# Benchmark: Bifurcation

From the main `HemePure` folder from the GitHub repository you'd cloned earlier, navigate to the high resolution bifurcation example:
```
cd examples/bifurcation/bifurcation_hires/
```

## Examining the `input.xml` file

> [!CAUTION]
> You do not need to edit any variables in this file!

This file details the various components used to conduct the simulation:
### Simulation information
* Time step length
* Total number of time steps
* Lattice spacing / voxel size
* Simulation domain geometry
* Initial conditions (pressure)

### Boundary conditions

Simulations have all of their **input** and **output** locations independently parameterized.

> [!NOTE]
> There is a single **input** section and two **output** sections.

### Simulation outputs

Finally the simulation output information is recorded for further analysis and visualization, where the velocity and pressure of lattice sites are stored in:
* `whole.dat`: all lattice sites over entire domain volume,
* `inlet.dat`: surface lattice sites of the inlet.

## Running the Bifurcation example

Launch the simulation using `mpirun`:
```
mpirun -N <NUM_PROCESSES> ../../../src/build_PV/hemepure -in input.xml -out <OUTPUT_DIR>
```

You are required to complete all time steps of the simulation and to your objective is to try and minimize the total simulation runtime. Submit your `report.txt` and `report.xml` files from your <OUTPUT_DIR>.


# Benchmark Visualization


