package Data::TreeValidator::Leaf;
# ABSTRACT: Represents a single leaf node in the validation tree specification
use Moose;
use namespace::autoclean;

use Data::TreeValidator::Types qw( Constraint Transformation Value );
use MooseX::Types::Moose qw( ArrayRef CodeRef );

use aliased 'Data::TreeValidator::Result::Leaf' => 'Result';

use MooseX::Params::Validate;
use Try::Tiny;

with 'Data::TreeValidator::Node';

has 'constraints' => (
    isa => ArrayRef[Constraint],
    default => sub { [] },
    traits => [ 'Array' ],
    handles => {
        constraints => 'elements',
        add_constraint => 'push',
    }
);

has 'transformations' => (
    isa => ArrayRef[Transformation],
    traits => [ 'Array' ],
    default => sub { [] },
    handles => {
        transformations => 'elements',
        add_transformation => 'push',
    }
);

sub process {
    my $self = shift;
    my ($input) = pos_validated_list([ shift ],
        { isa => Value }
    );
    my %args = @_;

    my $process = $input || $args{default};

    my @errors;
    for my $constraint ($self->constraints) {
        if (is_CodeRef($constraint)) {
            try {
                $constraint->( $process );
            }
            catch {
                push @errors, $_;
            }
        }
    }

    my $clean;
    if (@errors == 0) {
        $clean = $process;
        for my $transformation ($self->transformations) {
            $clean = $transformation->( $clean );
        }
    }

    return Result->new(
        input => $input,
        errors => \@errors,
        @errors == 0 ? (clean => $clean) : ()
    );
}

1;

=head1 DESCRIPTION

Represents a leaf in a tree, that is - a single atomic value. At some point all
branches will reduce to these nodes.

=method constraints

Returns an array of all constraints for this leaf.

=method add_constraint

Adds a constraint to this leaf, at the end of the list

=method transformations

Returns an array of all transformations for this leaf.

=method add_transformation

Adds a transformation for this leaf, at the end of the list

=method process($input)

Takes $input, and matches it against all the constraints for this leaf. If they
all pass (that is, none throw exceptions), then C<$input> is passed through all
leaf transformations.

AT the end of processing, a L<Data::TreeValidator::Result::Leaf> object is
returned. This can be inspected to determine if validation was sucessful, and
obtain clean data.

=cut
