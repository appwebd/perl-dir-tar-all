# Perl dir Tar All (backups-all-directories in a recursive way)

Perl script that allows you to back up (in tar.gz format with date/time like filename) directories in a recursive way. This perl script was coded originally in 1996.

## Installation
```
git clone https://github.com/appwebd/perl-dir-tar-all.git
```

## Customize

You must customize the following according to your configuration:


```
a) Put this Perl script dir_tarall.pl in your home/bin directory or /use/local/bin for example.
b) What information, do you want backups. Open the filename example-of-use.sh and modify at your all satisfaction.
```

## Schedule Tasks on Linux (using Crontab)
Do the following command in your terminal console.
```
sudo crontab -e

```

add the following (like example):
```
0 0 * * * /home/<user account>/bin/dir_tarall.pl 2>&1 | mail -s "Cronjob ouput" yourname@yourdomain.com
```

## License
 dir_tarall.pl is licensed under The MIT License (MIT). Which means that you can use, copy, modify, merge, publish, distribute, sub license, and/or sell copies of the Software. But you always need to state that Patricio Rojas Ortiz is the original author of this Perl script.
