use strict;
use warnings;

my $ignore = 0;

# Column Headers
print "Cache Type" . "\t";
print "Cache ID" . "\t";
print "Cache Unit" . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print " " . "\t";
print "NoRetryAccesses" . "\t";
print "NoRetryHits" . "\t";

while (my $line = <>) {
  chomp($line);

  # Ignore networks and global memory segments 
  if ($line =~ /^\[ Network/ ||
      $line =~ /^\[ si-gm/) {
    $ignore = 1;
  }

  if ($line =~ /^\[ si-l(\d+)-(\d+)(-(scalar|vector))?/) {
    $ignore = 0;
    # L1
    if($1 == "1") {
      print "\nl" . $1 . "\t" . "$2" . "\t" . "$4" . "\t";
    }

    # L2
    if($1 == "2") {
      print "\nl" . $1 . "\t" . "$2" . "\t" . " " . "\t";
    }
  }

  if( !$ignore ) {
    if ($line =~ /^.*=\s*(\S*)$/) {
      print $1 . "\t";
    }
  }
}
