package Data::TreeValidator::Util;
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
