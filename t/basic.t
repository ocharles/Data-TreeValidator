use strict;
use warnings;
use Test::More;

use Devel::Dwarn;

use aliased 'Data::TreeValidator::Leaf';
use aliased 'Data::TreeValidator::Branch';

{
    package Validator;
    use Moose;
    extends 'Data::TreeValidator::Branch';

    use Data::TreeValidator::Constraints qw( required );
    use Data::TreeValidator::Sugar qw( leaf branch );

    has '+children' => (
        default => sub { {
            name => branch {
                first => leaf(
                    constraints => [ required ],
                ),
                last => leaf(
                    constraints => [ required ],
                )
            }
        } }
    );
}

my $clean;

my $validator = Validator->new;
$clean = $validator->process({
    'name.first' => 'Roger',
    'name.last' => 'Test'
});

Dwarn $clean->clean;

$clean = $validator->process({
    'name.first' => 'Roger',
    'name.last' => undef
});

Dwarn $clean->clean;


ok 1;
done_testing;
