#!/usr/bin/env perl 
use strict;
use warnings;
use English qw( -no_match_vars );
use 5.012;
use autodie;
use Template::Perlish qw< render >;
use Template;

my @elements;
{
   open my $oldout, '>&STDOUT';
   close STDOUT;
   for my $input (<*epub>) {
      (my $radix = $input) =~ s{\.epub$}{}mxs;
      push @elements, $radix;
      system {'unzip'} 'unzip', $input, 'cover.jpeg';
      rename 'cover.jpeg', "$radix.jpg";
   }
   open STDOUT, '>&', $oldout;
}

my $tt = Template->new();
$tt->process(\template(), {elements => \@elements});

sub template {
   return <<'END_OF_TEMPLATE';
<html>
   <head>
      <title>Flavio Poletti's ebooks</title>
   </head>
   <body>
      <h1 style="text-align: center">Flavio Poletti's ebooks</h1>
      <ul style="list-style: none">
      [% FOR radix = elements %]
         <li>
            <img style="height: 200px; float: left" src="[% radix | url %].jpg" alt="[% radix | html %]" />
            <div style="float:left; margin: 50px 1em">
               <p><a href="[% radix | url %].epub">[% radix | html %].epub</a></p>
               <p><a href="[% radix | url %].mobi">[% radix | html %].mobi</a></p>
            </div>
            <div style="clear: both"></div>
         </li>
      [% END %]
      </ul>
   </body>
</html>
END_OF_TEMPLATE
}

sub template_perlish {
   return <<'END_OF_TEMPLATE';
<html>
   <head>
      <title>Flavio Poletti's ebooks</title>
      <style>
ul { list-style: none }
      </style>
   </head>
   <body>
      <h1>Flavio Poletti's ebooks</h1>
      <ul>
      [% for my $radix (@{$variables{elements}}) {%]
         <li>
            <img style="height: 200px" src="[%= $radix %].jpg" alt="[%= $radix %]" />
            <a href="[%= $radix %].epub">[%= $radix %].epub</a>
            <a href="[%= $radix %].mobi">[%= $radix %].mobi</a>
         </li>
      [% } %]
      </ul>
   </body>
</html>
END_OF_TEMPLATE
}
