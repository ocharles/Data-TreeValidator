package Data::TreeValidator::Result;
# ABSTRACT: Role specifying the result of processing
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

=head1 DESCRIPTION

This role is the basis for the result of processing a specification with some
input.

=attr input

Gets the input that was passed in to process

=method errors

Returns an array of errors that occured during processing. May be empty.

This array is only for errors directly assossciated with this node.

=method error_count

Returns the amount of errors that occured when processing this node.

=method clean

Should return the cleaned data. It is required to be implemented by consuming
classes

=method valid

Should return true or false depending on whether the input was valid input for
this node. Required to be implemented by consuming classes.

=cut
