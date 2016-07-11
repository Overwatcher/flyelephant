package Local::Tree;

use strict;
use warnings;
use utf8;
use DDP;

use FindBin qw($Bin);
use lib "$Bin/..";

use Local::Node;

sub new {
	my $class = shift;
	my $args = shift;
	my $root = Local::Node->new({
			word => $$args{begin},
			diff => 0,
			parent => undef});
	my @lastlevel;
	push (@lastlevel, $root);
	bless {root => $root, lastlevel => \@lastlevel}, $class;
}
sub build_level {
	my ($self, $dicts, $dict_fh, $end) = @_;
	my @lastlevel =();
	my $is_new = 0;
	my @solution = ();
	for my $node (@{ $$self{lastlevel} }) {
		my $somechild = $node->set_children($dicts, $dict_fh, $end);
		if (defined $somechild and $$somechild{word} eq $end) {
			my $curnode = $somechild;
			push @solution, $$curnode{word};
			while (defined $$curnode{parent}) {
				$curnode = $$curnode{parent};
				push @solution, $$curnode{word};
			}
			return \@solution;
		}
		if (scalar @{ $$node{children} } == 0 ) { next; }
		else {$is_new++;}
		push (@lastlevel, @{ $$node{children} });
	}
	if ($is_new == 0) {push @solution, '-1';}
	$$self{lastlevel} = \@lastlevel;
	return \@solution;

}
1;
