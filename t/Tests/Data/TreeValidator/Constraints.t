use strict;
use warnings;
use Test::More;
use Test::Fatal;
use Test::Routine;
use Test::Routine::Util;

use Data::TreeValidator::Constraints qw( required );

test '"required" constraint' => sub {
    my $constraint = required;
    ok(!exception { $constraint->('Some input') },
        'non-empty string passes required constraint');

    ok(exception { $constraint->(undef) },
        'constraint does not allow undef input');

    ok(exception { $constraint->('') },
        'constraint does not allow empty string input');
};

run_me;
done_testing;

