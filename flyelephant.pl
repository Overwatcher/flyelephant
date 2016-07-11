#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin";
use Local::Tree;
use utf8;
binmode(STDOUT, ':utf8');
my $btime = time;
open (my $dict_fh, "<:encoding(utf8)", "dict.txt") or die "$!";

open (my $in, "<:encoding(utf8)", "input.txt") or die "$!";

open (my $out, ">:encoding(utf8)", "output.txt") or die "$!";

my $begin = <$in>;
my $end = <$in>;
chomp $begin;
chomp $end;

my $tree = Local::Tree->new({
		begin => $begin});
my $is_solution = [];
my @dicts;
my $nosol = 0;
while (@$is_solution == 0) {
	$is_solution = $tree->build_level(\@dicts, $dict_fh, $end);
	if (@$is_solution != 0 and $$is_solution[0] eq '-1') {$nosol = 1;}
} 

if ($nosol == 1)  { print $out "No Solution";
       	my $etime = time; $etime-= $btime; warn $etime; 
	exit 0;
}

my $chain = pop @$is_solution;

while (defined $chain) {
	print $out "$chain ";
} continue {$chain = pop @$is_solution;}
    	my $etime = time; $etime-= $btime; warn $etime; 
	

