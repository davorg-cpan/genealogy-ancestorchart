package Genealogy::AncestorChart;

use strict;
use warnings;

use Moo;
use Types::Standard qw[HashRef Object];

has people => (
  is => 'ro',
  isa => HashRef[Object],
  required => 1,
);

sub count_rows {
  my $self = shift;

  return int ( keys( %{ $self->people } ) / 2 ) + 1;
}

sub rows {
  my $self = shift;

  my ($start, $end) = $self->row_range;

  my @rows = map { $self->row($_) } $start .. $end;

  return @rows;
}

sub row_range {
  my $self = shift;

  my $end = keys %{ $self->people };
  my $start = int(($end / 2) + 1);

  return ($start, $end);
}

sub row {
  my $self = shift;
  my ($rownum) = @_;

  my @cells;
  my $rowspan = 1;
  my $i       = $rownum;

  while (1) {
    my $person = $self->people->{$i};
    my $class  = $person->known ? 'success' : 'danger';
    my $desc   = "$i: " . $person->display_name;
    my $td     = qq[<td rowspan="$rowspan" class="$class">$desc</td>];
    unshift @cells, $td;

    last if $i % 2;
    $rowspan *= 2;
    $i       /= 2;
  }

  return "<tr>@cells</tr>\n";
}

1;
