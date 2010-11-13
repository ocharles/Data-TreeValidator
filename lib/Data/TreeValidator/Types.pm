package Data::TreeValidator::Types;
use MooseX::Types -declare => [qw(
    Constraint
    FlatMap
    Node
    NodeName
    Result
    HashTree
    Transformation
    Value
)];

use CGI::Expand qw( expand_hash );
use Hash::Flatten qw( unflatten );

use MooseX::Types::Moose
    qw( ArrayRef CodeRef Str Undef ),
    Value => { -as => 'MooseValue' };

use MooseX::Types::Structured qw( Dict Map );

subtype HashTree, as Map[
    NodeName, ArrayRef | Value | HashTree
];

subtype NodeName, as Str, where { /^[^\.]+$/ };

subtype FlatMap, as Map[ Str, Value ];

coerce HashTree, from FlatMap, via { expand_hash($_) };

role_type Node, { role => 'Data::TreeValidator::Node' };

role_type Result, { role => 'Data::TreeValidator::Result' };

subtype Value, as Undef | MooseValue;

subtype Constraint, as CodeRef;

1;
