package ApiController::TimeTrackingController

use strict;
use warnings;
use Api::TimeTrackingPeriodEntry;

###############################################################################
sub getEntries{
	my ($self, $url) = @_;
	my %orgs = ();
	my $entryPage = Api::TimeTrackingPeriodEntry->getPage($url);

}

###############################################################################
sub getEntities{

}

###############################################################################
sub setEntity{

}

###############################################################################
sub setEntry{

}

###############################################################################
1;
