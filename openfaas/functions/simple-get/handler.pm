package function::handler;

use HTTP::Tiny;

=pod

=h1 handle
    fetch the user info from github for the passed in value

    simple example to show build-args for ssl in use

    Args:
        context (str): request context
=cut

sub handle {
    my ($context) = @_;
    chomp $context;
    my $response = HTTP::Tiny->new->get("https://api.github.com/users/$context");
    return "Failed!" if !$response->{success};
    return $response->{content};
}

1;
