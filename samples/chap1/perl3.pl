
sub two_times_minus {
  return shift(@_) * 2 - shift(@_);
}
print two_times_minus(3, 2); #=> 4
