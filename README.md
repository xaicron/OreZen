# NAME

OreZen - oreore presentation generator

# SYNOPSIS

    use OreZen;
    my $text = <<SYNTAX;
    >>>
    = h1 =
    - foo
    - bar
      - baz
    <<<
    SYNTAX
    
    print OreZen->format($text);

# DESCRIPTION

OreZen is presentation generator and has wiki syntax.

# SYNTAX

## Inline

- auto link

        http://example.com
        # <a href="http://example.com">http://example.com</a>
        
        [http://example.com]
        # <a href="http://example.com">http://example.com</a>
        
        [http://example.com example.com]
        # <a href="http://example.com">example.com</a>
        
        [i:http://example.com/img.jpg]
        # <img src="http://example.com/img.jpg" alt="http://example.com/img.jpg" title="http://example.com/img.jpg" />
        
        [i:http://example.com/img.jpg img.jpg]
        # <img src="http://example.com/img.jpg" alt="img.jpg" title="img.jpg" />

- del

        ~~del~~
        # <del>del</del>

- ins

        --ins--
        # <ins>ins</ins>

- strong

        **strong**
        # <strong>strong</strong>

- em

        ''em''
        # <em>em</em>

- code

        {{code}}
        # <code>code</code>

- color

        %%red:this is red%%
        # <span style="color: red">this is red</span>

## Block

- section

        >>>
        new section
        <<<
        # <section>
        # <p>new section</p>
        # </section>

- h1, h2, h3

        * h1
        ** h2
        *** h3
        # <h1>h1</h1>
        # <h2>h2</h2>
        # <h3>h3</h3>

        = h1 =
        == h2 ==
        === h3 ===
        # <h1>h1</h1>
        # <h2>h2</h2>
        # <h3>h3</h3>

- pre

        {{{
        print "Hi!"
        }}}
        # <pre>
        # print &quot;Hi!&quot;
        # </pre>

- list

        - foo
        - bar
          1. hoge
          1. fuga
        - baz
        # <ul>
        # <li>foo</li>
        # <li>bar</li>
        # <ol>
        # <li>hoge</li>
        # <li>fuga</li>
        # </ol>
        # <li>baz</li>
        # </ul>

- hr

        ----
        # <hr />

- table

        || *foo || *bar || *baz ||
        || hoge || fuga || piyo ||
        # <table>
        # <tr>
        # <th>foo</th>
        # <th>bar</th>
        # <th>baz</th>
        # </tr>
        # <tr>
        # <td>hoge</td>
        # <td>fuga</td>
        # <td>piyo</td>
        # </tr>
        # </table>

- raw html

        @@@@
        <p>here is <span style="color: green">free</span> space</p>
        @@@@
        # <!-- raw html start -->
        # <p>here is <span style="color: green">free</span> space</p>
        # <!-- raw html end -->

- comment

        ####
        block style
        ####
        <!--
        block style
        -->
        
        ### line style
        <!-- line style -->

# AUTHOR

xaicron <xaicron@cpan.org>

# COPYRIGHT

Copyright 2011 - xaicron

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
