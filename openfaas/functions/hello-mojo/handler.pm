package function::handler;
use strict;
use warnings;

sub handle {
  my ($request, $context) = @_;

  my $result = {
    message => "Hello Mojo"
  };

  $context->status(200)
          ->succeed($result);
}

1;