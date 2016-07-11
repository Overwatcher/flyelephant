package Local::Node;

use strict;
use warnings;
use utf8;
use DDP;
binmode(STDOUT,':utf8');

sub new {
	my $class = shift;
	my $args = shift;
	bless $args, $class;
}

sub set_children {
	my ($self, $dicts, $dict_fh, $end) = @_;
	$$self{children} = [];
	my $n = scalar split '', $$self{word};
	my $child;
	if ($$self{diff} == 0) {
		while (my $word = <$dict_fh>) {
			chomp $word;
			my $k = $self->diff_count($word);
			if ($k < 0) { next; }
			push(@{ $$dicts[$k] }, $word) unless ($k == 1 or $k == 0);
			$child = __PACKAGE__->new ({
					word => $word,
					diff => $k,
					children => [],
					parent => $self});
			if ($k == 1) {
				push (@{ $$self{children} }, $child);			
				if ($$child{word} eq $end) { return $child; }
			}
		}
		return undef;
	}
	for my $k (($$self{diff}-1)..($$self{diff}+1)) {
		if ($k < 0 or $k > $n) { next; }
		my  $j = 0;
		if (!defined $$dicts[$k]) {next;}
		for ($j; $j < scalar @{ $$dicts[$k] }; $j++) { 
			my $maybe_child = ${ $$dicts[$k] }[$j]; 
			if ( $self->diff_count($maybe_child) == 1 ) {
				my $child =__PACKAGE__->new ({
						word => $maybe_child,
						diff => $k,
						parent => $self});
				push(@{ $$self{children} }, $child);
				splice (@{ $$dicts[$k] }, $j, 1); 
				$j--;
				if ($$child{word} eq $end) { return $child; }
			}
		}
	}
	return undef;
}

sub diff_count {
	my ($self, $compare) = @_;
	my $word = $$self{word};
	my @word = split '', $word;
	my @compare = split '', $compare;
	if ( @word != @compare ) { return -1; }
	my $count = 0;
	for (my $i = 0; $i <= $#word; $i++) {
		if ($word[$i] ne $compare[$i]) { $count++; }
	}
	return $count;
	
}
1;
