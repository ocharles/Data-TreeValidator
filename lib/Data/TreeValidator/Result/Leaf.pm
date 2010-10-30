package Data::TreeValidator::Result::Leaf;
use Moose;

has 'clean' => (
    is => 'ro',
    predicate => 'valid',
);

with 'Data::TreeValidator::Result';

1;
