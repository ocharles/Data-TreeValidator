package Data::TreeValidator::Transformations;
use strict;
use warnings;

use Sub::Exporter -setup => {
    exports => [qw( boolean )],
};

sub boolean { \&_boolean }
sub _boolean {
    my ($input) = @_;
    return $input ? 1 : 0;
}

1;
