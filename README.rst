.. hightlight:: rst

AMBER Roll
================
AMBER Molecular Dynamics

.. contents::

Introduction
--------------
This roll installs AMBER tools. 
There are 4 flavors compiled for each compiler (gnu, intel): ::

    serial,
    mpi
    cuda
    cuda mpi

Downloads
-----------
Amber is a licensed software. Get licensed files for AMBAER and AmberTools from 
Amarolab and save copy in nbcr.ucsd@gmail.com account
Download the appropriate amber source files into the ``src/amber``.
Download the benchmark suite in src/amber-test: ::
 
    # cd src/amber-test; wget http://ambermd.org/Amber14_Benchmark_Suite.tar.bz2


Building the roll
------------------
**Dependencies**

- The ``mpi`` roll must be installed on the build/install host. 
  depends on mpi libraries. 
- The ``intel`` roll must be installed on the build/install host. In the absence of intel compiler
  the roll should be buld with ``ROLLCOMPILEr='gnu'``. 
- The ``cuda`` roll must be installed on build/install host . In the absence of cuda, edit 
  ``src/amber/Makefile``  targets to remove cuda-specific compilation.
- The roll sources assumes that modulefiles provided by ``intel``, ``cuda`` and ``mpi``
  rolls are available.

The roll uses ``openmpi`` compiled with intel and gnu compilers for ``eth`` fabric. 
To make a roll use the following command: ::

    # make ROLLCOMPILER='gnu intel' ROLLMPI='openmpi'  ROLLNETWORK='eth' 2>&1 | tee build.log

A successful build will create the file ``amber-*.disk1.iso``.  


Installing
-------------

To install, execute these instructions on a Rocks frontend: ::

    # rocks add roll *.iso
    # rocks enable roll amber
    # (cd /export/rocks/install; rocks create distro)
    # rocks run roll amber | bash
    

What is installed
-------------------

Tthe roll installs amber and environment module files in: ::

    /opt/amber/gnu - compiled with GNU
    /opt/amber/intel - compiled with Intel compilers
    /opt/modulefiles/applications/amber<VERSION> - environment modules
    /root/rolltests/amber.t  - roll installation test
    /opt/amber/benchmark/Amber14_Benchmark_Suite.tar.bz2 - benchmark suit distro


Building GaMD version of roll
-----------------------------

For Sep 2015 workshop  buid `amberGaMD` roll based on a received patch for amber14 source 
Create the following changes to the roll source: ::

       modified:   src/amber-modules/amber.module.in
       modified:   src/amber-modules/version.mk
       modified:   src/amber/Makefile
       modified:   src/amber/version.mk
       modified:   version.mk

       replace in graphs/default: amber.xml with amberGaMD.xml
       replace in nodes: amber-common.xml.in with amberGaMD-common.xml.in

       add a patch to src/amber/ (patch received via email from author, source )

See diffs for the above files in GaMD-diffs file at the top of the roll.
After creating changes build `amberGaMD` roll

**Testing**

A test script ``amber.t`` can be run to verify proper
installation of the roll binaries and module files. To
run the test scripts execute the following command(s): ::

    # /root/rolltests/amber.t 

A benchmark suit distro (from Amber site) contains a shell script run_bench_CPU+GPU.sh
and required input to run suite of tests. Untar, adjust cpu and gpu counts in the script
for a specific host. 

