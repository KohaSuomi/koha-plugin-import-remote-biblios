package Koha::Plugin::Fi::KohaSuomi::ImportRemoteBiblios::Modules::FTP;

use Modern::Perl;
use Carp;
use Net::FTP;
use Scalar::Util qw( blessed );
use Try::Tiny;


=head1 FTP

Koha::FTP - Wrapper to Net::FTP to make dealing with FTP-connections so much fun!

=head1 SYNOPSIS

sub moveAFileToAnotherFtpDirectory {
    my ($filePath, $targetDirectory, $ftpcon) = @_;
    my($fileName, $dirs, $suffix) = File::Basename::fileparse( $filePath );

    try {

        my $ftp = Koha::FTP->new( Net::FTP->new() );

        my $currentDir = $ftp->getCurrentFtpDirectory();
        $ftp->changeFtpDirectory($targetDirectory, $ftp);
        $ftp->put($filePath, $ftp);
        $ftp->changeFtpDirectory($currentDir, $ftp);
        $ftp->delete($fileName, $ftp);

    } catch {
        if (blessed($_)){
            if ($_->isa('Koha::Exception::ConnectionFailed')) {
                warn $_->error()."\n";
            }
            elsif ($_->isa('Koha::Exception::LoginFailed')) {
                warn $_->error()."\n";
            }
            else {
                $_->rethrow();
            }
        }
        else {
            die $_;
        }
    };
}

=cut


=head new

    my $ftp = Koha::FTP->new();
    my $ftp = Koha::FTP->new( Net::FTP->new() );

=cut

sub new {
    my ($class, $self) = @_;
    $self = {} unless ($self);

    if (blessed $self && $self->isa('Net::FTP')) {
        my $ftpcon = $self;
        $self = {};
        $self->{_connection} = $ftpcon;
    }

    bless $self, $class;
    return $self;
}

=head connect
STATIC METHOD!

    FTP::connect({ Host => 10.0.0.23,
                    Passive => 0 ,
                    Port => 21,
                    Timeout => 10,
                }, $connectionId);

@PARAM1, Config HASH,
@PARAM2, String, vendor identifier or a ftp-connection specific identifier.
@RETURNS, Net::FTP-connection object
@THROWS Koha::Exception::LoginFailed
        Koha::Exception::ConnectionFailed
=cut

sub connect {
    my ($config, $connectionId) = @_;
    return _connectNetFTP($config, $connectionId);
}

sub _normalizeConfig {
    my ($config, $connectionId) = @_;
    my $normConfig = {
        Host => $config->{host},
        Passive => ($config->{protocol} =~ m/passive/) ? 1 : 0 ,
        Port => $config->{port} || 21,
        Timeout => $config->{timeout} || 10,
        Login => $config->{username},
        Password => $config->{password},
    };
    return %$normConfig;
}
sub _connectNetFTP {
    my ($config, $connectionId) = @_;

    my $ftpcon = Net::FTP->new(_normalizeConfig($config, $connectionId));
    unless ($ftpcon) {
        die "FTP:> Connecting to '$connectionId', cannot connect to '$connectionId' ftp server: $@";
    }

    if ($ftpcon->login(  $config->{username}, $config->{password}  )){
        return $ftpcon;
    }
    else {
        die "FTP:> Connecting to '$connectionId', cannot login to '$connectionId' ftp server: $@";
    }
    return undef;
}

sub getConnection {
    my ($self) = @_;
    return $self->{_connection};
}

sub quit {
    my ($self) = @_;
    $self->{_connection}->quit() if blessed($self->{_connection}) && $self->{_connection}->isa('Net::FTP');
}

=head get

    $ftp->get( $REMOTE_FILE [, $LOCAL_FILE [, $WHERE]] );

A wrapper for the Net::FTP::get() -function

@THROWS Koha::Exception::RemoteInvocation
=cut

sub get {
    my ($self, $REMOTE_FILE, $LOCAL_FILE, $WHERE) = @_;
    my $ftpcon = $self->getConnection();

    if ($ftpcon->get($REMOTE_FILE, $LOCAL_FILE, $WHERE)) {
        return 0; #Great! no errors!
    } else {
        die "FTP:> Something wrong get:ting '$REMOTE_FILE' from ftp server '".$self->{connectionId}."': ".$ftpcon->message;
    }
}

=head listFtpDirectory
@THROWS Koha::Exception::RemoteInvocation
=cut

sub listFtpDirectory {
    my ($self) = @_;
    my $ftpcon = $self->getConnection();

    if (my $ftpfiles = $ftpcon->ls()) {
        return $ftpfiles; #Great! no errors!
    } else {
        die "FTP:> Cannot get directory listing from ftp server '".$self->{connectionId}."': ".$ftpcon->message;
    }
}

=head put

    $ftp->put( $LOCAL_FILE [, $REMOTE_FILE ] );

A wrapper for the Net::FTP::put() -function

@THROWS Koha::Exception::RemoteInvocation
=cut

sub put {
    my ($self, $LOCAL_FILE, $REMOTE_FILE) = @_;
    my $ftpcon = $self->getConnection();

    if ($ftpcon->put($LOCAL_FILE, $REMOTE_FILE)) {
        return 0; #Great! no errors!
    } else {
        die "FTP:> Cannot put the file '$LOCAL_FILE' to ftp server '".$self->{connectionId}."': ".$ftpcon->message;
    }
}

=head changeFtpDirectory
@THROWS Koha::Exception::RemoteInvocation
=cut

sub changeFtpDirectory {
    my ($self, $directory) = @_;
    my $ftpcon = $self->getConnection();

    if ($ftpcon->cwd($directory) ) {
        return 0; #Great! no errors!
    } else {
        die "FTP:> Cannot change to the remote directory '$directory' in ftp server '".$self->{connectionId}."': ".$ftpcon->message;
    }
}

=head getCurrentFtpDirectory
@THROWS Koha::Exception::RemoteInvocation
=cut

sub getCurrentFtpDirectory {
    my ($self) = @_;
    my $ftpcon = $self->getConnection();

    if (my $cwd = $ftpcon->pwd() ) {
        return $cwd; #Great! no errors!
    } else {
        die "FTP:> Cannot get the remote working directory in ftp server '".$self->{connectionId}."': ".$ftpcon->message;
    }
}

=head delete

    $ftp->delete( $FILENAME );

A wrapper for the Net::FTP::delete() -function

@THROWS Koha::Exception::RemoteInvocation
=cut

sub delete {
    my ($self, $FILENAME) = @_;
    my $ftpcon = $self->getConnection();

    if ($ftpcon->delete($FILENAME)) {
        return 0; #Great! no errors!
    } else {
        die "FTP:> Cannot delete the file '$FILENAME' from ftp server '".$self->{connectionId}."': ".$ftpcon->message;
    }
}

1; #Happy nice joy fun!