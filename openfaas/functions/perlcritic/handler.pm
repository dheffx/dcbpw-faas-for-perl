package function::handler;

use Perl::Critic;

my $critic = Perl::Critic->new();

=pod

=h1 handle
    evaluate the string passed with Perl::Critic
    
    critique returns an array of Perl::Critic::Violations and convert_blessed is not on
    map the output in a format that can be encoded as json
    Args:
        context (str): request context
=cut

sub handle {
    my ($context) = @_;
    my @violations = $critic->critique(\$context);
    my @json_safe = map {
      {
        column_number => $_->column_number,
        description => $_->description,
        line_number => $_->line_number,
        logical_line_number => $_->logical_line_number,
        severity => $_->severity
      }
    } @violations;
    return \@json_safe;
}

1;
