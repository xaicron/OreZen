package OreZen::Flavor;

use strict;
use warnings;
use OreZen::Util;
use Data::Section::Simple;
use Class::Load qw/load_class/;

sub util { 'OreZen::Util' }

sub load {
    my ($class, $klass) = @_;
    $klass = __PACKAGE__."::$klass" unless substr($klass, 0, 1) eq '+';
    return $klass if load_class($klass);
}

sub gen {
    my ($class, %args) = @_;
    my $exclude_map = {
        map { $_ => 1 } @{ $args{excludes} || [] },
    };
    my $render = Data::Section::Simple->new($class);
    my $data = $render->get_data_section();
    for my $path (keys %$data) {
        next if $exclude_map->{$path};
        $class->util->try_mkpath($path);
        $class->util->write($path, $data->{$path});
    }
}

1;
__DATA__
