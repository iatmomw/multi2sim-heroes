use strict;
use warnings;

my $line_number;
my $cycle = 1;

while (my $line = <STDIN>) {
  chomp($line);

  if ($line =~ /^clk=(\d+):/) {
    $line_number = $1;
  } else {
    print "Invalid line: " . $line . "\n";
    exit;
  }

  while ($cycle < $line_number) {
    print '0 ';
    $cycle = $cycle + 1;
  }

  # count number of matches to pattern
  my $count = () = eval('$line =~ ' . "/$ARGV[0]/g;");
  print $count . ' ';

  $cycle = $cycle + 1;
}

print "\n";
