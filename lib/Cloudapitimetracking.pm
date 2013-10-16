package Cloudapitimetracking;

use Dancer ':syntax';
use Api::TimeTrackingEntity;
use Api::TimeTrackingPeriodEntry;
use Data::Dumper;

our $VERSION = '0.1';

my $url = config->{url}.'/'.config->{version}.'/'.config->{token};

get '/timetracking' => sub {
	template 'timetracking', {};
};

get '/timetrackingentity' => sub {
	my @entityGrid = ();
	template 'timetracking', {
		entityGrid => \@entityGrid,
	};
};

get '/timetrackingperiodentry' => sub {
	my $entryPage = Api::TimeTrackingPeriodEntry->getPage($url);
	print Dumper($entryPage);
	my @entryGrid = ();
	template 'timetracking', {
		entryGrid => $entryPage,
	};
};

true;
