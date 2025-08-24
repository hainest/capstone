use strict;
use warnings;

die "Usage: $0 old new\n" unless @ARGV == 2;

my %old = &read_file($ARGV[0]);
my %new = &read_file($ARGV[1]);

print "Diffing '$ARGV[0]' against '$ARGV[1]'\n";
print "Found ", scalar keys %old, " old instructions.\n";
print "Found ", scalar keys %new, " new instructions.\n";


print "In old, but not new: ";
&do_diff(\%old, \%new);

print "In new, but not old: ";
&do_diff(\%new, \%old);


sub read_file($) {
  my ($file) = @_;
  open my $fdIn, '<',  $file or die "$file: $!\n";

  my %insns = ();
  while(<$fdIn>) {
    chomp;
    my $line = $_;
    if($line =~ /X86_INS_(.+)?\:/) {
      $insns{$1}=1;
    }
  }
  return %insns;
}

sub do_diff($$) {
  my ($first, $second) = @_;

  my $found = 0;
  for my $i (keys %{$first}) {
    if(!exists $second->{$i}) {
      print "\n  $i";
      $found = 1;
    }
  }
  if($found) {
    print "\n";
  } else {
    print "NONE\n";
  }
}
