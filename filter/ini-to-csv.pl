use strict;
use warnings;

use lib "./";

use csv_column_headers qw( memreport_column_headers);

sub ini_to_csv {
  my $ignore = 0;
  my $ctr;

  my $start_blockAllowed = 1;
  my $count_blockAllowed = $_[$start_blockAllowed - 1];
  my $end_blockAllowed = $start_blockAllowed + $count_blockAllowed;

  my $start_dataAllowed = $start_blockAllowed + $count_blockAllowed + 1;
  my $count_dataAllowed  = $_[$start_dataAllowed - 1];
  my $end_dataAllowed = $start_dataAllowed + $count_dataAllowed;

  line: while (my $line = <>) {
    chomp($line);

    # handle blocks
    if ($line =~ /^\[ /) {
      # block whitelist exists
      if($count_blockAllowed > 0) {
        $ignore = 1;

        my $line_orig = $line;

        for($ctr = $start_blockAllowed; $ctr < $end_blockAllowed; $ctr = $ctr + 1) {
          eval('$line =~ ' . "$_[$ctr];");
        }

        if($line ne $line_orig) {
          $ignore = 0;
          print $line;
          $line = $line_orig;
        }
      }

      # no block whitelist exists
      if($count_blockAllowed == 0) {
        print "\n" . $line . "\t";
      }
    }

    next line if ($ignore);

    # handle data
    if ($line =~ /^(.*)\ =\s*(\S*)$/) {
      # data whitelist exists
      if ($count_dataAllowed > 0) {
        for($ctr = $start_dataAllowed; $ctr < $end_dataAllowed; $ctr = $ctr + 1) {
          if($1 eq $_[$ctr]) {
            print $2 . "\t";
          }
        }
      }
  
      # no data whitelist exists
      if ($count_dataAllowed == 0) {
        print $2 . "\t";
      }
    }
  }
}

## Tests
sub ini_full {
  &ini_to_csv(0, 0);
}

sub experiment__cache_hitmiss {
  &ini_to_csv(2,
              's/^\[ si-(scalar|vector)-l1-(\d+) \]/\nl1\t$2\t$1\t/',
              's/^\[ si-l2-(\d+) \]/\nl2\t$1\t \t/',
              2,
              "NoRetryAccesses", "NoRetryHits");
}

## Test 1: No whitelist
#&ini_full();

## Test 2: Whitelist both blocks and data
&experiment__cache_hitmiss();
