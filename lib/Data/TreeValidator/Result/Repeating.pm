package Data::TreeValidator::Result::Repeating;
# ABSTRACT: Returns the result of processing a repeating branch
use Moose;
use namespace::autoclean;

use Data::TreeValidator::Types qw( Result );
use MooseX::Types::Moose qw( ArrayRef );

with 'Data::TreeValidator::Result';

has 'results' => (
    isa => ArrayRef[Result],
    traits => [ 'Array' ],
    handles => {
        results => 'elements',
        result_count => 'count',
    }
);

sub valid {
    my $self = shift;
    (grep { $_->valid } $self->results) == $self->result_count;
}

sub clean {
    my $self = shift;
    return [
        map  { $_->clean }
        grep { $_->valid }
        $self->results
    ];
}

1;

=head1 DESCRIPTION

Contains the result of calling process on a
L<Data::TreeValidator::RepeatableBranch>

=method results

Returns an array of all result objects (one for each time the branch was
repeated).

=method result_count

The amount of results processed

=method valid

Returns true if all result objects are valid

=method clean

Returns an array reference of all results, after calling C<clean> on them.

=cut

