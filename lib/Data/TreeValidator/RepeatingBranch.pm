package Data::TreeValidator::RepeatingBranch;
# ABSTRACT: A branch that can have its input repeated multiple times
use Moose;
use namespace::autoclean;

use Data::TreeValidator::Types qw( HashTree );

use aliased 'Data::TreeValidator::Result::Branch' => 'Result';
use aliased 'Data::TreeValidator::Result::Repeating' => 'RepeatingResult';

use MooseX::Params::Validate;
use MooseX::Types::Moose qw( ArrayRef Maybe );

with 'Data::TreeValidator::Node';
extends 'Data::TreeValidator::Branch';

sub process {
    my $self = shift;
    my ($tree) = pos_validated_list([ shift ],
        { isa => Maybe[ ArrayRef[HashTree] ], coerce => 1 }
    );
    my %args = @_;

    my $process = $tree || $args{default};

    return RepeatingResult->new(
        input => $tree,
        results => [
            map {
                my $element = $_;
                Result->new(
                    input => $element,
                    results => {
                        map {
                            $_ => $self->child($_)->process($element->{$_})
                        } $self->child_names
                    }
                )
            } @$process
        ]
    );
}

1;

=head1 DESCRIPTION

A repeatable branch is one that has a specification, and can consume input
multiple times. The branch can have any valid specification (including
repeatable elements).

This class has all the functionality of L<Data::TreeValidation::Branch>.

=method process($input)

Takes an array reference as input, and attempts to validate each element against
the branch specification.

Returns a L<Data::TreeValidator::Result::Repeating> result object, which can be
inspected to determine if the processing was valid, and to obtain the cleaned
data (which will be wrapped as an array reference).

=cut

