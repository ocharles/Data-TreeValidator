use strict;
use warnings;
use Test::More;
use Test::Routine;
use Test::Routine::Util;
use lib 't/lib';

use aliased 'Data::TreeValidator::Branch';
use aliased 'Mock::Data::TreeValidator::Leaf' => 'MockLeaf';

test 'branch public api' => sub {
    my $branch = Branch->new;
    can_ok($branch, $_)
        for qw(
            children child_names add_child child
            process
        );
};

test 'empty branch' => sub {
    my $branch = Branch->new;

    my $result = $branch->process( {} );
    ok(defined $result, 'can process with no input');
    ok($result->valid, 'gives a valid result');
    is_deeply($result->clean => {}, 'result has no data');
};

test 'empty branch with input' => sub {
    my $branch = Branch->new;

    my $result = $branch->process( { ignore => 'me' } );
    ok(defined $result, 'can process with extra input');
    ok($result->valid, 'gives a valid result');
    is_deeply($result->clean => {}, 'result has no data');
};

test 'branch with children' => sub {
    my $child = MockLeaf->new;
    my $branch = Branch->new(
        children => {
            child => $child
        }
    );

    my $input = { child => 'Hurrah' };
    my $result = $branch->process($input);
    ok($child->was_processed, 'processes all children');
    is_deeply($result->input => $input,
        'the result object has the given input');
    is($result->result('child')->input => 'Hurrah',
        'the result object has correct result objects for children');
    is($result->result_count => 1,
        'result object only has results for children');
};

test 'branch with an initializer' => sub {
    my $leaf = MockLeaf->new;
    my $branch = Branch->new(
        children => {
            child => $leaf
        }
    );
   
    my $initialize = { child => 'Value' };
    my $result = $branch->process(undef, initialize => $initialize);

    ok($result->valid,
        'processing with an initializer gives a valid result');
    is_deeply($result->clean => $initialize,
        'clean value takes the initializers value');
};

run_me;
done_testing;
