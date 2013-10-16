use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'swoppensystems',
    AUTHOR              => q{YOUR NAME <youremail@example.com>},
    VERSION_FROM        => 'lib/swoppensystems.pm',
    ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'                => 0,
        'YAML'                      => 0,
        'Dancer'                    => 1.311,
        'Dancer::Serializer::JSON'  => 0,
        'Dancer::Plugin::REST'      => 0.07,
        'Dancer::Plugin::Database'  => 2.01,
        'Template'                  => 0,
        'DBI'                       => 0,
        'DBD::SQLite'               => 0,
        'Module::Refresh'           => 0.17,
        'Digest::MD5::File'         => 0.08,
        'HTTP::Tiny'                => 0.035,
        'Net::SSLeay'               => 1.55,
	'JSON::Parse'		    => 0.23,
	'Text::CSV'		    => 1.32,
	'XML::Parser'		    => 2.41,
	'XML::Twig'		    => 3.39,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'swoppensystems-*' },
);
