package Data::TreeValidator::Transformations;
# ABSTRACT: Common data transformations
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

=head1 DESCRIPTION

Common transformations of data that you may find useful.

=func boolean

Converts any true value to 1, or returns 0 otherwise. A true value is Perl's
definition of what true is.

=cut
