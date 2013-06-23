use strict;
use warnings;

##my %column_headers = (
##  "Cache Type", "Cache Type",
##  "Cache ID", "Cache ID",
##  "Cache Unit", "Cache Unit",
##  "CH4", "",
##  "CH5", "",
##  "CH6", "",
##  "CH7", "",
##  "CH8", "",
##  "CH9", "",
##  "CH10", "",
##  "CH11", "",
##  "CH12", "",
##  "CH13", "",
##  "CH14", "",
##  "CH15", "",
##  "CH16", "",
##  "CH17", "",
##  "CH18", "",
##  "CH19", "",
##  "CH20", "",
##  "CH21", "",
##  "CH22", "",
##  "CH23", "",
##  "CH24", "",
##  "CH25", "",
##  "CH26", "",
##  "CH27", "",
##  "CH28", "",
##  "CH29", "",
##  "CH30", "",
##  "CH31", "",
##  "CH32", "",
##  "CH33", "",
##  "CH34", "",
##  "CH35", "",
##  "CH36", "",
##  "NoRetryAccesses", "NoRetryAccesses",
##  "NoRetryHits", "NoRetryHits");

sub memreport_to_csv {
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
sub memreport_full {
  &memreport_to_csv(0, 0);
}

sub experiment__cache_hitmiss {
  &memreport_to_csv(2,
                    's/^\[ si-(scalar|vector)-l1-(\d+) \]/\nl1\t$2\t$1\t/',
                    's/^\[ si-l2-(\d+) \]/\nl2\t$1\t \t/',
                    2,
                    "NoRetryAccesses", "NoRetryHits");
}

## Test 1: No whitelist
&memreport_full();

## Test 2: Whitelist both blocks and data
&experiment__cache_hitmiss();
