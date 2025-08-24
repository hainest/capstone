use strict;
use warnings;

die "Usage: $0 /path/to/InstructionDefinitions.inc\n" unless @ARGV==1;

open my $fdIn, '<', $ARGV[0] or die "$ARGV[0]: $!\n";

my %flags = ();
my %all_insns = (); # zydis has duplicate entries

my %multiples = (
  # There are 3- and 4-arg versions of cmp
  # Capstone only has entries for the 3-arg version, so use that index.
  'CMPSB' => 43,
  'CMPSD' => 43,
  'CMPSQ' => 46,
  'CMPSW' => 46,
  'SCASB' => 46,
  'SCASD' => 46,
  'SCASQ' => 43,
  'SCASW' => 43,
  
  # Zydis has separate entries for the regular and VEX versions
  # Capstone doesn't seem to have these, so just use the regular version
  'ADC' => 45,
  'ADCX' => 39,
  'ADOX' => 10,
  'BEXTR' => 71,
  'LZCNT' => 63,
  'ROL' => 41,
  'ROR' => 41,
  'SAR' => 55,
  'SBB' => 38,
  'SHL' => 56,
  'SHR' => 56,
  'TZCNT' => 58,
  'RCL' => 28,
  'RCR' => 29,
);

while(<$fdIn>) {
  my $line = $_;
  chomp $line;
  $line =~ s/^\s*\{\s*//;
  next if $line eq '';
  next if $line =~ /^const/;
  next if $line =~ /^#ifndef/;
  next if $line =~ /^#endif/;
  next if $line =~ /^};/;
  
  my $targ = $_;
  $targ =~ s/\s//g;
  next if exists $all_insns{$targ};
  $all_insns{$targ}=1;

  my ($mnemonic, $flags) = (split(' ', $line))[0,6];

  # Ignore any instructions that don't modify flags
  $flags =~ /ZYDIS_NOTMIN\((.+)?\)/;
  my $flag_index = hex($1);
  next if $flag_index == 0;

  $mnemonic =~ s/ZYDIS_MNEMONIC_//;
  if(exists $multiples{$mnemonic}) {
    $flag_index = $multiples{$mnemonic};
  }
  $flags{$mnemonic}{$flag_index}=1;
}

{
  print "\nInstructions with multiple definitions: ";
  for my $x (sort keys %flags) {
    my @keys = keys %{$flags{$x}};
    if(@keys > 1) {
      print "\n  $x {", (map {sprintf("%x, ", $_);} @keys), "}";
    }
  }
  print "\n";
}

open my $fdOut, '>', "flag_indices.inc" or die "$!\n";

my $num_insns = scalar keys %flags;
print $fdOut "#include <array>\nstd::array<const insn_flag_index, $num_insns> insn_flags {{\n";

for my $m (sort keys %flags) {
  for my $f (sort keys %{$flags{$m}}) {
    print $fdOut "{\"$m\", $f},\n";
  }
}

print $fdOut "}};\n";
