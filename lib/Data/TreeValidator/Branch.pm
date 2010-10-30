package Data::TreeValidator::Branch;
use Moose;
use namespace::autoclean;

use Data::TreeValidator::Types qw( HashTree Node );
use MooseX::Types::Moose qw( Str );
use MooseX::Types::Structured qw( Map );

use aliased 'Data::TreeValidator::Result::Branch' => 'Result',;
use MooseX::Params::Validate;

with 'Data::TreeValidator::Node';

has 'children' => (
    isa => Map[ Str, Node ],
    default => sub { {} },
    traits => [ 'Hash' ],
    handles => {
        children => 'values',
        names => 'keys',
        add_child => 'set',
        child => 'get',
    }
);

sub process {
    my $self = shift;
    my ($tree) = pos_validated_list(\@_,
        { isa => HashTree, coerce => 1 }
    );

    return Result->new(
        input => $tree,
        results => {
            map {
                $_ => $self->child($_)->process($tree->{$_})
            } $self->names
        }
    );
}

1;
