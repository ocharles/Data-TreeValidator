package Data::TreeValidator::Result::Leaf;
use Moose;

has 'clean' => (
    is => 'ro',
    predicate => 'has_clean_data'
);

sub valid { shift->has_clean_data }

with 'Data::TreeValidator::Result';

1;
