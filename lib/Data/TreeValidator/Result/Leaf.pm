package Data::TreeValidator::Result::Leaf;
# ABSTRACT: The result of processing a leaf node
use Moose;

has 'clean' => (
    is => 'ro',
    predicate => 'has_clean_data'
);

sub valid { shift->has_clean_data }

with 'Data::TreeValidator::Result';

1;

=head1 DESCRIPTION

This result object is the result of calling process on a
L<Data::TreeValidator::Leaf>.

=method clean

Returns clean data for this field.

=method has_clean_data

A predicate to determine if this field has clean data.

=method valid

An alias for C<has_clean_data>.

=cut

