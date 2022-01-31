use Test::More;

package Person;

sub new {
  my $class = shift;
  return bless { display_name => $_[0] };
}

sub display_name {
  return $_[0]->{display_name};
}

sub known {
  return rand > .2;
}

package main;

use Genealogy::AncestorChart;

my %people = map {
  $_ => Person->new( 'Person ' . $_ )
} 1 .. 7;

ok(my $gac = Genealogy::AncestorChart->new( people => \%people ),
   'Got an object');

isa_ok($gac, 'Genealogy::AncestorChart');
is(keys %{$gac->people}, 7, 'Right number of people');

is $gac->count_rows, 4, 'Right number of rows';

use Data::Dumper;
diag Dumper $gac->rows;

done_testing;
