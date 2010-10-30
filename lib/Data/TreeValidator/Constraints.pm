package Data::TreeValidator::Constraints;
use strict;
use warnings;

use Sub::Exporter -setup => {
    exports => [ qw( required ) ]
};

sub required { \&_required }
sub _required {
    local $_ = shift;
    die "Required" unless defined $_ && "$_" ne '';
}

1;
