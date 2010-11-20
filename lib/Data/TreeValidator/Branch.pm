package Data::TreeValidator::Branch;
# ABSTRACT: A branch of tree validation
use Moose;
use namespace::autoclean;

use Data::TreeValidator::Types qw( HashTree Node );
use MooseX::Types::Moose qw( CodeRef Maybe Str );
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
        child_names => 'keys',
        add_child => 'set',
        child => 'get',
    }
);

has 'cross_validator' => (
    isa => CodeRef,
    traits => [ 'Code' ],
    default => sub { sub {} },
    handles => {
        cross_validate => 'execute',
    }
);

sub process {
    my $self = shift;
    my ($tree) = pos_validated_list([ shift ],
        { isa => Maybe[HashTree], coerce => 1 }
    );
    my %args = @_;

    my $result = Result->new(
        input => $tree,
        results => {
            map {
                my $process = $tree->{$_} || $args{initialize}->{$_};
                $_ => $self->child($_)->process($process)
            } $self->child_names
        }
    );

    eval {
        $self->cross_validate($result->clean);
    };
    if ($@) {
        $result->add_error($@);
    }

    return $result;
}

1;

=head1 DESCRIPTION

Represents a branch in the tree, ie something that has child nodes. Almost all
your validation specifications will have at least one tree (unless it really
only takes a single piece of input).

=method children

Returns a list of all child nodes of this branch

=method child_names

Returns the names of all child nodes for this branch

=method add_child($name => $value)

Adds a child to the branch, with the name C<$name> and value C<$value>

=method child($name)

Returns the child with name C<$name>, or C<undef>

=method process($input)

Takes the input in C<$input> and validates it against this branch. The general
process here is to enumerate over each child of this branch, and fetch the
corresponding data from C<$input> and process that.

Returns a L<Data::TreeValidator:::Result::Branch>, which can be inspected to
determine if the branch validated, and for clean data.

=cut
