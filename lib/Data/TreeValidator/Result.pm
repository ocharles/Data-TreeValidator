package Data::TreeValidator::Result;
use Moose::Role;
use namespace::autoclean;

use MooseX::Types::Moose qw( ArrayRef );

requires 'clean', 'valid';

has 'input' => (
    is => 'ro',
    required => 1
);

has 'errors' => (
    isa => ArrayRef,
    traits => [ 'Array' ],
    handles => {
        errors => 'elements',
        error_count => 'count',
    }
);

1;
