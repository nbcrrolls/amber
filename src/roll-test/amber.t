#!/usr/bin/perl -w
# amber roll installation test.  Usage:
# amber.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my $isInstalled;
my $output;

my $TESTFILE = 'tmpamber';

#open(OUT, ">$TESTFILE.serial");
#print OUT <<END;
##!/bin/bash
#if test -f /etc/profile.d/modules.sh; then
#  . /etc/profile.d/modules.sh
#  module load ROLLCOMPILER ROLLMPI_ROLLNETWORK amber
#fi
#cd /opt/amber/test
#make test.serial
#make clean
#END
#close(OUT);

my @COMPILERS = split(/\s+/, 'ROLLCOMPILER');
my @NETWORKS = split(/\s+/, 'ROLLNETWORK');
my @MPIS = split(/\s+/, 'ROLLMPI');

my $AVER = VERSION;

# amber-common.xml
foreach my $mpi (@MPIS) {
  foreach my $compiler (@COMPILERS) {
    my $compilername = (split('/', $compiler))[0];
    SKIP: {
      $isInstalled = -d "/opt/amber/$compilername";
      if($appliance =~ /$installedOnAppliancesPattern/) {
        ok($isInstalled, "$compilername compiled amber installed");
      } else {
        ok(! $isInstalled, "$compilername-compiled amber not installed");
      }

      foreach my $network (@NETWORKS) {
        #my $command = "module load $compiler/${mpi}_$network; mpicc -o $TESTFILE.exe $TESTFILE.c";
        #$output = `$command 2>&1`;
        #ok(-x "$TESTFILE.exe", "Compile with $mpi/$compilername/$network");
        SKIP: {
          my $dir = "/opt/modulefiles/applications/amber$AVER";
          `/bin/ls $dir/$compilername 2>&1`;
          ok($? == 0, "amber$AVER/$compilername module installed");
          `/bin/ls $dir/.version.$compilername 2>&1`;
          ok($? == 0, "amber$AVER/$compilername version module installed");
          $output = `module load amber$AVER/$compiler; echo "Need to have amber test" 2>&1`;
          ok($? == 0, "module load amber$AVER/$compiler works");
        }
      }
    }
  }
}

#`rm -fr $TESTFILE*`;

