package Data::TreeValidator::Constraints;
# ABSTRACT: A collection of constraints for validating data
use strict;
use warnings;

use Data::TreeValidator::Util qw( fail_constraint );
use Set::Object qw( set );

use Sub::Exporter -setup => {
    exports => [ qw( length options required type ) ]
};

sub required { \&_required }
sub _required {
    local $_ = shift;
    fail_constraint("Required") unless defined $_ && "$_" ne '';
}

sub length {
    my %args = @_;
    my ($min, $max) = @args{qw( min max )};
    return sub {
        my ($input) = @_;
        my $length = defined $input ? length($input) : 0;

        fail_constraint("Input must be longer than $min characters")
            if exists $args{min} && $length < $min;
        fail_constraint("Input must be shorter than $max characters")
            if exists $args{max} && $length > $max;
    }
}

sub options {
    my $valid = set(@_);
    return sub {
        my ($input) = @_;
        fail_constraint("Input must be a valid set member")
          unless $valid->contains($input);
    };
}

sub type {
    my $type = shift;
    return sub {
      fail_constraint('Input must be of type: ' . $type->name . '"')
        unless $type->check(@_);
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

=func required

Checks that $input is defined, and stringifies to a true value (not the empty
string)

=func length min => $min, max => $max

Checks that a given input is between C<$min> and C<$max>. You do not have to
specify both parameters, either or is also fine.

=func options @options

Checks that a given input is in the set defined by C<@options>.

=func type $type_constraint

Checks that a given input satisfies a given L<Moose::Meta::TypeConstraint>.  E.g. 

use MooseX::Types::Moose qw/Num/;
type(Num);

=cut
