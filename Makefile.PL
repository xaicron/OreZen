use inc::Module::Install;
name 'OreZen';
all_from 'lib/OreZen.pm';

requires 'Text::Wiki::Lite';
requires 'Text::MicroTemplate';
requires 'File::Slurp';
requires 'Data::Section::Simple';
requires 'Getopt::Compact::WithCmd';
requires 'URI::Escape';
requires 'URI::Find::UTF8';
requires 'Class::Load';

install_script 'orezen';

test_requires 'Test::More', 0.96;

tests join q{ }, map { sprintf 't%s.t', '/*' x $_ } 1..3;
author_tests 'xt';

auto_set_repository();

WriteAll;
