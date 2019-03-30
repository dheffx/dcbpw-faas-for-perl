package function::handler;
use strict;
use warnings;

use Date::Calc::Endpoints;

=pod

=h1 handle
    handle a request to the function
    Args:
      request (Mojo::Message::Request)
      context (function::context)
=cut

sub handle {
  my ($request, $context) = @_;

  my $endpoints = Date::Calc::Endpoints->new(%{$request->query_params->to_hash});
  my ($start_date, $end_date, $last_date) = $endpoints->get_dates();

  if (scalar @{$endpoints->get_error()}) {
    $context->status(400)
      ->succeed($endpoints->get_error());
  } else {
    my $result = {
      start_date => $start_date,
      end_date => $end_date,
      last_date => $last_date
    };
    $context->status(200)
      ->succeed($result);
  }
}

1;
