package Test::Reporter::Transport::Metabase;

use warnings;
use strict;
use base 'Test::Reporter::Transport';
use CPAN::Metabase::Client::Simple;
# XXX: Use a CPAN Testers fact?
use CPAN::Metabase::Fact::TestFact;
use vars qw/$VERSION/;
$VERSION = '1.0';
$VERSION = eval $VERSION;

use Data::Dumper;

sub new {
  my ($class, $user, $key, $uri) = @_;

  # Default to a local server.
  # XXX: Default to some CPAN Testers box?
  $uri ||= "http://127.0.0.1:3000";

  return bless {
    user  => $user,
    key => $key,
    uri => $uri,
  } => $class;
}

sub send {
  my ($self, $report) = @_;

  print Dumper($self);

  my $client = CPAN::Metabase::Client::Simple->new(
    user => $self->{user},
    key => $self->{key},
    url => $self->{uri},
  );

  my $fact = CPAN::Metabase::Fact::TestFact->new({
    dist_author => 'RICHDAWE',
    dist_file => 'Foo-Bar-1.0.tar.gz',
    content => "I says FAIL!",
#    content => {
#      status => $report->grade(),
#    },
  });

  $client->submit_fact($fact);

  # $report->write();
}

1;

__END__

=head1 NAME

Test::Reporter::Transport::Metabase - The great new Test::Reporter::Transport::Metabase!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Test::Reporter::Transport::Metabase;

    my $foo = Test::Reporter::Transport::Metabase->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Richard Dawe, C<< <richdawe at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-reporter-transport-metabase at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Reporter-Transport-Metabase>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::Reporter::Transport::Metabase


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Reporter-Transport-Metabase>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-Reporter-Transport-Metabase>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-Reporter-Transport-Metabase>

=item * Search CPAN

L<http://search.cpan.org/dist/Test-Reporter-Transport-Metabase>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Richard Dawe, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut
