# Koha-Suomi Import remote biblios

This plugin is for importing and staging biblios from remote server

# Downloading

From the release page you can download the latest \*.kpz file

# Installing

Koha's Plugin System allows for you to add additional tools and reports to Koha that are specific to your library. Plugins are installed by uploading KPZ ( Koha Plugin Zip ) packages. A KPZ file is just a zip file containing the perl files, template files, and any other files necessary to make the plugin work.

The plugin system needs to be turned on by a system administrator.

To set up the Koha plugin system you must first make some changes to your install.

    Change <enable_plugins>0<enable_plugins> to <enable_plugins>1</enable_plugins> in your koha-conf.xml file
    Confirm that the path to <pluginsdir> exists, is correct, and is writable by the web server
    Remember to allow access to plugin directory from Apache

    <Directory <pluginsdir>>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    Restart your webserver

Once set up is complete you will need to alter your UseKohaPlugins system preference. On the Tools page you will see the Tools Plugins and on the Reports page you will see the Reports Plugins.

# Configuring

Add configuration yaml file to path you prefer and fill parameters shown below. There is an example file in this repo.

    remoteId: uniqname
    host: ftp.com
    port: 21
    username: foo
    password: foobaa
    protocol: passive ftp
    basedir: /
    encoding: UTF-8
    format: MARCXML
    fileRegexp: 'B(\d{4})(\d{2})(\d{2})xml'
    localStorageDir: /var/spool/biblios
    stageFiles: 1
    commitFiles: 1
    matcher: 1

# Running the script

Set the script to crontab or run by hand

perl runImportRemoteBiblios.pl -c /etc/koha/importremotebiblios.yaml -v
