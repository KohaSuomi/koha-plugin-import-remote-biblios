#!/bin/bash

kohaplugindir="$(grep -Po '(?<=<pluginsdir>).*?(?=</pluginsdir>)' $KOHA_CONF)"
kohadir="$(grep -Po '(?<=<intranetdir>).*?(?=</intranetdir>)' $KOHA_CONF)"

rm -r $kohaplugindir/Koha/Plugin/Fi/KohaSuomi/ImportRemoteBiblios
rm $kohaplugindir/Koha/Plugin/Fi/KohaSuomi/ImportRemoteBiblios.pm

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -s "$SCRIPT_DIR/Koha/Plugin/Fi/KohaSuomi/ImportRemoteBiblios" $kohaplugindir/Koha/Plugin/Fi/KohaSuomi/ImportRemoteBiblios
ln -s "$SCRIPT_DIR/Koha/Plugin/Fi/KohaSuomi/ImportRemoteBiblios.pm" $kohaplugindir/Koha/Plugin/Fi/KohaSuomi/ImportRemoteBiblios.pm

rm $kohadir/misc/cronjobs/run_import_remote_biblios.pl
ln -s $kohaplugindir/Koha/Plugin/Fi/KohaSuomi/ImportRemoteBiblios/cronjobs/run_import_remote_biblios.pl $kohadir/misc/cronjobs/run_import_remote_biblios.pl

perl $kohadir/misc/devel/install_plugins.pl

