use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Test::Reporter::Transport::Metabase',
    AUTHOR              => 'Richard Dawe <richdawe@cpan.org>',
    VERSION_FROM        => 'lib/Test/Reporter/Transport/Metabase.pm',
    ABSTRACT_FROM       => 'lib/Test/Reporter/Transport/Metabase.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Test-Reporter-Transport-Metabase-*' },
);
