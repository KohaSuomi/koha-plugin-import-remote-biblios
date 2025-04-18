package Koha::Plugin::Fi::KohaSuomi::ImportRemoteBiblios;

## It's good practice to use Modern::Perl
use Modern::Perl;

## Required for all plugins
use base qw(Koha::Plugins::Base);
use Koha::Plugin::Fi::KohaSuomi::ImportRemoteBiblios::Modules::RemoteBiblioPackageImporter;

## We will also need to include any Koha libraries we want to access
use C4::Context;
use utf8;

## Here we set our plugin version
our $VERSION = "1.4";

## Here is our metadata, some keys are required, some are optional
our $metadata = {
    name            => 'Import remote biblios',
    author          => 'Johanna Räisä',
    date_authored   => '2021-08-24',
    date_updated    => "2021-09-07",
    minimum_version => '17.05.00.000',
    maximum_version => undef,
    version         => $VERSION,
    description     => 'Import and stage records from remote server. (Täti)',
};

## This is the minimum code required for a plugin's 'new' method
## More can be added, but none should be removed
sub new {
    my ( $class, $args ) = @_;

    ## We need to add our metadata here so our base class can access it
    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    ## Here, we call the 'new' method for our base class
    ## This runs some additional magic and checking
    ## and returns our actual $self
    my $self = $class->SUPER::new($args);

    return $self;
}
## This is the 'install' method. Any database tables or other setup that should
## be done when the plugin if first installed should be executed in this method.
## The installation method should always return true if the installation succeeded
## or false if it failed.
sub install() {
    my ( $self, $args ) = @_;

    return 1;
}

## This is the 'upgrade' method. It will be triggered when a newer version of a
## plugin is installed over an existing older version of a plugin
sub upgrade {
    my ( $self, $args ) = @_;

    return 1;
}

## This method will be run just before the plugin files are deleted
## when a plugin is uninstalled. It is good practice to clean up
## after ourselves!
sub uninstall() {
    my ( $self, $args ) = @_;

    return 1;
}

1;
