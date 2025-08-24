use strict;
use warnings;

# Capstone -> Zydis aliases
my %aliases = (
  'FCOMPI' => 'FCOMIP',
  'FUCOMPI' => 'FUCOMIP',
  'JAE' => 'JNB',
  'JA' => 'JNBE',
  'JGE' => 'JNL',
  'JG' => 'JNLE',
  'JNE' => 'JNZ',
  'JE' => 'JZ',
  'SETAE' => 'SETNB',
  'SETA' => 'SETNBE',
  'SETGE ' => 'SETNL',
  'SETG' => 'SETNLE',
  'SETNE' => 'SETNZ',
  'SETE' => 'SETZ',
  'SETGE' => 'SETNL',
  'CMOVAE' => 'CMOVNB',
  'CMOVA' => 'CMOVNBE',
  'CMOVGE' => 'CMOVNL',
  'CMOVG' => 'CMOVNLE',
  'CMOVNE' => 'CMOVNZ',
  'CMOVE' => 'CMOVZ'
);

die "Usage: $0 flag_file mapping_file\n" unless @ARGV == 2;

my %zydis_insns = &read_zydis_flags($ARGV[0]);

open my $fdIn, '<',  $ARGV[1] or die "$ARGV[1]: $!\n";

while(<$fdIn>) {
  chomp;
  my $line = $_;
  if($line !~ /X86_INS_(.+)?\:/) {
    print "$line\n";
    next;
  }

  $line =~ /X86_INS_(.+):/;
  my $cs_name = $1;
  
  if(exists $aliases{$cs_name}) {
    $cs_name = $aliases{$cs_name};
  }

  if($cs_name eq 'FADD') {
    # Capstone doesn't have an explicit X86_INS_FADDP
    $line =~ /X86_ADD_(.+)?,/;
    if($1 eq 'FPrST0') {
      $cs_name = 'FADDP';
    }
  }
  if(exists $zydis_insns{$cs_name}) {
    print "$line\n";        # decl
    print scalar <$fdIn>;  # flags

    # Inject a comma after the perms
    my $perms = scalar <$fdIn>;
    chomp($perms);
    print "$perms,\n";

    print $zydis_insns{$cs_name};
  } else {
    print "$line\n";
  }
}

sub read_zydis_flags($) {
  my ($file) = @_;
  
  open my $fdIn, '<', $file or die "$file: $!\n";

  my %insns = ();

  while(<$fdIn>) {
    chomp;
    next if $_ eq '';
    my $name = $_;
    my $record = '';
    while(<$fdIn>) {
      last if m/ENDRECORD/;
      $record .= $_;
    }
    $insns{$name} = $record;
  }
  return %insns;
}
