
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'MojoX-Routes-AsGraph',
  NAME      => 'MojoX::Routes::AsGraph',
  AUTHOR    => 'Pedro\ Melo\ \<melo\@cpan\.org\>',
  ABSTRACT  => 'Create a graph from a MojoX::Routes object',
  VERSION   => '0.04',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "Test::More" => '0',
    "Mojo" => '0',
    "Graph::Easy" => '0',
  },
);
