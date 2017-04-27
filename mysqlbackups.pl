#!/usr/bin/perl -w
#+------------------------------------------------------------------------+
#| Filename: mysqlbackups.pl                                              |
#| Authors : Patricio Rojas Ortiz - patricio-rojaso@outlook.com           |
#| Purpose : Backup of all mysql database. Generate file with format name |
#|           basename-date-time.sql. You must add it to the cron schema of|
#|           your server.                                                 |
#| Platform: Linux                                                        |
#| Packages: mysql-server. No additional packages/libraries are required  |
#| Revision: 2017-04-23 17:22:40                                          |
#| Version : 2017-01-25 13:58:55                                          |
#+------------------------------------------------------------------------+
#| This source file is subject to the The MIT License (MIT)               |
#| that is bundled with this package in the file LICENSE.txt.             |
#|                                                                        |
#| If you did not receive a copy of the license and are unable to         |
#| obtain it through the world-wide-web, please send an email             |
#| to patricio-rojaso@outlook.com so we can send you a copy immediately.  |
#+------------------------------------------------------------------------+

use constant CONS_VERSION  => '2017-01-25 13:58:55';

# You must customize the following lines according to your installation
use constant CONS_PATH_TMP =>'/tmp';
use constant CONS_USER =>'root';
use constant CONS_PASS =>'';
use constant CONS_PATH_OUTPUT=>'/backups/backups/mysql/';

use strict;
use warnings;
use diagnostics;

my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst );
my ( @a_databases, $sl_command, $sl_databases, $tmp );

	&sub_copyright();

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$year = $year+1900;
	$mon  = $mon + 1;

	chdir( CONS_PATH_TMP ) or die "$!";

  $sl_command	= "/bin/echo \"SELECT SCHEMA_NAME FROM information_schema.SCHEMATA\" > sql.sql" ;

	system($sl_command) == 0 or warn "system $sl_command failed: $?";

	$sl_command	= "/usr/bin/mysql -u" .CONS_USER ." -p".CONS_PASS." < sql.sql > databases.txt" ;
	system($sl_command) == 0 or warn "system $sl_command failed: $?";

	$sl_databases = &sub_file_load( CONS_PATH_TMP. "/databases.txt" );
	@a_databases  = split( "\n", $sl_databases );

	foreach  $tmp ( @a_databases ){

		if( length( $tmp )>0){

			if ($tmp  !~ /SCHEMA_NAME|information_schema|sys|performance_schema|mysql/){
				print "backups of database:($tmp)\n";
				$sl_databases = CONS_PATH_OUTPUT . sprintf("%04d%02d%02d-%02d%02d%2d-%s",  $year, $mon, $mday, $hour, $min, $sec, $tmp);
		    $sl_command 	= "/usr/bin/mysqldump -u ".CONS_USER . " -p" .CONS_PASS ." -B $tmp --single-transaction --flush-logs >".$sl_databases. ".sql";
				system($sl_command)== 0 or warn "system $sl_command failed: $?";
			}
		}
	}
	printf "done\n";
	exit;

# ------------------------------------------------------------------------------
sub sub_copyright(){

	print "\nmysqlbackups.pl V".CONS_VERSION.", Copyright 2016\n\n";

}

# ------------------------------------------------------------------------------

sub sub_file_load(){
  my $filename = shift;
  my ( @thisfile, $sl_return, $sl_line );

  print "sub_file_load: $filename ...\n";

  open (FILE, $filename);
  @thisfile = <FILE>;
  close (FILE);

  $sl_return = "";
  foreach $sl_line (@thisfile) {

          $sl_return = $sl_return .  $sl_line;
  }

  print "sub_file_load: ".length($sl_return)." Bytes of $filename\n";
  return $sl_return ;

}
