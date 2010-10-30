package Data::TreeValidator::Sugar;
use strict;
use warnings;

use aliased 'Data::TreeValidator::Branch';
use aliased 'Data::TreeValidator::Leaf';

use Sub::Exporter -setup => {
    exports => [ qw( branch leaf ) ],
};

use MooseX::Params::Validate;
use MooseX::Types::Moose qw( CodeRef );

sub branch (&;) {
    my ($code) = pos_validated_list(\@_,
        { isa => CodeRef }
    );

    my %children = $code->();
    return Branch->new( children => \%children );
}

sub leaf {
    return Leaf->new(@_);
}

1;
