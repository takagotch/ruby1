sub f {
  my $arg = shift(@_);
  if ($arg > 0) {
    print "f: $arg\n";
    return 1;
  }
  else {
    return 0;
  }
}

sub g {
  my $arg = shift(@_);
  if ($arg > 5 && $arg < 10) {
    print "g: $arg\n";
    return 1;
  }
  else {
    return 0;
  }
}

sub test {
  my $arg = shift(@_);
  f($arg) or return 0;
  g($arg) or return 0;
  return 1;
}

test(8) or die;
test(2) or die;
