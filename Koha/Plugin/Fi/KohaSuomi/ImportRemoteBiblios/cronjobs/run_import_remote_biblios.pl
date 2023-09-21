#! /usr/bin/perl
# IN THIS FILE #
#
# Connects to our booksellers services to fetch the selection lists and stages them to the MARC reservoir
# Calls the /misc/stage_file.pl to do the dirty staging!

use strict;
use warnings;

BEGIN {
    # find Koha's Perl modules
    # test carefully before changing this
    use FindBin;
    eval { require "$FindBin::Bin/../kohalib.pl" };
}
use
  CGI; # NOT a CGI script, this is just to keep C4::Templates::gettemplate happy
use C4::Context;
use Modern::Perl;
use Getopt::Long;
use Koha::Plugins;
use Koha::Plugin::Fi::KohaSuomi::ImportRemoteBiblios::Modules::RemoteBiblioPackageImporter;
use File::Basename;
my $dirname = dirname(__FILE__);

binmode( STDOUT, ":utf8" );
binmode( STDERR, ":utf8" );

my ( $help, $config);
my $verbose;

GetOptions(
    'verbose'       => \$verbose,
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
$configfile->{verbose} = $verbose;
$configfile->{stageFilePath} = $dirname."/stage_file.pl";
my $importer = Koha::Plugin::Fi::KohaSuomi::ImportRemoteBiblios::Modules::RemoteBiblioPackageImporter->new($configfile);
$importer->importFromRemote();
