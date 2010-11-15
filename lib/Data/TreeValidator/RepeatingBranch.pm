package Data::TreeValidator::RepeatingBranch;
use Moose;
use namespace::autoclean;

use Data::TreeValidator::Types qw( HashTree );

use aliased 'Data::TreeValidator::Result::Branch' => 'Result';
use aliased 'Data::TreeValidator::Result::Repeating' => 'RepeatingResult';

use MooseX::Params::Validate;
use MooseX::Types::Moose qw( ArrayRef );

with 'Data::TreeValidator::Node';
extends 'Data::TreeValidator::Branch';

sub process {
    my $self = shift;
    my ($tree) = pos_validated_list(\@_,
        { isa => ArrayRef[HashTree], coerce => 1 }
    );

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
            } @$tree
        ]
    );
}

1;
