package Test::Reporter::Transport::Metabase;

use warnings;
use strict;
use base 'Test::Reporter::Transport';
use CPAN::Metabase::Client::Simple;
use CPAN::Testers::Fact::LegacyReport;
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

  my $fact = CPAN::Testers::Fact::LegacyReport->new({
# XXX: How are we supposed to report this stuff?
#    id => 'RICHDAWE/Foo-Bar-1.0.tar.gz',
#    dist_author => 'RICHDAWE',
#    dist_file => 'Foo-Bar-1.0.tar.gz',

    resource => 'Foo-Bar-1.0.tar.gz',

    content => {
      grade => $report->grade(),
      osname => $^O, # XXX: Good enough?
      osversion => 42, # XXX: Real data
      archname => '6502', # XXX: Real data
      perlversion => $report->perl_version(),
      textreport => $report->report(),
    },      
  });

  # XXX: How does this indicate failure?
  $client->submit_fact($fact);
}

1;

__END__

=head1 NAME

Test::Reporter::Transport::Metabase - Metabase transport fo Test::Reporter

=head1 SYNOPSIS

    my $report = Test::Reporter->new(
        transport => 'Metabase',
        transport_args => {
            user => 'USERID',
            key => '1234567890abcdef',
            uri => 'http://metabase.server.example:3000/',
        },
    );

=head1 DESCRIPTION

This module submits a Test::Reporter report to the specified Metabase instance.

This requires online operation. If you wish to save reports
during offline operation, see L<Test::Reporter::Transport::File>.

=head1 USAGE

See L<Test::Reporter> and L<Test::Reporter::Transport> for general usage
information.

=head1 METHODS

These methods are only for internal use by Test::Reporter.

=head2 new

    my $sender = Test::Reporter::Transport::File->new( $params ); 
    
The C<new> method is the object constructor.   

=head2 send

    $sender->send( $report );

The C<send> method transmits the report.  

=head1 AUTHOR

=over

=item *

Richard Dawe (RICHDAWE)

=back

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
