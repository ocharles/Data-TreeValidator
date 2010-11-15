package Data::TreeValidator::Result::Branch;
# ABSTRACT: Contains the result of processing a branch
use Moose;
use namespace::autoclean;

use Data::TreeValidator::Types qw( Result );
use MooseX::Types::Moose qw( Str );
use MooseX::Types::Structured qw( Map );

with 'Data::TreeValidator::Result';

has 'results' => (
    isa => Map[Str, Result],
    traits => [ 'Hash' ],
    handles => {
        results => 'values',
        result_names => 'keys',
        result_count => 'count',
        result => 'get',
    }
);

sub valid {
    my $self = shift;
    (grep { $_->valid } $self->results) == $self->result_count;
}

sub clean {
    my $self = shift;
    return {
        map {
            $_ => $self->result($_)->clean
        } grep {
            $self->result($_)->valid
        } $self->result_names
    }
}

1;

=head1 DESCRIPTION

This contains the result of processing a L<Data::TreeValidator::Branch>.

=method results

Returns a list of all result values.

=method result_names

Returns a list of all child names that were processed

=method result_count

Returns the amount of child results this node directly has

=method result($name)

Fetch a result with a given name

=method valid

This result will be valid if all children are valid

=method clean

Clean data will be returned as a hash reference of result name to it's clean
data. If a result is not clean, it will not be included in the clean hash.

=cut

