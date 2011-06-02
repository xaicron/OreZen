package OreZen;

use strict;
use warnings;
use 5.008_001;
use URI::Escape;
use URI::Find::UTF8;
use Text::Wiki::Lite;

our $VERSION = '0.01';

my $finder = URI::Find::UTF8->new(sub {
    my ($uri, $orig_uri) = @_;
    return sprintf qq(<a href="%s">%s</a>), $uri, $orig_uri;
});

my $wiki = Text::Wiki::Lite->new;
$wiki->add_inline(
    # [url name] or url
    'link' => sub {
        my $line = shift;
        $line =~ s#\[([^\s]+) ([^\]]+)\]|([^\[]+)#
            my $url  = $1 || $3;
            my $text = $2;
            my $finder = URI::Find::UTF8->new(sub {
                my ($uri, $orig_uri) = @_;
                return sprintf qq(<a href="%s">%s</a>), $uri, $text ? $text : $orig_uri;
            });
            $finder->find(\$url);
            $url;
        #eg;
        return $line;
    },
    '~~del~~' => sub {
        my $line = shift;
        $line =~ s#~~([^~]+)~~#<del>$1</del>#g;
        return $line;
    },
    "'''~'''" => sub {
        my $line = shift;
        $line =~ s#'''([^']+)'''#<strong>$1</strong>#g;
        return $line;
    },
    "''~''" => sub {
        my $line = shift;
        $line =~ s#''([^']+)''#<em>$1</em>#g;
        return $line;
    },
);

$wiki->add_block(
    '*' => +{
        start => sub {
            my $line = shift;
            my $word = quotemeta '*' x 1;
            my $ret = $line =~ s|^$word (.*)$|sprintf '<h1 id="%s">%s</h1>', uri_escape_utf8($1), $1|oe ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|</h1>$| ? 1 : 0;
            return $line, $ret;
        },
        enabled_inline => 1,
    },
    '**' => +{
        start => sub {
            my $line = shift;
            my $word = quotemeta '*' x 2;
            my $ret = $line =~ s|^$word (.*)$|<h2>$1</h2>|o ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|</h2>$| ? 1 : 0;
            return $line, $ret;
        },
        enabled_inline => 1,
    },
    '***' => +{
        start => sub {
            my $line = shift;
            my $word = quotemeta '*' x 3;
            my $ret = $line =~ s|^$word (.*)$|<h3>$1</h3>|o ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|</h3>$| ? 1 : 0;
            return $line, $ret;
        },
        enabled_inline => 1,
    },
    '****' => +{
        start => sub {
            my $line = shift;
            my $word = quotemeta '*' x 4;
            my $ret = $line =~ s|^$word (.*)$|<h4>$1</h4>|o ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|</h4>$| ? 1 : 0;
            return $line, $ret;
        },
        enabled_inline => 1,
    },
    '*****' => +{
        start => sub {
            my $line = shift;
            my $word = quotemeta '*' x 5;
            my $ret = $line =~ s|^$word (.*)$|<h5>$1</h5>|o ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|</h5>$| ? 1 : 0;
            return $line, $ret;
        },
        enabled_inline => 1,
    },
    '******' => +{
        start => sub {
            my $line = shift;
            my $word = quotemeta '*' x 6;
            my $ret = $line =~ s|^$word (.*)$|<h6>$1</h6>|o ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|</h6>$| ? 1 : 0;
            return $line, $ret;
        },
        enabled_inline => 1,
    },
    '= h1 =' => +{
        start => sub {
            my $line = shift;
            my $ret = $line =~ s|^= (.*) =$|sprintf '<h1 id="%s">%s</h1>', uri_escape_utf8($1), $1|oe ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|</h1>$| ? 1 : 0;
            return $line, $ret;
        },
        enabled_inline => 1,
    },
    '== h2 ==' => +{
        start => sub {
            my $line = shift;
            my $ret = $line =~ s|^== (.*) ==$|sprintf '<h2 id="%s">%s</h2>', uri_escape_utf8($1), $1|oe ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|</h2>$| ? 1 : 0;
            return $line, $ret;
        },
        enabled_inline => 1,
    },
    '=== h3 ===' => +{
        start => sub {
            my $line = shift;
            my $ret = $line =~ s|^=== (.*) ===$|sprintf '<h3 id="%s">%s</h3>', uri_escape_utf8($1), $1|oe ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|</h3>$| ? 1 : 0;
            return $line, $ret;
        },
        enabled_inline => 1,
    },
    '==== h4 ====' => +{
        start => sub {
            my $line = shift;
            my $ret = $line =~ s|^==== (.*) ====$|sprintf '<h4 id="%s">%s</h4>', uri_escape_utf8($1), $1|oe ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|</h4>$| ? 1 : 0;
            return $line, $ret;
        },
        enabled_inline => 1,
    },
    '===== h5 =====' => +{
        start => sub {
            my $line = shift;
            my $ret = $line =~ s|^===== (.*) =====$|sprintf '<h5 id="%s">%s</h5>', uri_escape_utf8($1), $1|oe ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|</h5>$| ? 1 : 0;
            return $line, $ret;
        },
        enabled_inline => 1,
    },
    '===== h6 =====' => +{
        start => sub {
            my $line = shift;
            my $ret = $line =~ s|^====== (.*) ======$|sprintf '<h6 id="%s">%s</h6>', uri_escape_utf8($1), $1|oe ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|</h6>$| ? 1 : 0;
            return $line, $ret;
        },
        enabled_inline => 1,
    },
    '----' => +{
        start => sub {
            my $line = shift;
            my $ret = $line =~ s|^----$|<hr />| ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ m|^<hr />$| ? 1 : 0;
            return $line, $ret;
        },
    },
    '{{{ ... }}}' => +{
        start => sub {
            my $line = shift;
            my $ret = $line =~ s|\{{{$|<pre>| ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ s|\}}}$|</pre>| ? 1 : 0;
            return $line, $ret;
        },
        enabled_escape => 1,
        foldline => 1,
    },
    '|...|...|...|' => +{
        start => sub {
            my ($line, $stash) = @_;
            my $ret;
            if ($line =~ s/^(\|.*)\|$/$1/) {
                $line =~ s#\|([^|]+)#
                    my $matched = $1;
                    $matched =~ s/^\s+|\s+$//g;
                    my $result;
                    if ($matched =~ s/^\*//) {
                        $result = "<th>$matched</th>";
                    }
                    else {
                        $result = "<td>$matched</td>";
                    }
                    "$result\n";
                #ge;
                $line = "<table>\n<tr>\n$line</tr>";
                $ret = 1;
            }
            return $line, $ret;
        },
        between => sub {
            my ($line, $stash, $parent_cb) = @_;
            if ($line =~ s/^(\|.*)\|$/$1/) {
                $line =~ s#\|\s*([^|]+)\s*#
                    my $matched = $1;
                    $matched =~ s/^\s*|\s*$//g;
                    "<td>$matched</td>\n";
                #ge;
                $line = "<tr>\n$line</tr>";
                $stash->{finished} = 0;
            }
            elsif ($parent_cb->($line)) {
                $stash->{finished} = 1;
            }
            else {
                $stash->{finished} = 1;
            }
            return $line;
        },
        end => sub {
            my ($line, $stash) = @_;
            my $ret = $stash->{finished} ? 1 : 0;
            $line = '</table>' if $ret;
            return $line, $ret;
        },
        enabled_inline => 1,
        foldline => 1,
    },
    '- or 1. or' => +{
        start => sub {
            my ($line, $stash) = @_;
            my $ret;
            if ($line =~ s/^(\s*)(-|\d+\.) (.*)/$3/) {
                $stash->{indent} = length $1;
                my $tag;
                $stash->{start_tag} = $tag = $2 eq '-' ? 'ul' : 'ol';
                $line = "<$tag>\n<li>$line</li>";
                $ret = 1;
            }
            return $line, $ret;
        },
        between => sub {
            my ($line, $stash) = @_;
            if ($line =~ /^(\s*)(-|\d+\.) (.*)/) {
                my $current_indent = length $1;
                my $start_tag = $2 eq '-' ? 'ul' : 'ol';
                my $text = $3;
                if ($stash->{indent} < $current_indent) {
                    $line = "<$start_tag>\n<li>$text</li>";
                    push @{$stash->{_indent}}, $stash->{indent};
                    push @{$stash->{_start_tag}}, $start_tag;
                    $stash->{indent} = $current_indent;
                }
                elsif ($stash->{indent} > $current_indent) {
                    my @end_tags;
                    while (my $indent = pop @{$stash->{_indent}}) {
                        my $tag = pop @{$stash->{_start_tag}};
                        if ($indent >= $current_indent) {
                            push @end_tags, $tag;
                        }
                        else {
                            last;
                        }
                    }
                    my $end_tag = join '', map { "</$_>\n" } @end_tags;
                    $line = "$end_tag<li>$text</li>";
                    $stash->{indent} = $current_indent;
                }
                else {
                    $line = "<li>$text</li>";
                }
            }
            else {
                $stash->{finished} = 1;
            }
            return $line;
        },
        end => sub {
            my ($line, $stash) = @_;
            my $ret = 0;
            if ($stash->{finished}) {
                my @end_tags = ($stash->{start_tag});
                while (my $indent = pop @{$stash->{_indent}}) {
                    my $tag = pop @{$stash->{_start_tag}};
                    push @end_tags, $tag;
                }
                my $end_tag = join "\n", map { "</$_>" } @end_tags;
                $stash->{NEXT_LINE} = $line;
                $line = $end_tag;
                $ret = 1;
            }
            return $line, $ret;
        },
        foldline => 1,
    },
    '>>> ~ <<<' => +{
        start => sub {
            my $line = shift;
            my $ret = $line =~ s#^>>>$#<section># ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ s#^<<<$#</section># ? 1 : 0;
            return $line, $ret;
        },
        enabled_nest => 1,
        enabled_default_block => 1,
    },
    'line-comment' => +{
        start => sub {
            my ($line, $stash) = @_;
            my $ret = $line =~ s/^### (.*)/<!--  $1 -->/;
            $stash->{ret} = 1;
            return $line, $ret;
        },
        end => sub {
            my ($line, $stash) = @_;
            return $line, $stash->{ret};
        },
    },
    'block-comment' => +{
        start => sub {
            my $line = shift;
            my $ret = $line =~ s/^####$/<!--/ ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ s/^####$/-->/ ? 1 : 0;
            return $line, $ret;
        },
        enabled_escape => 1,
    },
    'raw-html' => +{
        start => sub {
            my $line = shift;
            my $ret = $line =~ s/^\@\@\@\@$/<!-- raw html start -->/ ? 1 : 0;
            return $line, $ret;
        },
        end => sub {
            my $line = shift;
            my $ret = $line =~ s/^\@\@\@\@$/<!-- raw html end -->/ ? 1 : 0;
            return $line, $ret;
        },
    },
);

$wiki->set_default_block(+{
    start => sub {
        my ($line, $stash) = @_;
        my $ret = 0;
        unless ($line =~ /^\s*$/) {
            $line = "<p>\n$line";
            $stash->{first} = 1;
            $ret = 1;
        }
        return $line, $ret;
    },
    between => sub {
        my ($line, $stash, $parent_cb) = @_;
        if ($stash->{first}) {
            delete $stash->{first};
        }
        elsif ($line =~ /^\s*$/) {
            $stash->{finished} = 1;
        }
        else {
            if ($parent_cb->($line)) {
                $stash->{finished} = 1;
            }
            else {
                $line = "<br />$line";
            }
        }
        return $line;
    },
    end => sub {
        my ($line, $stash) = @_;
        my $ret;
        if ($stash->{finished}) {
            $line = "</p>";
            $ret = 1;
        }
        return $line, $ret;
    },
#    merge_pre      => 1,
    enabled_inline => 1,
    enabled_nest   => 1,
});

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
