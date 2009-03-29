# XXX: Where does this package live?
package CPAN::Testers::Fact::TestSummary;
use base 'CPAN::Metabase::Fact::Hash';

# XXX: Where does this package live?
package CPAN::Testers::Fact::TestOutput;
use base 'CPAN::Metabase::Fact::Hash';

# XXX: Where does this package live?
package CPAN::Testers::Fact::TesterComment;
use base 'CPAN::Metabase::Fact::Hash';

# XXX: Where does this package live?
package CPAN::Testers::Fact::PerlMyConfig;
use base 'CPAN::Metabase::Fact::Hash';

# XXX: Where does this package live?
package CPAN::Testers::Fact::TestEnvironment;
use base 'CPAN::Metabase::Fact::Hash';

# XXX: Where does this package live?
package CPAN::Testers::Fact::Prereqs;
use base 'CPAN::Metabase::Fact::Hash';

# XXX: Where does this package live?
package CPAN::Testers::Fact::InstalledModules;
use base 'CPAN::Metabase::Fact::Hash';

package Test::Reporter::Transport::Metabase;

use warnings;
use strict;
use base 'Test::Reporter::Transport';
use CPAN::Testers::Report;
use CPAN::Testers::Fact::LegacyReport;
use vars qw/$VERSION/;
$VERSION = '1.0';
$VERSION = eval $VERSION;

use Data::Dumper;

sub new {
  my ($class, $user, $key, $client, $uri) = @_;

  # Default to a local server.
  # XXX: Default to some CPAN Testers box?
  $uri ||= 'http://127.0.0.1:3000';

  # Default to CPAN::Metabase::Client::Simple.
  $client ||= 'Simple';
  $client = "CPAN::Metabase::Client::$client";

  return bless {
    user  => $user,
    key => $key,
    client => $client,
    uri => $uri,
  } => $class;
}

sub send {
  my ($self, $report) = @_;

  # Load specified metabase client.
  my $class = $self->{client};
  eval "require $class";

  my $client = $class->new(
    user => $self->{user},
    key => $self->{key},
    url => $self->{uri},
  );

  # Buidl CPAN::Testers::Report with its various component facts.
  my $report_mb = CPAN::Testers::Report->open(
# XXX: How are we supposed to report this stuff?
#    id => 'RICHDAWE/Foo-Bar-1.0.tar.gz',
#    dist_author => 'RICHDAWE',
#    dist_file => 'Foo-Bar-1.0.tar.gz',
    resource => 'RICHDAWE/Foo-Bar-1.0.tar.gz',
  );

  # XXX: Real data
  foreach (
    'CPAN::Testers::Fact::TestSummary',
    'CPAN::Testers::Fact::TestOutput',
    'CPAN::Testers::Fact::TesterComment',
    'CPAN::Testers::Fact::PerlMyConfig',
    'CPAN::Testers::Fact::TestEnvironment',
    'CPAN::Testers::Fact::Prereqs',
    'CPAN::Testers::Fact::InstalledModules',
  ) {
    $report_mb->add($_ => {});
  }

  $report_mb->add('CPAN::Testers::Fact::LegacyReport' => {
    grade => $report->grade(),
    # XXX: Good enough? Need to get this from the perl-v output,
    # in case we're picking up a report that was originally written
    # to disk.
    osname => $^O,
    osversion => 42, # XXX: Real data
    archname => '6502', # XXX: Real data
    perlversion => $report->perl_version(),
    textreport => $report->report(),
  });

  # add more facts?

  $report_mb->close();

  # XXX: This assumes the client returns an HTTP::Response.
  # When there are alternative metabase clients (e.g.: raw sockets
  # into BINGOS queueing system), this will need changing.
  my $response = $client->submit_fact($report_mb);
  if (!$response->is_success()) {
    die $response->status_line();
  }
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
