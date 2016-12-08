requires 'Class::Load';
requires 'Data::Section::Simple';
requires 'File::Path';
requires 'File::Slurp';
requires 'Getopt::Compact::WithCmd';
requires 'HTML::Entities';
requires 'Regexp::Common';
requires 'Text::Wiki::Lite';
requires 'Text::Wiki::Lite::Helper::HTML';
requires 'parent';
requires 'perl', '5.008_001';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};
