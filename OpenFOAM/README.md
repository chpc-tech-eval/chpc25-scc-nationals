OpenFOAM
===========

OpenFOAM is an open-source library of methods, routines and solvers for solving partial differential equations.  Please refer to https://www.openfoam.com/ for more information and to obtain the software.  The recommended version for this competition is v2506, but v2406 and v2412 are also acceptable.  Bear in mind that there are at least three separate forks of OpenFOAM, but the others use different version numbering schemes.

# Installation
Installation instructions are given at https://www.openfoam.com/.  The most recent version of the software is OpenFOAM-v2506, with additional packages in ThirdParty-v2506.  It is possible to download a pre-compiled version of the software, to do a package install, to use a container or to compile from source.  Building from source is not particularly troublesome, provided that the essential dependencies have already been installed.  Bear in mind that the compile process takes a long time, several hours or more.  Make use of parallel compilation to prevent this taking too long.  Set the environment variable WM_NCOMPPROCS to the number of processes which you intend using for compilation.

# System Requirements
OpenFOAM-v2506 will work with any recent version of Linux operating system, compiler stack and MPI implementation.  Edit the source script OpenFOAM-v2506/etc/bashrc to specify the compiler and MPI to use.  Source this script before starting the compile process with the script OpenFOAM-2506/Allwmake   

# Downloading the Source Code
Obtain the source code from https://www.openfoam.com/news/main-news/openfoam-v2506  


## Building and Deploying
Create a directory $HOME/OpenFOAM.  In that, unpack the OpenFOAM and ThirdParty tarballs.  Edit the file $HOME/OpenFOAM/OpenFOAM-v2506/etc/bashrc to customize the desired installation directory (if necessary), compiler and MPI implementation.  Do not change the environment variable WM_ARCH_OPTION from 64 to 32.  This script file must be sourced in order to set up the compile and run environment.



# Benchmark 0:
In the subdirectory OpenFOAM-v2506/tutorials will be found many test cases with run scripts to validate that the software is operational.  For example, the case tutorials/incompressible/simpleFoam/windAroundBuildings can be used.  It has been used in modified form to create the three actual benchmark cases.


# Benchmark 1, 2 and 3:
There are three versions of this benchmark, using models of different sizes: 3.2 million cells, 10 million cells and 20 million cells.  All three use the same procedure:

Build the case with the mesh generation application snappyHexMesh.  A script makeCase.sh has been provided for this purpose.  It does the following: creates a simple regular starting blockMesh, partitions this for parallel processing with the command decomposePar, runs snappyHexMesh in parallel, reconstructs the partitioned mesh, and renumbers the mesh for efficiency.  

Note that OpenFOAM uses an unconventional approach to parallelisation by domain decomposition - the individual partitions are written to separate directories.  This applies to snappyHexMesh as well as the flow solver simpleFoam.  After processing, the model can be reconstructed.  The decomposition is controlled by the file system/decomposeParDict in the case directory.  The number of domains must match the number of MPI ranks provided as an argument to the mpirun command.  In this case, the number of domains has provisionally been set to 16 in the decomposeParDict file.  The environment variable nproc should thus be set to a value of 16 before the makeCase.sh script can be executed.  

Once the mesh has been constructed, the benchmark run can be executed.  The system/decomposeParDict file should be edited in order to use the number of MPI ranks and the desired domain decomposition scheme.  The system/controlDict file has been set up to allow the solution to run for 250 time steps.  We are interested in the time taken for these 250 time steps. Simulation results will not be written to file after these 250 time steps. 

The performance will mainly be determined by the number of parallel processes used, how these are distributed and the memory bandwidth per process.  OpenFOAM needs low-latency networking for best distributed parallel performance, therefore more nodes may not provide the expected improvement, especially for the small case.  

Do not edit the files system/fvSolution and system/fvSchemes in the case directory.  

A sample Slurm script runFoam.sh has been provided.  It is not mandatory to use it, but it might be informative.  The command line to run the solver is:

mpirun -np $nproc simpleFoam -parallel

To this you can add parameters controlling process placement and binding.

Please note that if you ommit the parameter -parallel, you will get $nproc instances of identical serial processes, and not the desired parallized calculation.

Re-direct the output to a file for the submission for each run.



# Visualization
For one of the benchmark cases, generate an image of the results.  OpenFOAM output can be visualized in a number of different ways, but the use of Paraview (https://www.paraview.org/) is more or less universal.  It can be used in many ways, here is one process:
1. You will need valid results of a simulation run.  For this purpose, edit the file system/controlDict and change the value of endTime to 1001.  This will cause the solver to run past the first step (1000 time steps) where results are written to file.
2. Run the utility reconstructPar to build a single directory, which will be called '1000' containing the solution.
3. Create a file with the extension .foam in the case directory.  The name of the file can be anything, such as bananas.foam or apples.foam.
4. This .foam file can be loaded into the visualization software Paraview.  There are many ways of using Paraview, such as running a server on the cluster and a client on a laptop.  However, for simplicity sake, simply remove the process* directories and transfer the rest of the case to a laptop and do the visualization on the laptop.  Paraview is commonly used on Linux workstations, but this requires X-windows, x-forwarding and OpenGL or Mesa libraries.  

# Submission
1. One representative visualization image
2. For each of the three cases, the output file of the best result (minimum time) for that case, demonstrating that 250 time steps had been executed, and the time taken for all of these.
3. For each of the three cases, a summary of the configuration used, specifically compiler, MPI, number of MPI ranks, number of nodes and process placement and binding parameters.
