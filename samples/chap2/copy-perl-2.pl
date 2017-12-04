
open(IN, $ARGV[0]) or die "$ARGV[0]: $!";
open(OUT, ">$ARGV[1]") or die "$ARGV[1]: $!";
while (<IN>) { print OUT; }
close IN;
close OUT;
