package Data::TreeValidator::Leaf;
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
    my ($input) = pos_validated_list(\@_,
        { isa => Value }
    );

    my @errors;
    for my $constraint ($self->constraints) {
        if (is_CodeRef($constraint)) {
            try {
                $constraint->( $input );
            }
            catch {
                push @errors, $_;
            }
        }
    }

    my $clean;
    if (@errors == 0) {
        $clean = $input;
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
