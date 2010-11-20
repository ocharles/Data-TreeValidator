package Data::TreeValidator::Constraints;
# ABSTRACT: A collection of constraints for validating data
use strict;
use warnings;

use Data::TreeValidator::Util qw( fail_constraint );
use Set::Object qw( set );

use Sub::Exporter -setup => {
    exports => [ qw( length options required ) ]
};

sub required { \&_required }
sub _required {
    local $_ = shift;
    fail_constrant("Required") unless defined $_ && "$_" ne '';
}

sub length {
    my %args = @_;
    my ($min, $max) = @args{qw( min max )};
    return sub {
        my ($input) = @_;

        fail_constraint("Input must be longer than $min characters")
            if exists $args{min} && length($input) < $min;
        fail_constraint("Input must be shorter than $max characters")
            if exists $args{max} && length($input) > $max;
    }
}

sub options {
    my $valid = set(@_);
    return sub {
        my ($input) = @_;
        $valid->contains($input);
    };
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
