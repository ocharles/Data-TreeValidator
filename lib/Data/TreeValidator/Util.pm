package Data::TreeValidator::Util;
# ABSTRACT: Helpful utilities for working with tree validators
use strict;
use warnings;

use Sub::Exporter -setup => {
    exports => [qw( fail_constraint )]
};

{
    package Data::TreeValidator::ConstraintError;
    use Moose;
    with 'Throwable';

    # XXX I think Throwable should provide this as a role - submit patch
    use overload
      q{""}    => 'as_string',
      fallback => 1;
    has 'message' => ( is => 'ro' );
    sub as_string { shift->message }
}

sub fail_constraint {
    Data::TreeValidator::ConstraintError->new(
        message => shift )->throw;
}

1;

=head1 DESCRIPTION

A collection of helpful utilities for working with tree validators.

All methods below are available for import into calling modules.

=method fail_constraint($message)

Raises an exception with the given C<$message>. Avoids extra information such as
a stack trace or line numbers

=cut

