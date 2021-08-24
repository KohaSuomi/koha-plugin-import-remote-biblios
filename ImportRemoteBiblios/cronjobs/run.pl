#! /usr/bin/perl
# IN THIS FILE #
#
# Connects to our booksellers services to fetch the selection lists and stages them to the MARC reservoir
# Calls the /misc/stage_file.pl to do the dirty staging!

use Modern::Perl;
use Koha::Plugin::Fi::KohaSuomi::ImportRemoteBiblios::Modules::RemoteBiblioPackageImporter;

binmode( STDOUT, ":utf8" );
binmode( STDERR, ":utf8" );

my ( $help, $config);
my $verbose = 0;

GetOptions(
    'verbose=i'     => \$verbose,
    'config=s'      => \$config,
    'h|help'        => \$help,
);

my $usage = "
 -c --config   Config file path (Mandatory).
";

if ( $help ) {
    print $usage;
    exit;
}

if(!$config) {
    print "Define config file path\n";
    exit;
}

my $configfile = eval { YAML::XS::LoadFile($config) };
my $importer = Koha::Plugin::Fi::KohaSuomi::ImportRemoteBiblios::Modules::RemoteBiblioPackageImporter->new($configfile);
$importer->importFromRemote();
