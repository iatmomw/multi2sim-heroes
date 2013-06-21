use strict;
use warnings;

my $scalar_accesses = 0;
my $scalar_hits = 0;
my $vector_accesses = 0;
my $vector_hits = 0;
my $l2_accesses = 0;
my $l2_hits = 0;

while (my $line = <>) {
  chomp($line);

  if ($line =~ /^l(1|2)\t(\d+)\t(scalar|vector|\ )?\t(\d+)\t(\d+)/) {
    # L1
    if($1 == "1") {
      if($3 eq "scalar") {
        $scalar_accesses = $scalar_accesses + $4;
        $scalar_hits = $scalar_hits + $5;
      }

      if($3 eq "vector") {
        $vector_accesses = $vector_accesses + $4;
        $vector_hits = $vector_hits + $5;
      }
    }

    # L2
    if($1 == "2") {
      $l2_accesses = $l2_accesses + $4;
      $l2_hits = $l2_hits + $5;
    }
  }
}

print " \tAccesses\tHits\tRatio\n";

print "Scalar\t" . $scalar_accesses . "\t" . $scalar_hits . "\t";
if($scalar_accesses != 0) {
  print $scalar_hits / $scalar_accesses . "\n";
} else {
  print "%%\n";
}

print "Vector\t" . $vector_accesses . "\t" . $vector_hits . "\t";
if($vector_accesses != 0) {
  print $vector_hits / $vector_accesses . "\n";
} else {
  print "%%\n";
}

print "L2\t" . $l2_accesses . "\t" . $l2_hits . "\t";
if($l2_accesses != 0) {
  print $l2_hits / $l2_accesses . "\n";
} else {
  print "%%\n";
}
