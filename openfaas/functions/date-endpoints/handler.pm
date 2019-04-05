package function::handler;
use strict;
use warnings;

use Date::Calc::Endpoints;

=pod

=h1 handle
=cut

sub handle {
  my ($c) = @_;

  my $endpoints = Date::Calc::Endpoints->new(%{$c->req->query_params->to_hash});
  my ($start_date, $end_date, $last_date) = $endpoints->get_dates();

  if (scalar @{$endpoints->get_error()}) {
    $c->render(json => $endpoints->get_error(), status => 400);
  } else {
    my $result = {
      start_date => $start_date,
      end_date => $end_date,
      last_date => $last_date
    };
    $c->render(json => $result, status => 200);
  }
}

1;
