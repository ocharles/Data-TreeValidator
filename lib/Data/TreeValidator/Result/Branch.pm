package Data::TreeValidator::Result::Branch;
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
