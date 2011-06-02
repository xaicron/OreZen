package OreZen::Util;

use strict;
use warnings;
use File::Basename qw/dirname/;
use File::Path qw/mkpath/;
use File::Slurp qw/write_file/;

sub try_mkpath {
    my ($class, $path) = @_;
    my $dir = dirname $path;
    unless (-e $dir) {
        mkpath $dir or die "Cannot mkpath '$dir': $!";
    }
}

sub write {
    my ($class, $path, @args) = @_;
    print "writing $path\n";
    write_file($path, @args);
}

1;
