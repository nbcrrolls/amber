#
# Makefile
#
# @Copyright@
# @Copyright@

ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif
ifndef ROLLMPI
  ROLLMPI = openmpi
endif

PKGROOT = /opt/amber
REDHAT.ROOT = $(PWD)/../../

-include $(ROCKSROOT)/etc/Rules.mk

COMPILERSETUP = echo

ifeq ("$(ROLLCOMPILER)", "intel")
COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(ROLLCOMPILER); \
    module load mkl; \
  fi 
endif

MPIMODULE = $(ROLLMPI)_$(ROLLNETWORK)
MPISETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(ROLLCOMPILER)/$(MPIMODULE); \
  fi; \
  echo Using MPI from $${MPIHOME} 

CUDASETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load cuda; \
  fi; \
  export CUDA_HOME=/opt/cuda; \
  echo Using CUDA from $${CUDA_HOME} 

build:
	bzip2 -dc $(SOURCE_PKG) | tar xf -
	bzip2 -dc $(TOOLS_PKG) | tar xf -
	( \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
	  $(CUDASETUP); \
	  export AMBERHOME=`pwd`/$(SOURCE_DIR); \
	  cd $${AMBERHOME}; pwd ; \
	  ./update_amber --update ; \
	  ./configure $(ROLLCOMPILER); \
	  make -j8 install;  make clean; \
	  ./configure -mpi $(ROLLCOMPILER); \
	  make -j8 install; make clean; \
	  ./configure -cuda $(ROLLCOMPILER); \
	  make -j8 install; make clean; \
	  ./configure -cuda -mpi $(ROLLCOMPILER); \
	  make -j8 install; make clean; \
	)

install::
	mkdir -p -m 754 $(ROOT)/$(PKGROOT)/src
	cp $(SOURCE_DIR)/src/config.h $(ROOT)/$(PKGROOT)/src/
	cp -r $(SOURCE_DIR)/bin $(SOURCE_DIR)/dat $(SOURCE_DIR)/include $(ROOT)/$(PKGROOT)
	rm -rf $(ROOT)/$(PKGROOT)/bin/FEW.pl
	cp $(SOURCE_DIR)/$(TOOLS_NAME)/src/FEW/FEW.pl  $(ROOT)/$(PKGROOT)/bin
	cp -r $(SOURCE_DIR)/share $(SOURCE_DIR)/lib  $(ROOT)/$(PKGROOT)
	(cd $(ROOT)/$(PKGROOT); ln -s lib lib64)

clean::
	rm -rf $(SOURCE_DIR)
