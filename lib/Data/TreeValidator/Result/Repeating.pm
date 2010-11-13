package Data::TreeValidator::Result::Repeating;
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
