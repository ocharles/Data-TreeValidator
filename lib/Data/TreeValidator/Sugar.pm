package Data::TreeValidator::Sugar;
use strict;
use warnings;

use aliased 'Data::TreeValidator::Branch';
use aliased 'Data::TreeValidator::Leaf';
use aliased 'Data::TreeValidator::RepeatingBranch';

use Sub::Exporter -setup => {
    exports => [ qw( branch leaf repeating ) ],
};

use MooseX::Params::Validate;
use MooseX::Types::Moose qw( CodeRef );

sub _branch {
    my ($class, $code) = @_;
    my %children = $code->();
    return $class->new( children => \%children );
}

sub branch (&;) {
    my ($code) = pos_validated_list(\@_,
        { isa => CodeRef }
    );
    return _branch(Branch, $code);
}

sub leaf {
    return Leaf->new(@_);
}

sub repeating (&;) {
    my ($code) = pos_validated_list(\@_,
        { isa => CodeRef }
    );
    return _branch(RepeatingBranch, $code);
}

1;
