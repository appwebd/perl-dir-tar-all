
#!/usr/bin/perl -w
#+------------------------------------------------------------------------+
#| Filename: dir_tarall.pl                                                |
#| Authors : Patricio Rojas Ortiz - patricio-rojaso@outlook.com           |
#| Purpose : Perl script that allows you to back up (in tar.gz format with|
#|           date/time like filename) directories in a recursive way.     |
#|                                                                        |
#| Platform: Linux                                                        |
#|                                                                        |
#| Packages: packages/libraries required: File::Find                      |
#| Revision: 2004-03-26 03:04:48                                          |
#| Version : 2004-03-26 03:04:48                                          |
#+------------------------------------------------------------------------+
#| This source file is subject to the The MIT License (MIT)               |
#| that is bundled with this package in the file LICENSE.txt.             |
#|                                                                        |
#| If you did not receive a copy of the license and are unable to         |
#| obtain it through the world-wide-web, please send an email             |
#| to patricio-rojaso@outlook.com so we can send you a copy immediately.  |
#+------------------------------------------------------------------------+

use constant CONS_VERSION  => '2004-03-26 03:04:48';

use strict;
use warnings;
use diagnostics;

use File::Find;

my ( $sl_dir_origen, $sl_dir_destino, $sl_ddmmyyhhmmss, $sl_version);
my ( $sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) ;
my ( $sl_command );

	$sl_version 		= "1.0";
	$sl_dir_origen  = $ARGV[0];

	if (	$sl_dir_origen eq ".." or
		$sl_dir_origen eq "."  or
		$sl_dir_origen eq "" ){
	    chomp( $sl_dir_origen = `pwd`);
  }

	$sl_dir_destino = $sl_dir_origen . "\/backups\/backups";

  if ($sl_dir_destino eq ".." or
    $sl_dir_destino eq "."  or
    $sl_dir_destino eq ""){
    chomp( $sl_dir_destino = `pwd` );
    $sl_dir_destino = $sl_dir_destino . "\/backups\/backups"
  }

  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
  $year = $year+1900;

  $mon = $mon + 1;
  $sl_ddmmyyhhmmss = sprintf("%04d%02d%02d-%02d%02d%02d", $year, $mon, $mday, $hour, $min, $sec);
  $sl_dir_destino  = sprintf("%s-%04d-%02d-%02d_%02d%02d%02d", $sl_dir_destino, $year, $mon, $mday, $hour, $min, $sec);

  if  ( ! -e $sl_dir_destino ){
		$sl_command = sprintf("mkdir -p %s", $sl_dir_destino);
		system( $sl_command );
  }


printf "Directory source:%s\nDirectory target:%s\n", $sl_dir_origen, $sl_dir_destino;

&tar_AllDir( $sl_dir_origen, $sl_dir_destino );

printf "done\n";

# =====================================================================
sub help(){
	print "taralldir.pl $sl_version, Copyright 2004-2005 Patricio Rojas Ortiz\n";
	print "usage : dir_tarall.pl <src_dir> <dst_dir>";
	exit(3);
}

# =====================================================================
sub tar_AllDir(){

    my ( $sl_dir_origen, $sl_dir_destino ) = @_;
    my ( $il_contador, @a_files, $sl_command, $sl_archivo_path);
    my ( $sl_archivo_orig, $sl_archivo_dest ) ;

    opendir( DIR, $sl_dir_origen ) or die "Error 1: $!\n";
    @a_files = readdir( DIR );
    closedir( DIR );


    if ( substr $sl_dir_origen,length( $sl_dir_origen )-1,1 eq "/") {
			$sl_dir_origen = substr $sl_dir_origen,1,length( $sl_dir_origen ) - 1;
    }

    $il_contador = 0;
    while( $il_contador < @a_files ){

		    $sl_archivo_orig = $a_files[ $il_contador ];
		    $sl_archivo_dest = $sl_ddmmyyhhmmss . "-" . $a_files[ $il_contador ];
		    $sl_archivo_path = $sl_dir_origen .'/'. $sl_archivo_orig;

		    if(	($sl_archivo_orig ne "." ) and
				    ($sl_archivo_orig ne "..") and
				    ($sl_archivo_orig ne ""  ) and
				    (-e $sl_archivo_path) and
				    (($sl_archivo_orig !~ /backup/))
		    ){

								$sl_archivo_orig =~ s/\ /\\ /g;
								$sl_archivo_path =~ s/\ /\\ /g;

								$sl_command = sprintf("tar zchf %s\/%s.tar.gz %s",$sl_dir_destino, $sl_archivo_dest, $sl_archivo_path );
								printf ("tar zcf %s ...\n", $sl_archivo_orig) ;

								system( $sl_command );
		    }
		    $il_contador++;

    }
}
