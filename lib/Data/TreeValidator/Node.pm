package Data::TreeValidator::Node;
# ABSTRACT: Represents a node in the validation tree specification
use Moose::Role;
use namespace::autoclean;

requires 'process';

1;

=head1 DESCRIPTION

This role is used as a market to indicate that a certain object can be used as
validation specification.

=method process($input)

This method is required for all classes that consume this role.

It takes some form of input, and should return an object that does the
L<Data::TreeValidator::Result> role.

=cut
