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

  if ($line =~ /^\[ si(-(scalar|vector))?-l(\d+)-(\d+)/) {
    $ignore = 0;
    # L1
    if($3 == "1") {
      print "\nl" . $3 . "\t" . "$4" . "\t" . "$2" . "\t";
    }

    # L2
    if($3 == "2") {
      print "\nl" . $3 . "\t" . "$4" . "\t" . " " . "\t";
    }
  }

  if( !$ignore ) {
    if ($line =~ /^.*=\s*(\S*)$/) {
      print $1 . "\t";
    }
  }
}
