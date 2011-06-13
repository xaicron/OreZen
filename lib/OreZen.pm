package OreZen;

use strict;
use warnings;
use 5.008_001;
use Text::Wiki::Lite;
use Text::Wiki::Lite::Helper::HTML;
use URI::Escape;
use Regexp::Common qw(URI);

our $VERSION = '0.01';

my $wiki = Text::Wiki::Lite->new;
$wiki->add_inline(
    q|~~del~~|    => inline(q|~~|, 'del'),
    q|--ins--|    => inline(q|--|, 'ins'),
    q|//em//|     => inline(q|//|, 'em'),
    q|''strong''| => inline(q|''|, 'strong'),
    'link'          => inline_link([
        qr#\[i:([^\s]+)\]# => sub {
            my $src = shift;
            sprintf q|<img src="%s" alt="%1$s" title="%1$s" />|, $src;
        },
        qr#\[i:([^\s]+) ([^\]]+)\]# => sub {
            my ($src, $title) = @_;
            sprintf q|<img src="%s" alt="%s" title="%2$s" />|, $src, $title;
        },
        qr#\[($RE{URI}{HTTP})\]# => sub {
            my ($uri) = @_;
            sprintf q|<a href="%s">%s</a>|, $uri, $uri;
        },
        qr#\[($RE{URI}{HTTP}) ([^\]]+)]# => sub {
            my ($uri, $stuff) = @_;
            sprintf q|<a href="%s">%s</a>|, $uri, $stuff;
        },
        qr#($RE{URI}{HTTP})# => sub {
            my $uri = shift;
            sprintf q|<a href="%s">%s</a>|, $uri, $uri;
        },
    ]),
    'color' => sub {
        my $line = shift;
        my $percent = quotemeta '%%';
        $line =~ s#$percent([^:]+):((?:(?!$percent).)*)$percent#<span style="color: $1">$2</span>#go;
        return $line;
    }
);

$wiki->add_block(
    '* h1'             => line_block('*'x1, 'h1', { inline => 1 }),
    '** h1'            => line_block('*'x2, 'h2', { inline => 1 }),
    '*** h1'           => line_block('*'x3, 'h3', { inline => 1 }),
    '**** h1'          => line_block('*'x4, 'h4', { inline => 1 }),
    '***** h1'         => line_block('*'x5, 'h5', { inline => 1 }),
    '****** h1'        => line_block('*'x6, 'h6', { inline => 1 }),
    '= h1 ='           => line_block([('='x1)x2], 'h1', { inline => 1 }),
    '== h2 =='         => line_block([('='x2)x2], 'h2', { inline => 1 }),
    '=== h3 ==='       => line_block([('='x3)x2], 'h3', { inline => 1 }),
    '==== h4 ===='     => line_block([('='x4)x2], 'h4', { inline => 1 }),
    '===== h5 ====='   => line_block([('='x5)x2], 'h5', { inline => 1 }),
    '====== h6 ======' => line_block([('='x6)x2], 'h6', { inline => 1 }),
    'line-comment'     => line_block('###', ['<!--', '-->']),
    '{{{ ... }}}'      => simple_block('{{{', '}}}', 'pre', { escape => 1 }),
    '>>> ... <<<'      => simple_block('>>>', '<<<', 'section', { nest => 1, default_block => 1 }),
    'block-comment'    => simple_block('####', '####', ['<!--', '-->'], +{ escape => 1 }),
    'raw-html'         => simple_block('@@@@', '@@@@', ['<!-- raw html start -->', '<!-- raw html end -->']),
    '----'             => hr_block('----', '<hr />'),
    '||...||...||'     => table_block(['||', '*'], { inline => 0 }),
    '- or 1.'          => list_block(['-', => 'ul', qr|\d+\.| => 'ol'], 'li'),
#    'center-box'      => simple_block(),
);

$wiki->set_default_block(
    default_block('p', 1, { inline => 1, nest => 1 })
);

sub format {
    my $class = shift;
    return $wiki->format(@_);
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

OreZen -

=head1 SYNOPSIS

  use OreZen;

=head1 DESCRIPTION

OreZen is

=head1 AUTHOR

xaicron E<lt>xaicron@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2011 - xaicron

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
