HPC Challenge
=============

Your team will need to compile and run the **HPCC** benchmark suite. This code includes several micro-benchmarks which test various performance aspects of the cluster. The suite includes **HPL**, **DGEMM** and **FFT** which test floating point performance. **STREAM** and **RandomAccess** are included to access memory performance. **PTRANS** and *'Communication bandwidth and latency'* are used to assess network performance. Further information and instructions about the benchmark can be found here [HPC Challenge Benchmark](http://www.hpcchallenge.org/hpcc/)

## Getting the source code

You need to run version *1.5.0*, which is available for download from the following website:
```bash
wget http://www.hpcchallenge.org/projectsfiles/hpcc/download/hpcc-1.5.0.tar.gz
```

Alternatively the source can be obtained from GitHub:
```bash
git clone https://github.com/icl-utk-edu/hpcc
```

If you can produce a higher individual **HPL** score outside of **HPCC** (through use of alternate software or hardware), you may include this result to supplement your HPCC submission for judging.

## Compiling, Building and Running the Benchmark

Your team is required to produce benchmark results obtained with both:
1. **GNU C Compilers (GCC)**, an open-source **MPI** implementation, *i.e. (OpenMPI or MPICH)*, and open-source maths libraries (BLAS, FFTW, etc..)
2. Intel's oneAPI HPC Development Kit or the AMD Equivalent for the AMD based systems

The general prescription that can be used to build **HPL**, is as follows:
- Copy an HPL template `Makefile` from `hpl/setup` to `hpl` and make appropriate changes to `MPI` and `BLAS` sections, 
- Compile HPCC
  ```bash
  make <target>
  ```
- Edit the `hpccinf.txt` file and configure the *HPL parameters (N, NB, P and Q)* for your cluster.
- Run the benchmark using MPI:
  ```bash
   mpirun -np <N> -hostfile <path_to_hostfile> ./hpcc
  ```
## Tuning HPL.dat file

For guidance, use online resources, such as [HPL Calculator](https://www.advancedclustering.com/act_kb/tune-hpl-dat-file/) to determine the theoretical **FLOPS** performance of your hardware (**Peak**), and from that a realistic achievable score (**Rmax**).

## Submission

To easily interpret the benchmark results, you can use the script provided `format.pl`:
```bash
 perl format.pl -w -f hpccoutf.txt
```

For each of your respective build(s) and run(s), you must submit your:
1. `README.md` a file describing the versions of the software you used to build HPCC,
1. `Makefile`,
1. `hpccinf.txt` input files, 
1. `hpccoutf.txt` formatted output files, and
1. `hpcc` executable binaries.

You are permitted to submit the best High Performance Linpack (**HPL**) score that you are able to achieve, independently of the rest of **HPCC**.

High Performance Conjugate Gradients
====================================

**HPCG** is intended as a complement to the **High Performance LINPACK (HPL)*** benchmark. It is designed to exercise computational and data access patterns that more closely match a different and broad set of important applications. See [HPCG Benchmark](https://hpcg-benchmark.org/) for more information.

## Getting the source code

There is little setup and configuration required for this benchmark, so limited guidance is provided. A reference version of **HPCG** is available for download, which you can compile and run:
```bash
wget https://hpcg-benchmark.org/downloads/hpcg-3.1.tar.gz
```

Alternatively the source can be obtained from GitHub:
```bash
git clone https://github.com/hpcg-benchmark/hpcg/
```
Lastly, it is possible to find prebuilt versions of HPCG which should provide optimal performance. You are required to use **HPCG** version **3.1** or newer.

## Submission

You must once again build **HPCG** using both (1.) **GCC**, an open-source **MPI** implementation, and open-source maths libraries; and (2.) the equivalent Intel or AMD implementation.

Similarly, as was the case for **HPCC**, you must submit a `README.md` file describing the libraries and versions used to build **HPCG**, all relevant input and output files, and the executable binaries used in your best run.

