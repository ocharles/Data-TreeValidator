package Data::TreeValidator::Constraints;
# ABSTRACT: A collection of constraints for validating data
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

=head1 SYNOPSIS

    use Data::TreeValidator::Constraints qw( required );

=head1 DESCRIPTION

Constraints currently take a single form, a subroutine reference. If the data
does not validate, an exception will be raised (which is caught by process
methods). If an exception is not raised, the data will be assumed to be valid.

All methods below are available for importing into using modules

=method required($input)

Checks that $input is defined, and stringifies to a true value (not the empty
string)

=cut
